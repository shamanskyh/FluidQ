//
//  Selection.swift
//  FluidQ
//
//  Created by Harry Shamansky on 12/4/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import Foundation

class Selection: NSObject, NSCoding {
    
    var selectedChannels: [Int] = []
    var isColorChangingCapable = false
    
    override init() {
        super.init()
    }
    
    /// Initializes a command with an array of Keystrokes
    convenience init(withSelectedChannels channels: [Int]) {
        self.init()
        self.selectedChannels = channels
    }
    
    // MARK: - NSCoding Protocol Conformance
    required init(coder aDecoder: NSCoder) {
        selectedChannels = aDecoder.decodeObjectForKey("selectedChannels") as! [Int]
        isColorChangingCapable = aDecoder.decodeBoolForKey("isColorChangingCapable")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(selectedChannels, forKey: "selectedChannels")
        aCoder.encodeBool(isColorChangingCapable, forKey: "isColorChangingCapable")
    }
    
}
