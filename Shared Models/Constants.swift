//
//  Constants.swift
//  FluidQ
//
//  Created by Harry Shamansky on 10/6/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

let kMultipeerServiceType = "hss-fluidq"

// MARK: - Levels
let kAtKeystroke = Keystroke(identifier: "at", keyEquivalent: "a", plaintext: "at")
let kAndKeystroke = Keystroke(identifier: "and", keyEquivalent: "=", plaintext: "+")
let kOutKeystroke = Keystroke(identifier: "out", keyEquivalent: "o", plaintext: "Out •")
let kEnterKeystroke = Keystroke(identifier: "enter", keyEquivalent: "\n", plaintext: "•")
let kThruKeystroke = Keystroke(identifier: "thru", keyEquivalent: "t", plaintext: "Thru")
let kFullKeystroke = Keystroke(identifier: "full", keyEquivalent: "f", plaintext: "Full")
let kClearKeystroke = Keystroke(identifier: "clear", keyEquivalent: Character(UnicodeScalar(8)), plaintext: "")
let kVisibleClearKeystroke = Keystroke(identifier: "visibleClear", keyEquivalent: Character(UnicodeScalar(8)), plaintext: "[Clear]")

// MARK: - Color
// Saturation is Macro 301
let kSaturationKeystrokes = [Keystroke(identifier: "macro", keyEquivalent: "m", plaintext: ""), kDelayFunctionKeystroke] + doubleToKeystrokes(301, suppressPlaintext: true) + [kDelayFunctionKeystroke, Keystroke(identifier: "macroEnterSaturation", keyEquivalent: "\n", plaintext: "Saturation"), kDelayFunctionKeystroke]
// Hue is Macro 302
let kHueKeystrokes = [Keystroke(identifier: "macro", keyEquivalent: "m", plaintext: ""), kDelayFunctionKeystroke] + doubleToKeystrokes(302, suppressPlaintext: true) + [kDelayFunctionKeystroke, Keystroke(identifier: "macroEnterHue", keyEquivalent: "\n", plaintext: "Hue"), kDelayFunctionKeystroke]
let kDelayFunctionKeystroke = Keystroke(identifier: "delayKeystroke", keyEquivalent: Character(UnicodeScalar(29)), plaintext: "")

// MARK: - Cueing
let kRecordKeystroke = Keystroke(identifier: "record", keyEquivalent: "r", plaintext: "Record")
let kCueKeystroke = Keystroke(identifier: "cue", keyEquivalent: "c", plaintext: "Cue")

// MARK: - Numeric
let k0Keystroke = Keystroke(identifier: "0", keyEquivalent: "0", plaintext: "0")
let k1Keystroke = Keystroke(identifier: "1", keyEquivalent: "1", plaintext: "1")
let k2Keystroke = Keystroke(identifier: "2", keyEquivalent: "2", plaintext: "2")
let k3Keystroke = Keystroke(identifier: "3", keyEquivalent: "3", plaintext: "3")
let k4Keystroke = Keystroke(identifier: "4", keyEquivalent: "4", plaintext: "4")
let k5Keystroke = Keystroke(identifier: "5", keyEquivalent: "5", plaintext: "5")
let k6Keystroke = Keystroke(identifier: "6", keyEquivalent: "6", plaintext: "6")
let k7Keystroke = Keystroke(identifier: "7", keyEquivalent: "7", plaintext: "7")
let k8Keystroke = Keystroke(identifier: "8", keyEquivalent: "8", plaintext: "8")
let k9Keystroke = Keystroke(identifier: "9", keyEquivalent: "9", plaintext: "9")

// MARK: - Units of Measurement for Automatic Magic Sheet Creation
let kMetersInFoot: Double       = 0.3048
let kMetersInInch: Double       = 0.0254
let kMetersInYard: Double       = 0.9144
let kMetersInMile: Double       = 1609.34
let kMetersInMicron: Double     = 0.000001
let kMetersInMillimeter: Double = 0.001
let kMetersInCentimeter: Double = 0.01
let kMetersInKilometer: Double  = 1000.0
let kMetersInMeter: Double      = 1.0
let kMetersInDegrees: Double    = 1.0

// MARK: - Magic Sheet Constants
let kMagicSheetRowThreshold: Double = 0.5