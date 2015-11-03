//
//  Utilities.swift
//  FluidQ
//
//  Created by Harry Shamansky on 10/13/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import Foundation

/// Converts a Double to a series of keystrokes that form the number.
/// - Parameter number: the Double to convert
/// - Returns: an array of Keystrokes that represent the number as discrete button presses
func doubleToKeystrokes(number: Double) -> [Keystroke] {
    
    var keystrokesToReturn: [Keystroke] = []
    var numberString: String?
    
    // try the integer representation if possible
    numberString = (number % 1 == 0) ? String(Int(number)) : String(format: "%.2f", arguments: [number])

    // turn the characters into keystrokes
    guard let finalString = numberString else {
        return []
    }
    
    for char in finalString.characters {
        keystrokesToReturn.append(Keystroke(identifier: "\(char)", keyEquivalent: char, plaintext: "\(char)"))
    }
    
    return keystrokesToReturn
}