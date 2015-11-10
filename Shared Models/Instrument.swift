//
//  Instrument.swift
//  FluidQ
//
//  Created by Harry Shamansky on 11/10/15.
//  Modified from Precircuiter: https://github.com/shamanskyh/Precircuiter
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

// MARK: - Enumerations
enum DeviceType {
    case Light
    case MovingLight
    case Accessory
    case StaticAccessory
    case Device
    case Practical
    case SFX
    case Power
    case Other
    
    var description: String {
        switch self {
        case Light: return "Light"
        case MovingLight: return "MovingLight"
        case Accessory: return "Accessory"
        case StaticAccessory: return "StaticAccessory"
        case Device: return "Device"
        case Practical: return "Practical"
        case SFX: return "SFX"
        case Power: return "Power"
        case Other: return "Other"
        }
    }
}

enum Dimension {
    case X
    case Y
    case Z
}

// MARK: - Structs
struct Coordinate {
    var x: Double
    var y: Double
    var z: Double
    init(xPos: Double, yPos: Double, zPos: Double) {
        x = xPos
        y = yPos
        z = zPos
    }
}

// MARK: - Instrument Class
class Instrument: NSObject {
    
    var deviceType: DeviceType? = nil
    var instrumentType: String? = nil
    var wattage: String? = nil
    var purpose: String? = nil
    var position: String? = nil
    var unitNumber: String? = nil
    var color: String? = nil
    var dimmer: String? = nil
    var channel: String? = nil
    var address: String? = nil
    var universe: String? = nil
    var uAddress: String? = nil
    var uDimmer: String? = nil
    var circuitNumber: String? = nil
    var circuitName: String? = nil
    var system: String? = nil
    var userField1: String? = nil
    var userField2: String? = nil
    var userField3: String? = nil
    var userField4: String? = nil
    var userField5: String? = nil
    var userField6: String? = nil
    var numChannels: String? = nil
    var frameSize: String? = nil
    var fieldAngle: String? = nil
    var fieldAngle2: String? = nil
    var beamAngle: String? = nil
    var beamAngle2: String? = nil
    var weight: String? = nil
    var gobo1: String? = nil
    var gobo1Rotation: String? = nil
    var gobo2: String? = nil
    var gobo2Rotation: String? = nil
    var goboShift: String? = nil
    var mark: String? = nil
    var drawBeam: Bool? = nil
    var drawBeamAs3DSolid: Bool? = nil
    var useVerticalBeam: Bool? = nil
    var showBeamAt: String? = nil
    var falloffDistance: String? = nil
    var lampRotationAngle: String? = nil
    var topShutterDepth: String? = nil
    var topShutterAngle: String? = nil
    var leftShutterDepth: String? = nil
    var leftShutterAngle: String? = nil
    var rightShutterDepth: String? = nil
    var rightShutterAngle: String? = nil
    var bottomShutterDepth: String? = nil
    var bottomShutterAngle: String? = nil
    var symbolName: String? = nil
    var useLegend: Bool? = nil
    var flipFrontBackLegendText: Bool? = nil
    var flipLeftRightLegendText: Bool? = nil
    var focus: String? = nil
    var set3DOrientation: Bool? = nil
    var xRotation: String? = nil
    var yRotation: String? = nil
    var location: Coordinate? = nil
    var rawXLocation: String? = nil
    var rawYLocation: String? = nil
    var rawZLocation: String? = nil
    var fixtureID: String? = nil
    var UID: String
    var accessories: String? = nil
    
    // MARK: Swatch Color
    private var savedSwatchColor: CGColor?
    private var isClearColor: Bool {
        return color?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()) == "N/C" ||
            color?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()) == "NC"
    }
    internal var needsNewSwatchColor = false
    internal var swatchColor: CGColor? {
        if (savedSwatchColor == nil && color != nil) || needsNewSwatchColor {
            needsNewSwatchColor = false
            if let color = self.color?.toGelColor() {
                savedSwatchColor = color
            } else {
                savedSwatchColor = nil
            }
        }
        return savedSwatchColor
    }
    
    required init(UID: String?, location: Coordinate?) {
        
        if let id = UID {
            self.UID = id
        } else {
            self.UID = ""
        }
        self.location = location
    }
}

// MARK: - NSCopying Protocol Conformance
extension Instrument: NSCopying {
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = self.dynamicType.init(UID: self.UID, location: self.location)
        copy.deviceType = self.deviceType
        copy.instrumentType = self.instrumentType
        copy.wattage = self.wattage
        copy.purpose = self.purpose
        copy.position = self.position
        copy.unitNumber = self.unitNumber
        copy.color = self.color
        copy.dimmer = self.dimmer
        copy.channel = self.channel
        copy.address = self.address
        copy.universe = self.universe
        copy.uAddress = self.uAddress
        copy.uDimmer = self.uDimmer
        copy.circuitNumber = self.circuitNumber
        copy.circuitName = self.circuitName
        copy.system = self.system
        copy.userField1 = self.userField1
        copy.userField2 = self.userField2
        copy.userField3 = self.userField3
        copy.userField4 = self.userField4
        copy.userField5 = self.userField5
        copy.userField6 = self.userField6
        copy.numChannels = self.numChannels
        copy.frameSize = self.frameSize
        copy.fieldAngle = self.fieldAngle
        copy.fieldAngle2 = self.fieldAngle2
        copy.beamAngle = self.beamAngle
        copy.beamAngle2 = self.beamAngle2
        copy.weight = self.weight
        copy.gobo1 = self.gobo1
        copy.gobo1Rotation = self.gobo1Rotation
        copy.gobo2 = self.gobo2
        copy.gobo2Rotation = self.gobo2Rotation
        copy.goboShift = self.goboShift
        copy.mark = self.mark
        copy.drawBeam = self.drawBeam
        copy.drawBeamAs3DSolid = self.drawBeamAs3DSolid
        copy.useVerticalBeam = self.useVerticalBeam
        copy.showBeamAt = self.showBeamAt
        copy.falloffDistance = self.falloffDistance
        copy.lampRotationAngle = self.lampRotationAngle
        copy.topShutterDepth = self.topShutterDepth
        copy.topShutterAngle = self.topShutterAngle
        copy.leftShutterDepth = self.leftShutterDepth
        copy.leftShutterAngle = self.leftShutterAngle
        copy.rightShutterDepth = self.rightShutterDepth
        copy.rightShutterAngle = self.rightShutterAngle
        copy.bottomShutterDepth = self.bottomShutterDepth
        copy.bottomShutterAngle = self.bottomShutterAngle
        copy.symbolName = self.symbolName
        copy.useLegend = self.useLegend
        copy.flipFrontBackLegendText = self.flipFrontBackLegendText
        copy.flipLeftRightLegendText = self.flipLeftRightLegendText
        copy.focus = self.focus
        copy.set3DOrientation = self.set3DOrientation
        copy.xRotation = self.xRotation
        copy.yRotation = self.yRotation
        copy.rawXLocation = self.rawXLocation
        copy.rawYLocation = self.rawYLocation
        copy.rawZLocation = self.rawZLocation
        copy.fixtureID = self.fixtureID
        copy.accessories = self.accessories

        return copy
    }
}

