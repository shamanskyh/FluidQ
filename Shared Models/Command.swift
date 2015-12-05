//
//  Command.swift
//  FluidQ
//
//  Created by Harry Shamansky on 9/29/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import Foundation

/// A Command is an action that the user wishes to take to change the lighting.
internal class Command: NSObject, NSCoding {
    
    /// Fundamentally, a command is a series of keystrokes
    var keystrokes: [Keystroke] = []
    
    override init() {
        super.init()
    }
    
    /// Initializes a command with an array of Keystrokes
    convenience init(withKeystrokes keystrokes: [Keystroke]) {
        self.init()
        self.keystrokes = keystrokes
    }
    
    /// Generates a description for printing
    override var description: String {
        var runningString = ""
        var previousKeystroke = ""
        for keystroke in keystrokes {
            if let plaintext = keystroke.plaintext where plaintext.characters.count > 0 {
                
                // drop the previous space if we have two numbers in a row
                if Int(plaintext) != nil && Int(previousKeystroke) != nil {
                    runningString = String(runningString.characters.dropLast())
                }

                previousKeystroke = plaintext
                runningString += plaintext + " "
            }
        }
        
        // drop the trailing space
        return String(runningString.characters.dropLast())
    }
    
    /// Some commands must be associated with selected channel(s).
    var requiresSelection = false
    var requiresColorChangingChannelSelection = false
    
    // MARK: - NSCoding Protocol Conformance
    required init(coder aDecoder: NSCoder) {
        keystrokes = aDecoder.decodeObjectForKey("keystrokes") as! [Keystroke]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(keystrokes, forKey: "keystrokes")
    }
    
}
