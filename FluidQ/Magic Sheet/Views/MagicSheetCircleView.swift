//
//  MagicSheetCircleView.swift
//  FluidQ
//
//  Created by Harry Shamansky on 11/16/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import UIKit

class MagicSheetCircleView: UIButton {

    override var selected: Bool {
        didSet {
            if selected {
                channelLabel.textColor = color.isLight() ? UIColor.blackColor() : UIColor.lightGrayColor()
            } else {
                channelLabel.textColor = color
            }
        }
    }
    var channelNumber: Int = 0
    var color: UIColor = UIColor(red: 1.0, green: (65.0 / 255.0), blue: 0.0, alpha: 1.0)
    var channelLabel: UILabel = UILabel()
    
    init(withInstrument instrument: Instrument) {
        if let chan = instrument.channel {
            channelNumber = chan
            channelLabel.text = String(channelNumber)
        }
        if let gelCode = instrument.color, cgc = gelCode.toGelColor() {
            color = UIColor(CGColor: cgc)
        }
        
        super.init(frame: CGRectZero)
        
        channelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(channelLabel)
        
        let margins = self.layoutMarginsGuide
        channelLabel.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        channelLabel.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor).active = true
        channelLabel.topAnchor.constraintEqualToAnchor(margins.topAnchor).active = true
        channelLabel.bottomAnchor.constraintEqualToAnchor(margins.bottomAnchor).active = true
        
        channelLabel.font = UIFont.boldSystemFontOfSize(labelFontSize)
        channelLabel.textAlignment = NSTextAlignment.Center
        channelLabel.textColor = color
        
        // TODO: yikes this is bad...
        self.tag = Int(instrument.channel!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        if selected {
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillEllipseInRect(context, CGRectInset(rect, 2.0, 2.0))
        } else {
            CGContextSetStrokeColorWithColor(context, color.CGColor)
            CGContextSetLineWidth(context, 2.0)
            CGContextStrokeEllipseInRect(context, CGRectInset(rect, 2.0, 2.0))
        }
    }
    
    let labelFontSize: CGFloat = 28.0
}

/// Extension to determine whether a color is light or dark
/// Modified from Precircuiter
/// http://github.com/shamanskyh/Precircuiter
extension UIColor {
    func isLight() -> Bool {
        let convertedColor = self.CIColor
        let red = convertedColor.red
        let green = convertedColor.green
        let blue = convertedColor.blue

        let score = ((red * 255 * 299) + (green * 255 * 587) + (blue * 255 * 114)) / 1000
        
        return score >= 175
    }
}
