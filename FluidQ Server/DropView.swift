//
//  DropView.swift
//  FluidQ
//
//  Created by Harry Shamansky on 11/10/15.
//  Modified from Elucidate: https://github.com/shamanskyh/elucidate
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import Cocoa

protocol DropViewDelegate {
    func sendRawFile(text: String)
}

class DropView: NSView {

    var delegate: DropViewDelegate?
    var highlight = false {
        didSet {
            NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext) -> Void in
                context.duration = 0.3
                self.animator().alphaValue = (self.highlight ? 0.8 : 0.0)
            }, completionHandler: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.registerForDraggedTypes([NSFilenamesPboardType])
        
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.lightGrayColor().CGColor
        self.alphaValue = 0.0
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    // MARK: Dragging
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        highlight = true
        self.needsDisplay = true
        return NSDragOperation.Copy
    }
    
    override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
        return NSDragOperation.Copy
    }
    
    override func draggingExited(sender: NSDraggingInfo?) {
        highlight = false
        self.needsDisplay = true
        return
    }
    
    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        highlight = false
        self.needsDisplay = true
        return true
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        
        let pBoard = sender.draggingPasteboard()
        let URLs = pBoard.readObjectsForClasses([NSURL.self], options: nil) as! [NSURL]
        
        // TODO: catch errors
        let text = try! String(contentsOfURL: URLs.first!)
        
        self.delegate?.sendRawFile(text)
        
        return true
    }
    
    override func concludeDragOperation(sender: NSDraggingInfo?) {
        return
    }
    
}

extension DropView: NSPasteboardItemDataProvider {
    
    func pasteboard(pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: String) {
        return
    }
}
