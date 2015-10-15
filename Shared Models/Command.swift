//
//  Command.swift
//  TouchDesign
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
    
    convenience init(withKeystrokes keystrokes: [Keystroke]) {
        self.init()
        self.keystrokes = keystrokes
    }
    
    /// generates a description for printing
    override var description: String {
        var runningString = ""
        var previousKeystroke = ""
        for keystroke in keystrokes {
            if let plaintext = keystroke.plaintext {
                
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
    
    // MARK: - NSCoding Protocol Conformance
    required init(coder aDecoder: NSCoder) {
        keystrokes = aDecoder.decodeObjectForKey("keystrokes") as! [Keystroke]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(keystrokes, forKey: "keystrokes")
    }
    
}
