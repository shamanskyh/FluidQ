//
//  InstrumentGroup.swift
//  FluidQ
//
//  Created by Harry Shamansky on 11/16/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import UIKit

class InstrumentGroup: NSObject {
    
    var instruments: [[Instrument]] {
        didSet {
            var lowestChannel: Int?
            for row in instruments {
                for instrument in row {
                    if let channel = instrument.channel where channel < lowestChannel || lowestChannel == nil {
                        lowestChannel = channel
                    }
                }
            }
            if let lowest = lowestChannel {
                startingChannelNumber = lowest
            } else {
                startingChannelNumber = Int.max
            }
        }
    }
    var purpose: String?
    var startingChannelNumber: Int = Int.max
    
    init(withInstruments instruments: [Instrument], purpose: String?) {
        
        var yPositions: [Double] = []
        var groupedInstruments: [[Instrument]] = []
        let filteredInstruments = instruments.filter({ $0.location != nil })
        
        for i in 0..<filteredInstruments.count {
            if yPositions.count == 0 {
                yPositions.append(filteredInstruments[i].location!.y)
                groupedInstruments.append([filteredInstruments[i]])
            } else {
                var foundMatch = false
                for j in 0..<yPositions.count {
                    if abs(filteredInstruments[i].location!.y - yPositions[j]) < kMagicSheetRowThreshold {
                        groupedInstruments[j].append(filteredInstruments[i])
                        foundMatch = true
                    }
                }
                if !foundMatch {
                    yPositions.append(filteredInstruments[i].location!.y)
                    groupedInstruments.append([filteredInstruments[i]])
                }
            }
        }
        
        // sort instruments by channel within row
        for i in 0..<groupedInstruments.count {
            groupedInstruments[i] = groupedInstruments[i].sort({ $0.channel < $1.channel })
        }
        
        // create tuples to easily sort rows from highest to lowest (since iOS origin is top-left)
        var tempRows: [(Double, [Instrument])] = []
        for i in 0..<yPositions.count {
            tempRows.append((yPositions[i], groupedInstruments[i]))
        }
        tempRows.sortInPlace({ $0.0 > $1.0 })

        self.instruments = []
        self.purpose = purpose
        super.init()
        
        // add the instruments
        tempRows.forEach({ self.instruments.append($0.1) })
    }
}
