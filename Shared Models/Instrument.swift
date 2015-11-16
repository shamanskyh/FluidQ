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
enum DeviceType: Int {
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
class Instrument: NSObject, NSCoding {
    
    var deviceType: DeviceType? = nil
    var instrumentType: String? = nil
    var wattage: String? = nil
    var purpose: String? = nil
    var position: String? = nil
    var unitNumber: String? = nil
    var color: String? = nil
    var dimmer: String? = nil
    var channel: Int? = nil
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
    
    // MARK: - NSCoding Protocol Conformance
    required init(coder aDecoder: NSCoder) {
        deviceType = DeviceType(rawValue: aDecoder.decodeIntegerForKey("deviceType"))
        instrumentType = aDecoder.decodeObjectForKey("instrumentType") as? String
        wattage = aDecoder.decodeObjectForKey("wattage") as? String
        purpose = aDecoder.decodeObjectForKey("purpose") as? String
        position = aDecoder.decodeObjectForKey("position") as? String
        unitNumber = aDecoder.decodeObjectForKey("unitNumber") as? String
        color = aDecoder.decodeObjectForKey("color") as? String
        dimmer = aDecoder.decodeObjectForKey("dimmer") as? String
        channel = aDecoder.decodeIntegerForKey("channel")
        address = aDecoder.decodeObjectForKey("address") as? String
        universe = aDecoder.decodeObjectForKey("universe") as? String
        uAddress = aDecoder.decodeObjectForKey("uAddress") as? String
        uDimmer = aDecoder.decodeObjectForKey("uDimmer") as? String
        circuitNumber = aDecoder.decodeObjectForKey("circuitNumber") as? String
        circuitName = aDecoder.decodeObjectForKey("circuitName") as? String
        system = aDecoder.decodeObjectForKey("system") as? String
        userField1 = aDecoder.decodeObjectForKey("userField1") as? String
        userField2 = aDecoder.decodeObjectForKey("userField2") as? String
        userField3 = aDecoder.decodeObjectForKey("userField3") as? String
        userField4 = aDecoder.decodeObjectForKey("userField4") as? String
        userField5 = aDecoder.decodeObjectForKey("userField5") as? String
        userField6 = aDecoder.decodeObjectForKey("userField6") as? String
        numChannels = aDecoder.decodeObjectForKey("numChannels") as? String
        frameSize = aDecoder.decodeObjectForKey("frameSize") as? String
        fieldAngle = aDecoder.decodeObjectForKey("fieldAngle") as? String
        fieldAngle2 = aDecoder.decodeObjectForKey("fieldAngle2") as? String
        beamAngle = aDecoder.decodeObjectForKey("beamAngle") as? String
        beamAngle2 = aDecoder.decodeObjectForKey("beamAngle2") as? String
        weight = aDecoder.decodeObjectForKey("weight") as? String
        gobo1 = aDecoder.decodeObjectForKey("gobo1") as? String
        gobo1Rotation = aDecoder.decodeObjectForKey("gobo1Rotation") as? String
        gobo2 = aDecoder.decodeObjectForKey("gobo2") as? String
        gobo2Rotation = aDecoder.decodeObjectForKey("gobo2Rotation") as? String
        goboShift = aDecoder.decodeObjectForKey("goboShift") as? String
        mark = aDecoder.decodeObjectForKey("mark") as? String
        drawBeam = aDecoder.decodeBoolForKey("drawBeam")
        drawBeamAs3DSolid = aDecoder.decodeBoolForKey("drawBeamAs3DSolid")
        useVerticalBeam = aDecoder.decodeBoolForKey("useVerticalBeam")
        showBeamAt = aDecoder.decodeObjectForKey("showBeamAt") as? String
        falloffDistance = aDecoder.decodeObjectForKey("falloffDistance") as? String
        lampRotationAngle = aDecoder.decodeObjectForKey("lampRotationAngle") as? String
        topShutterDepth = aDecoder.decodeObjectForKey("topShutterDepth") as? String
        topShutterAngle = aDecoder.decodeObjectForKey("topShutterAngle") as? String
        leftShutterDepth = aDecoder.decodeObjectForKey("leftShutterDepth") as? String
        leftShutterAngle = aDecoder.decodeObjectForKey("leftShutterAngle") as? String
        rightShutterDepth = aDecoder.decodeObjectForKey("rightShutterDepth") as? String
        rightShutterAngle = aDecoder.decodeObjectForKey("rightShutterAngle") as? String
        bottomShutterDepth = aDecoder.decodeObjectForKey("bottomShutterDepth") as? String
        bottomShutterAngle = aDecoder.decodeObjectForKey("bottomShutterAngle") as? String
        symbolName = aDecoder.decodeObjectForKey("symbolName") as? String
        useLegend = aDecoder.decodeBoolForKey("useLegend")
        flipFrontBackLegendText = aDecoder.decodeBoolForKey("flipFrontBackLegendText")
        flipLeftRightLegendText = aDecoder.decodeBoolForKey("flipLeftRightLegendText")
        focus = aDecoder.decodeObjectForKey("focus") as? String
        set3DOrientation = aDecoder.decodeBoolForKey("set3DOrientation")
        xRotation = aDecoder.decodeObjectForKey("xRotation") as? String
        yRotation = aDecoder.decodeObjectForKey("yRotation") as? String
        location = Coordinate(xPos: aDecoder.decodeDoubleForKey("convertedXLocation"), yPos: aDecoder.decodeDoubleForKey("convertedYLocation"), zPos: aDecoder.decodeDoubleForKey("convertedZLocation"))
        rawXLocation = aDecoder.decodeObjectForKey("rawXLocation") as? String
        rawYLocation = aDecoder.decodeObjectForKey("rawYLocation") as? String
        rawZLocation = aDecoder.decodeObjectForKey("rawZLocation") as? String
        fixtureID = aDecoder.decodeObjectForKey("fixtureID") as? String
        UID = aDecoder.decodeObjectForKey("UID") as! String
        accessories = aDecoder.decodeObjectForKey("accessories") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let devType = deviceType {
            aCoder.encodeInteger(devType.rawValue, forKey: "deviceType")
        }
        aCoder.encodeObject(instrumentType, forKey: "instrumentType")
        aCoder.encodeObject(wattage, forKey: "wattage")
        aCoder.encodeObject(purpose, forKey: "purpose")
        aCoder.encodeObject(position, forKey: "position")
        aCoder.encodeObject(unitNumber, forKey: "unitNumber")
        aCoder.encodeObject(color, forKey: "color")
        aCoder.encodeObject(dimmer, forKey: "dimmer")
        if let chan = channel {
            aCoder.encodeInteger(chan, forKey: "channel")
        }
        aCoder.encodeObject(address, forKey: "address")
        aCoder.encodeObject(universe, forKey: "universe")
        aCoder.encodeObject(uAddress, forKey: "uAddress")
        aCoder.encodeObject(uDimmer, forKey: "uDimmer")
        aCoder.encodeObject(circuitNumber, forKey: "circuitNumber")
        aCoder.encodeObject(circuitName, forKey: "circuitName")
        aCoder.encodeObject(system, forKey: "system")
        aCoder.encodeObject(userField1, forKey: "userField1")
        aCoder.encodeObject(userField2, forKey: "userField2")
        aCoder.encodeObject(userField3, forKey: "userField3")
        aCoder.encodeObject(userField4, forKey: "userField4")
        aCoder.encodeObject(userField5, forKey: "userField5")
        aCoder.encodeObject(userField6, forKey: "userField6")
        aCoder.encodeObject(numChannels, forKey: "numChannels")
        aCoder.encodeObject(frameSize, forKey: "frameSize")
        aCoder.encodeObject(fieldAngle, forKey: "fieldAngle")
        aCoder.encodeObject(fieldAngle2, forKey: "fieldAngle2")
        aCoder.encodeObject(beamAngle, forKey: "beamAngle")
        aCoder.encodeObject(beamAngle2, forKey: "beamAngle2")
        aCoder.encodeObject(weight, forKey: "weight")
        aCoder.encodeObject(gobo1, forKey: "gobo1")
        aCoder.encodeObject(gobo1Rotation, forKey: "gobo1Rotation")
        aCoder.encodeObject(gobo2, forKey: "gobo2")
        aCoder.encodeObject(gobo2Rotation, forKey: "gobo2Rotation")
        aCoder.encodeObject(goboShift, forKey: "goboShift")
        aCoder.encodeObject(mark, forKey: "mark")
        aCoder.encodeObject(showBeamAt, forKey: "showBeamAt")
        aCoder.encodeObject(falloffDistance, forKey: "falloffDistance")
        aCoder.encodeObject(lampRotationAngle, forKey: "lampRotationAngle")
        aCoder.encodeObject(topShutterDepth, forKey: "topShutterDepth")
        aCoder.encodeObject(topShutterAngle, forKey: "topShutterAngle")
        aCoder.encodeObject(leftShutterDepth, forKey: "leftShutterDepth")
        aCoder.encodeObject(leftShutterAngle, forKey: "leftShutterAngle")
        aCoder.encodeObject(rightShutterDepth, forKey: "rightShutterDepth")
        aCoder.encodeObject(rightShutterAngle, forKey: "rightShutterAngle")
        aCoder.encodeObject(bottomShutterDepth, forKey: "bottomShutterDepth")
        aCoder.encodeObject(bottomShutterAngle, forKey: "bottomShutterAngle")
        aCoder.encodeObject(symbolName, forKey: "symbolName")
        aCoder.encodeObject(focus, forKey: "focus")
        aCoder.encodeObject(xRotation, forKey: "xRotation")
        aCoder.encodeObject(yRotation, forKey: "yRotation")
        if let l = location {
            aCoder.encodeDouble(l.x, forKey: "convertedXLocation")
            aCoder.encodeDouble(l.y, forKey: "convertedYLocation")
            aCoder.encodeDouble(l.z, forKey: "convertedZLocation")
        }
        aCoder.encodeObject(rawXLocation, forKey: "rawXLocation")
        aCoder.encodeObject(rawYLocation, forKey: "rawYLocation")
        aCoder.encodeObject(rawZLocation, forKey: "rawZLocation")
        aCoder.encodeObject(fixtureID, forKey: "fixtureID")
        aCoder.encodeObject(UID, forKey: "UID")
        aCoder.encodeObject(accessories, forKey: "accessories")
    }
    
    func addCoordinateToLocation(type: Dimension, value: String) throws {
        
        var coord = self.location
        if coord == nil {
            coord = Coordinate(xPos: 0.0, yPos: 0.0, zPos: 0.0)
        }
        
        var convertedValue: Double = 0.0;
        do {
            try convertedValue = value.unknownUnitToMeters()
        } catch {
            throw InstrumentError.UnrecognizedCoordinate
        }
        
        switch type {
            case .X: coord!.x = convertedValue
            case .Y: coord!.y = convertedValue
            case .Z: coord!.z = convertedValue
        }
        
        self.location = coord!
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

