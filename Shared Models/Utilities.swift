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
func doubleToKeystrokes(number: Double, padZeros: Bool = false, suppressPlaintext: Bool = false) -> [Keystroke] {
    
    var keystrokesToReturn: [Keystroke] = []
    var numberString: String?
    
    // try the integer representation if possible
    numberString = (number % 1 == 0) ? String(Int(number)) : String(format: "%.2f", arguments: [number])

    // pad with zeros
    if Int(number) < 10 && padZeros {
        numberString = "0" + numberString!
    }
    
    // turn the characters into keystrokes
    guard let finalString = numberString else {
        return []
    }
    
    for char in finalString.characters {
        keystrokesToReturn.append(Keystroke(identifier: "\(char)", keyEquivalent: char, plaintext: suppressPlaintext ? "" : "\(char)"))
    }
    
    return keystrokesToReturn
}

/// Generates a selection command from a group of selected channels
func generateCommand(selectedChannels: [(Int, Int)]) -> Command {
    
    if selectedChannels.count == 0 {
        // TODO: swap the single clear command out for a shift+clear
        return Command(withKeystrokes: [kVisibleClearKeystroke])
    }
    
    // TODO: swap the single clear command out for a shift+clear
    var keystrokes: [Keystroke] = [kClearKeystroke]
    for (channel1, channel2) in selectedChannels {
        if channel1 == channel2 {
            let newKeystrokes = doubleToKeystrokes(Double(channel1), padZeros: false)
            keystrokes += (newKeystrokes + [kAndKeystroke])
        } else {
            let startKeystrokes = doubleToKeystrokes(Double(channel1), padZeros: false)
            let endKeystrokes = doubleToKeystrokes(Double(channel2), padZeros: false)
            keystrokes += (startKeystrokes + [kThruKeystroke] + endKeystrokes + [kAndKeystroke])
        }
    }
    
    // drop the trailing AND
    keystrokes.removeLast()
    
    // enter the command
    keystrokes.append(kEnterKeystroke)
    
    return Command(withKeystrokes: keystrokes)
}

// MARK: String/Key Conversion Utilities
// Taken from Precircuiter
// http://github.com/shamanskyh/Precircuiter
/// Given a key/value pair as strings, add or modify the corresponding property
/// on an `Instrument` object.
///
/// - Parameter inst: the instrument to modify (passed by reference)
/// - Parameter propertyString: the property to modify, as a string from VWX
/// - Parameter propertyValue: the value to set the property to
func addPropertyToInstrument(inout inst: Instrument, propertyString: String, propertyValue: String) throws {
    
    func stringToDeviceType(devType: String) -> DeviceType {
        switch devType {
        case "Light": return .Light
        case "Moving Light": return .MovingLight
        case "Accessory": return .Accessory
        case "Static Accessory": return .StaticAccessory
        case "Device": return .Device
        case "Practical": return .Practical
        case "SFX": return .SFX
        case "Power": return .Power
        default: return .Other
        }
    }
    
    // throw out any of Vectorworks' hyphens
    if propertyValue == "-" {
        return
    }
    
    switch propertyString {
    case "Device Type": inst.deviceType = stringToDeviceType(propertyValue)
    case "Inst Type": inst.instrumentType = propertyValue
    case "Instrument Type": inst.instrumentType = propertyValue
    case "Wattage": inst.wattage = propertyValue
    case "Purpose": inst.purpose = propertyValue
    case "Position": inst.position = propertyValue
    case "Unit Number": inst.unitNumber = propertyValue
    case "Color": inst.color = propertyValue
    case "Dimmer": inst.dimmer = propertyValue
    case "Channel": inst.channel = Int(propertyValue)
    case "Address": inst.address = propertyValue
    case "Universe": inst.universe = propertyValue
    case "U Address": inst.uAddress = propertyValue
    case "U Dimmer": inst.uDimmer = propertyValue
    case "Circuit Number": inst.circuitNumber = propertyValue
    case "Circuit Name": inst.circuitName = propertyValue
    case "System": inst.system = propertyValue
    case "User Field 1": inst.userField1 = propertyValue
    case "User Field 2": inst.userField2 = propertyValue
    case "User Field 3": inst.userField3 = propertyValue
    case "User Field 4": inst.userField4 = propertyValue
    case "User Field 5": inst.userField5 = propertyValue
    case "User Field 6": inst.userField6 = propertyValue
    case "Num Channels": inst.numChannels = propertyValue
    case "Frame Size": inst.frameSize = propertyValue
    case "Field Angle": inst.fieldAngle = propertyValue
    case "Field Angle 2": inst.fieldAngle2 = propertyValue
    case "Beam Angle": inst.beamAngle = propertyValue
    case "Beam Angle 2": inst.beamAngle2 = propertyValue
    case "Weight": inst.weight = propertyValue
    case "Gobo 1": inst.gobo1 = propertyValue
    case "Gobo 1 Rotation": inst.gobo1Rotation = propertyValue
    case "Gobo 2": inst.gobo2 = propertyValue
    case "Gobo 2 Rotation": inst.gobo2Rotation = propertyValue
    case "Gobo Shift": inst.goboShift = propertyValue
    case "Mark": inst.mark = propertyValue
    case "Draw Beam": inst.drawBeam = (propertyValue.lowercaseString == "true")
    case "Draw Beam as 3D Solid": inst.drawBeamAs3DSolid = (propertyValue.lowercaseString == "true")
    case "Use Vertical Beam": inst.useVerticalBeam = (propertyValue.lowercaseString == "true")
    case "Show Beam at": inst.showBeamAt = propertyValue
    case "Falloff Distance": inst.falloffDistance = propertyValue
    case "Lamp Rotation Angle": inst.lampRotationAngle = propertyValue
    case "Top Shutter Depth": inst.topShutterDepth = propertyValue
    case "Top Shutter Angle": inst.topShutterAngle = propertyValue
    case "Left Shutter Depth": inst.leftShutterDepth = propertyValue
    case "Left Shutter Angle": inst.leftShutterAngle = propertyValue
    case "Right Shutter Depth": inst.rightShutterDepth = propertyValue
    case "Right Shutter Angle": inst.rightShutterAngle = propertyValue
    case "Bottom Shutter Depth": inst.bottomShutterDepth = propertyValue
    case "Bottom Shutter Angle": inst.bottomShutterAngle = propertyValue
    case "Symbol Name": inst.symbolName = propertyValue
    case "Use Legend": inst.useLegend = (propertyValue.lowercaseString == "true")
    case "Flip Front && Back Legend Text": inst.flipFrontBackLegendText = (propertyValue.lowercaseString == "true")
    case "Flip Left && Right Legend Text": inst.flipLeftRightLegendText = (propertyValue.lowercaseString == "true")
    case "Focus": inst.focus = propertyValue
    case "Set 3D Orientation": inst.set3DOrientation = (propertyValue.lowercaseString == "true")
    case "X Rotation": inst.xRotation = propertyValue
    case "Y Rotation": inst.yRotation = propertyValue
    case "X Location": inst.rawXLocation = propertyValue
        do {
            inst.rawXLocation = propertyValue
            try inst.addCoordinateToLocation(.X, value: propertyValue)
        } catch {
            throw InstrumentError.AmbiguousLocation
        }
    case "Y Location":
        do {
            inst.rawYLocation = propertyValue
            try inst.addCoordinateToLocation(.Y, value: propertyValue)
        } catch {
            throw InstrumentError.AmbiguousLocation
        }
    case "Z Location":
        do {
            inst.rawZLocation = propertyValue
            try inst.addCoordinateToLocation(.Z, value: propertyValue)
        } catch {
            throw InstrumentError.AmbiguousLocation
        }
    case "FixtureID": inst.fixtureID = propertyValue
    case "__UID": inst.UID = propertyValue
    case "Accessories": inst.accessories = propertyValue
    default: throw InstrumentError.PropertyStringUnrecognized
    }
}

/// Given a VWX property string, find the corresponding property on an `Instrument`
/// object and return its value.
///
/// - Parameter inst: the instrument to modify (passed by reference)
/// - Parameter propertyString: the property to return, as a string from VWX
/// - Returns: the value of the requested property, or nil
func getPropertyFromInstrument(inst: Instrument, propertyString: String) throws -> String? {
    
    switch propertyString {
    case "Device Type": return inst.deviceType?.description
    case "Inst Type": return inst.instrumentType
    case "Instrument Type": return inst.instrumentType
    case "Wattage": return inst.wattage
    case "Purpose": return inst.purpose
    case "Position": return inst.position
    case "Unit Number": return inst.unitNumber
    case "Color": return inst.color
    case "Dimmer": return inst.dimmer
    case "Channel": return String(inst.channel)
    case "Address": return inst.address
    case "Universe": return inst.universe
    case "U Address": return inst.uAddress
    case "U Dimmer": return inst.uDimmer
    case "Circuit Number": return inst.circuitNumber
    case "Circuit Name": return inst.circuitName
    case "System": return inst.system
    case "User Field 1": return inst.userField1
    case "User Field 2": return inst.userField2
    case "User Field 3": return inst.userField3
    case "User Field 4": return inst.userField4
    case "User Field 5": return inst.userField5
    case "User Field 6": return inst.userField6
    case "Num Channels": return inst.numChannels
    case "Frame Size": return inst.frameSize
    case "Field Angle": return inst.fieldAngle
    case "Field Angle 2": return inst.fieldAngle2
    case "Beam Angle": return inst.beamAngle
    case "Beam Angle 2": return inst.beamAngle2
    case "Weight": return inst.weight
    case "Gobo 1": return inst.gobo1
    case "Gobo 1 Rotation": return inst.gobo1Rotation
    case "Gobo 2": return inst.gobo2
    case "Gobo 2 Rotation": return inst.gobo2Rotation
    case "Gobo Shift": return inst.goboShift
    case "Mark": return inst.mark
    case "Draw Beam": return (inst.drawBeam == true) ? "True" : "False"
    case "Draw Beam as 3D Solid": return (inst.drawBeamAs3DSolid == true) ? "True" : "False"
    case "Use Vertical Beam": return (inst.useVerticalBeam == true) ? "True" : "False"
    case "Show Beam at": return inst.showBeamAt
    case "Falloff Distance": return inst.falloffDistance
    case "Lamp Rotation Angle": return inst.lampRotationAngle
    case "Top Shutter Depth": return inst.topShutterDepth
    case "Top Shutter Angle": return inst.topShutterAngle
    case "Left Shutter Depth": return inst.leftShutterDepth
    case "Left Shutter Angle": return inst.leftShutterAngle
    case "Right Shutter Depth": return inst.rightShutterDepth
    case "Right Shutter Angle": return inst.rightShutterAngle
    case "Bottom Shutter Depth": return inst.bottomShutterDepth
    case "Bottom Shutter Angle": return inst.bottomShutterAngle
    case "Symbol Name": return inst.symbolName
    case "Use Legend": return (inst.useLegend == true) ? "True" : "False"
    case "Flip Front && Back Legend Text": return (inst.flipFrontBackLegendText == true) ? "True" : "False"
    case "Flip Left && Right Legend Text": return (inst.flipLeftRightLegendText == true) ? "True" : "False"
    case "Focus": return inst.focus
    case "Set 3D Orientation": return (inst.set3DOrientation == true) ? "True" : "False"
    case "X Rotation": return inst.xRotation
    case "Y Rotation": return inst.yRotation
    case "X Location": return inst.rawXLocation
    case "Y Location": return inst.rawYLocation
    case "Z Location": return inst.rawZLocation
    case "FixtureID": return inst.fixtureID
    case "__UID": return inst.UID
    case "Accessories": return inst.accessories
    default: throw InstrumentError.PropertyStringUnrecognized
    }
}
