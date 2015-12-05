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
    
    /// calculated property that returns the color changing channels
    /// - Complexity: O(N)
    var colorChangingChannels: [Int] {
        return buttons.filter({ $0.isColorChanging }).map({ Int($0.titleLabel!.text!)! })
    }
    
    // MARK: Utility Functions
    func selectedChannels() -> [Int] {
        var returnArray: [Int] = []
        for button in buttons {
            if button.selected {
                if let intRep = Int((button.titleLabel?.text)!) {
                    returnArray.append(intRep)
                }
            }
        }
        return returnArray
    }
    
    func sendSelection(selection: Selection) {
        
        var isColorChanging = true
        for channel in selection.selectedChannels {
            if !colorChangingChannels.contains(channel) {
                isColorChanging = false
                break
            }
        }
        selection.isColorChangingCapable = isColorChanging
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).multipeerManager.sendSelection(selection)
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.multipleTouchEnabled = true
    }
    
    // MARK: IBActions
    @IBAction func toggleButton(sender: UIButton) {
        sender.selected = !sender.selected
        
        let selection = Selection(withSelectedChannels: selectedChannels())
        sendSelection(selection)
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
        }
        
        let selection = Selection(withSelectedChannels: selectedChannels())
        sendSelection(selection)
        
        for button in buttons {
            button.didToggle = false
        }
        selectionRectangleView?.removeFromSuperview()
    }
    
    
}
