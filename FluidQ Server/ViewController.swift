//
//  ViewController.swift
//  FluidQ Server
//
//  Created by Harry Shamansky on 9/29/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import Cocoa
import MultipeerConnectivity
import IOKit
import IOKit.serial

class ViewController: NSViewController {

    /// the table view of previous commands (and its scroll container)
    @IBOutlet weak var scrollView: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    
    /// connection status label
    @IBOutlet weak var statusLabel: NSTextField!
    
    /// selection label
    @IBOutlet weak var selectionLabel: NSTextField!
    
    /// the drop target
    @IBOutlet weak var dropView: DropView!
    
    /// an ordered list of all commands sent
    private var previousCommands: [Command] = []
    
    /// the selected channels
    private var selectedChannels: [Int] = []
    private var colorChangingSelection = false
    
    let multipeerManager = MultipeerManager()
    let oscServer = OSCServer()
    
    /// a file descriptor to write to the serial port
    var serialFileDescriptor: CInt? {
        didSet {
            consoleConnectionStatus = (serialFileDescriptor != -1)
        }
    }
    
    /// a queue of serial write commands
    let serialWriteQueue = NSOperationQueue()
    
    /// variable that tracks iOS connection status
    private var iOSConnectionStatus: Bool = false {
        didSet {
            updateConnectionLabel()
        }
    }
    
    /// variable that tracks console connection status
    private var consoleConnectionStatus: Bool = false  {
        didSet {
            updateConnectionLabel()
        }
    }
    
    /// updates the UI when connections change
    private func updateConnectionLabel() {
        statusLabel.stringValue = "📱 " + (iOSConnectionStatus ? "Connected" : "Disconnected") + "      ⌨️ " + (consoleConnectionStatus ? "Connected" : "Disconnected")
    }
    
    /// sends a command to the HID device and displays it in the list
    /// - Parameter command: the command to send
    internal func sendCommandToBoard(command: Command) {
        
        // check for missing selection
        var filteredCommand: Command?
        if command.requiresSelection && selectedChannels.count == 0 {
            filteredCommand = Command(withKeystrokes: [Keystroke(identifier: "missingSelection", keyEquivalent: " ", plaintext: "Select channel(s) on magic sheet first")])
        } else if command.requiresColorChangingChannelSelection && !colorChangingSelection {
            filteredCommand = Command(withKeystrokes: [Keystroke(identifier: "missingSelection", keyEquivalent: " ", plaintext: "Select color changing channel(s) on magic sheet first")])
        } else {
            filteredCommand = command
        }
        
        // actually send the command to the serial port
        // TODO: Handle modifier keys
        // TODO: Higher baud rate?
        if let serial = serialFileDescriptor where (filteredCommand?.keystrokes.first?.identifier != "missingSelection") {
            let stringToSend = String(filteredCommand!.keystrokes.map({ $0.keyEquivalent }))
            let groupedByDelay = stringToSend.characters.split(Character(UnicodeScalar(29))).map(String.init)
            if groupedByDelay.count == 1 {
                serialWriteQueue.addOperationWithBlock({
                    write(serial, stringToSend, stringToSend.characters.count)
                })
            } else {
                for delayGroup in groupedByDelay {
                    serialWriteQueue.addOperationWithBlock({
                        write(serial, delayGroup, delayGroup.characters.count)
                        usleep(50000)   // delay 0.04 seconds
                    })
                }
            }
        }
        
        // append onto the array
        previousCommands.append(filteredCommand!)
        
        // only remember the last 50 commands
        if previousCommands.count > 50 {
            previousCommands.removeFirst()
        }

        // update the table view
        tableView.reloadData()
        
        // animate the scroll
        scrollView.hasVerticalScroller = false
        NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext) -> Void in
            context.duration = 0.5
            context.allowsImplicitAnimation = true
            self.tableView.scrollRowToVisible(self.tableView.numberOfRows - 1)
            }, completionHandler: {
                self.scrollView.hasVerticalScroller = true
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        multipeerManager.serverDelegate = self
        serialWriteQueue.maxConcurrentOperationCount = 1    // queue must be serial
        
        // Not sure why this AppKit class doesn't seem to be updated using
        // Swift conventions yet...
        tableView.setDataSource(self)
        tableView.setDelegate(self)
        
        // find the USB port. This could be done better than guess-and-check...
        serialFileDescriptor = open("/dev/cu.usbmodem1411", O_RDWR | O_NOCTTY | O_NONBLOCK)
        if (consoleConnectionStatus == false) {
            // try other port
            serialFileDescriptor = open("/dev/cu.usbmodem1421", O_RDWR | O_NOCTTY | O_NONBLOCK)
        }
        
        dropView.delegate = self
        
        // begin listening for OSC messages from I-CubeX Sensors
        oscServer.delegate = self
        oscServer.listen(7000)
        
    }
}

extension ViewController: MultipeerManagerServerDelegate {
    func connectedDevicesDidChange(manager: MultipeerManager, connectedDevices: [String]) {
        NSLog("%@", connectedDevices)
        iOSConnectionStatus = connectedDevices.count > 0
    }
    
    func commandDidSend(manager: MultipeerManager, command: Command) {
        // run this on the main queue since it updates the UI
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.sendCommandToBoard(command)
        }
        NSLog("%@", command)
    }
    
    func selectionDidSend(manager: MultipeerManager, selection: Selection) {
        selectedChannels = selection.selectedChannels.sort()
        colorChangingSelection = selection.isColorChangingCapable
        
        // optimize single channels into contiguous ranges
        var tuples: [(Int, Int)] = []
        if selectedChannels.count > 0 {
            var lastChannel = selectedChannels.first!
            var currentTuple = (selectedChannels.first!, selectedChannels.first!)
            for channel in selectedChannels {
                if channel == lastChannel || (channel == lastChannel + 1) {
                    currentTuple = (currentTuple.0, channel)
                } else {
                    tuples.append(currentTuple)
                    currentTuple = (channel, channel)
                }
                lastChannel = channel
            }
            tuples.append(currentTuple)
        }
        
        let command = generateCommand(tuples)
        
        // update the selection label
        if tuples.count > 0 {
            selectionLabel.stringValue = command.description.stringByReplacingOccurrencesOfString(" Thru " , withString: "-").stringByReplacingOccurrencesOfString(" + ", withString: ", ").stringByReplacingOccurrencesOfString("•", withString: "")
        } else {
            selectionLabel.stringValue = ""
        }
        
        // run this on the main queue since it updates the UI
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.sendCommandToBoard(command)
        }
    }
}

// MARK: OSCServerDelegate Protocol Conformance
extension ViewController: OSCServerDelegate {
    func handleMessage(message: OSCMessage!) {
        
        let value = message.arguments.first! as! Int
        
        // assume intensity first
        if message.address == "/input1" {
            let convertedValue = Int((Double(value) / 127) * 100)
            let keystrokes = [kAtKeystroke] + doubleToKeystrokes(Double(convertedValue), padZeros: true) + [kEnterKeystroke]
            let command = Command(withKeystrokes: keystrokes)
            command.requiresSelection = true
            sendCommandToBoard(command)
        } else if message.address == "/input2" {    // then try color
            let convertedValue = Int((Double(value) / 127) * 360)
            //let saturationKeystrokes = kSaturationKeystrokes + [kAtKeystroke, kFullKeystroke]
            let hueKeystrokes = kHueKeystrokes + [kAtKeystroke] + doubleToKeystrokes(Double(convertedValue), padZeros: true)
            let fullKeystrokes = hueKeystrokes + [kEnterKeystroke, kDelayFunctionKeystroke]
            let command = Command(withKeystrokes: fullKeystrokes)
            command.requiresSelection = true
            command.requiresColorChangingChannelSelection = true
            sendCommandToBoard(command)
        }
    }
}

// MARK: - TableView DataSource and Delegate
// I tried to use cocoa bindings, but they couldn't keep up with the fast-paced
// insertions and deletions for some reason...
extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return previousCommands.count
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 26.0
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier("TableCell", owner: self) as! NSTableCellView
        cell.textField?.stringValue = previousCommands[row].description
        return cell
    }
    
}

extension ViewController: DropViewDelegate {
    func sendRawFile(text: String) {
        
        // convert the tab delimited values into Instruments and send the array
        // borrowed from Precircuiter
        // http://github.com/shamanskyh/Precircuiter
        var headers: [String] = []
        var finishedHeaders: Bool = false
        var currentKeyword: String = ""
        var currentPosition: Int = 0
        var currentInstrument: Instrument = Instrument(UID: nil, location: nil)
        
        var lights: [Instrument] = []
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            for char in text.characters {
                if !finishedHeaders {
                    if char == "\t" {
                        headers.append(currentKeyword)
                        currentKeyword = ""
                    } else if char == "\n" || char == "\r" || char == "\r\n" {
                        headers.append(currentKeyword)
                        currentKeyword = ""
                        finishedHeaders = true
                    } else {
                        currentKeyword.append(char)
                    }
                } else {
                    if char == "\t" {
                        
                        guard currentPosition < headers.count else {
                            // TODO: error handling
                            return
                        }
                        
                        do {
                            try addPropertyToInstrument(&currentInstrument, propertyString: headers[currentPosition++], propertyValue: currentKeyword)
                        } catch {
                            // TODO: error handling
                            return
                        }
                        
                        currentKeyword = ""
                    } else if char == "\n" || char == "\r" || char == "\r\n" {
                        
                        guard currentPosition < headers.count else {
                            // TODO: error handling
                            return
                        }
                        
                        // finish the last property
                        do {
                            try addPropertyToInstrument(&currentInstrument, propertyString: headers[currentPosition], propertyValue: currentKeyword)
                        } catch {
                            // TODO: error handling
                            return
                        }
                        
                        currentKeyword = ""
                        currentPosition = 0
                        if currentInstrument.deviceType == .Light {
                            lights.append(currentInstrument)
                        }
                        currentInstrument = Instrument(UID: nil, location: nil)
                    } else {
                        currentKeyword.append(char)
                    }
                }
            }
            self.multipeerManager.sendInstruments(lights)
        }
    }
}