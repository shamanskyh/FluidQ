//
//  StaticMagicSheetViewController.swift
//  FluidQ
//
//  Created by Harry Shamansky on 12/2/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//
//  Note: Create magic sheet in Interface Builder (IB)
//  Use UIButtons of custom class MagicSheetButton. Each button should have a
//  user-defined key of type string called "gelColor". The value should be a gel
//  manufacturer's color code, such as "R40", "L201", or "N/C".
//  The Button's title should be its channel number. Use AutoLayout to define
//  spacing. Be sure to add all buttons to the buttons IBOutletCollection via
//  Interface Builder.

import UIKit

class StaticMagicSheetViewController: UIViewController {
    
    // IBOutletCollection of buttons. Make sure all buttons are added to this!
    @IBOutlet var buttons: [MagicSheetButton]!
    
    // MARK: Utility Functions
    func selectedChannels() -> [Int] {
        var returnArray: [Int] = []
        // Note that channel circles must be top-level objects in the view hierarchy
        for button in buttons {
            if button.selected {
                if let intRep = Int((button.titleLabel?.text)!) {
                    returnArray.append(intRep)
                }
            }
        }
        return returnArray
    }
    
    // MARK: Command Generation
    func generateCommand(selectedChannels: [Int]) -> Command {
        
        // TODO: swap the single clear command out for a shift+clear
        var keystrokes: [Keystroke] = [kClearKeystroke]
        for channel in selectedChannels {
            let newKeystrokes = doubleToKeystrokes(Double(channel), padZeros: false)
            keystrokes += newKeystrokes
            keystrokes.append(kAndKeystroke)
        }
        
        // drop the trailing AND
        keystrokes.removeLast()
        
        // enter the command
        keystrokes.append(kEnterKeystroke)
        
        return Command(withKeystrokes: keystrokes)
    }
    
    func sendCommand(command: Command) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).multipeerManager.sendCommand(command)
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.multipleTouchEnabled = true
    }
    
    // MARK: IBActions
    @IBAction func toggleButton(sender: UIButton) {
        sender.selected = !sender.selected
        
        if selectedChannels().count > 0 {
            sendCommand(generateCommand(selectedChannels()))
        }
    }
    
    // MARK: Rectangular Selection
    var selectionRectangleView: UIView?
    var trueOrigin = CGPointZero
    var additiveSelection = false
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        let touchPoint = touches.first!.locationInView(view)
        additiveSelection = true
        trueOrigin = touchPoint
        
        if !additiveSelection {
            for button in buttons {
                button.selected = false
            }
        }
        
        selectionRectangleView?.removeFromSuperview()
        selectionRectangleView = UIView()
        selectionRectangleView?.backgroundColor = UIColor(red: 1.0, green: (65.0 / 255.0), blue: 0.0, alpha: 0.5)
        selectionRectangleView?.frame = CGRect(origin: touchPoint, size: CGSizeZero)
        
        if let rectView = selectionRectangleView {
            view.addSubview(rectView)
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touchPoint = touches.first!.locationInView(view)
        
        guard let rect = selectionRectangleView else {
            return
        }
        
        let xDelta = touchPoint.x - trueOrigin.x
        let yDelta = touchPoint.y - trueOrigin.y
        
        if xDelta >= 0 && yDelta >= 0 {
            rect.frame = CGRect(origin: rect.frame.origin, size: CGSize(width: xDelta, height: yDelta))
        } else if xDelta >= 0 && yDelta < 0 {
            rect.frame = CGRect(x: trueOrigin.x, y: touchPoint.y, width: abs(xDelta), height: abs(yDelta))
        } else if xDelta < 0 && yDelta >= 0 {
            rect.frame = CGRect(x: touchPoint.x, y: trueOrigin.y, width: abs(xDelta), height: abs(yDelta))
        } else {
            rect.frame = CGRect(origin: touchPoint, size: CGSize(width: abs(xDelta), height: abs(yDelta)))
        }
        
        // selection
        for button in buttons {
            if rect.frame.contains(CGPoint(x: button.frame.midX, y: button.frame.midY)) {
                if additiveSelection && !button.didToggle {
                    button.selected = !button.selected
                    button.didToggle = true
                } else {
                    button.selected = true
                }
            } else if !additiveSelection {
                button.selected = false
            }
        }
        
        
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        for button in buttons {
            button.didToggle = false
        }
        selectionRectangleView?.removeFromSuperview()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // if the selection rectangle was small, consider it a deselection
        if selectionRectangleView!.frame.size.height < 20 && selectionRectangleView!.frame.size.width < 20 {
            for button in buttons {
                button.selected = false
            }
        } else if selectedChannels().count > 0 {
            sendCommand(generateCommand(selectedChannels()))
        }
        
        
        for button in buttons {
            button.didToggle = false
        }
        selectionRectangleView?.removeFromSuperview()
    }
    
    
}
