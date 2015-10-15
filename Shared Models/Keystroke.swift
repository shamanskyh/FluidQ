//
//  Keystroke.swift
//  TouchDesign
//
//  Created by Harry Shamansky on 9/29/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import Foundation

/// Modifier key enums based on Windows modifiers, since the console runs Windows
/// underneath
internal enum ModifierKey {
    case Shift
    case Control
    case Alternate
    case Function
}

internal class Keystroke: NSObject, NSCoding {

    /// the identifier is a unique string that represents the command
    var identifier: String
    
    /// the plaintext string is a human-readable word that is printed during debugging
    var plaintext: String?
    
    /// the key equivalent is the character that is sent to the console via HID imput
    var keyEquivalent: Character
    
    /// any modifier keys that should be sent to the HID
    // Note that a keystroke with keyEquivalent = "A" and modifierKeys = [] is
    // equivalent to a keystroke with keyEquivalent = "a" and modifierKeys = [Shift]
    var modifierKeys: [ModifierKey] = []
    
    init(identifier: String, keyEquivalent: Character) {
        self.identifier = identifier
        self.keyEquivalent = keyEquivalent
    }
    
    convenience init(identifier: String, keyEquivalent: Character, plaintext: String) {
        self.init(identifier: identifier, keyEquivalent: keyEquivalent)
        self.plaintext = plaintext
    }
    
    // MARK: - NSCoding Protocol Conformance
    required init(coder aDecoder: NSCoder) {
        identifier = aDecoder.decodeObjectForKey("identifier") as! String
        plaintext = aDecoder.decodeObjectForKey("plaintext") as? String
        keyEquivalent = (aDecoder.decodeObjectForKey("keyEquivalent") as! String).characters.first!
        //modifierKeys = aDecoder.decodeObjectForKey("modifierKeys") as! [ModifierKey]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(identifier, forKey: "identifier")
        aCoder.encodeObject(plaintext, forKey: "plaintext")
        aCoder.encodeObject(String(keyEquivalent), forKey: "keyEquivalent")
        //aCoder.encodeObject(modifierKeys, forKey: "modifierKeys")
    }
}
