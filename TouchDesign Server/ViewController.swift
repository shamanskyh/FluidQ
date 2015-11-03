//
//  ViewController.swift
//  TouchDesign Server
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
    
    /// an ordered list of all commands sent
    private var previousCommands: [Command] = []
    
    let multipeerManager = MultipeerManager()
    
    /// a file descriptor to write to the serial port
    var serialFileDescriptor: CInt? {
        didSet {
            consoleConnectionStatus = (serialFileDescriptor != -1)
        }
    }
    
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
        
        // actually send the command to the serial port
        // TODO: Handle modifier keys
        // TODO: Higher baud rate?
        if let serial = serialFileDescriptor {
            let stringToSend = String(command.keystrokes.map({ $0.keyEquivalent }))
            write(serial, stringToSend, stringToSend.characters.count)
        }
        
        // append onto the array
        previousCommands.append(command)
        
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
        multipeerManager.delegate = self
        
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
    }
}

extension ViewController: MultipeerManagerDelegate {
    func connectedDevicesChanged(manager: MultipeerManager, connectedDevices: [String]) {
        NSLog("%@", connectedDevices)
        iOSConnectionStatus = connectedDevices.count > 0
    }
    
    func commandDidSend(manager: MultipeerManager, command: Command) {
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.sendCommandToBoard(command)
        }
        NSLog("%@", command)
    }
}

// MARK: - TableView DataSource and Delegate
// Note that I tried to use cocoa bindings, but they couldn't keep up with the fast-paced
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