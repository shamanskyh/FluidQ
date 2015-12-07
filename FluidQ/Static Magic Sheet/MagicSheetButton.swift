//
//  MagicSheetButton.swift
//  FluidQ
//
//  Created by Harry Shamansky on 12/2/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import UIKit

class MagicSheetButton: UIButton {
    
    // property to prevent re-toggling on rectangular selection
    var didToggle = false
    
    // MARK: Gel Color
    var gelColor: String!
    var color: UIColor {
        if let str = valueForKeyPath("gelColor") as? String {
            if str.uppercaseString == "RGB" || str.uppercaseString == "LED" || str.lowercaseString == "seachanger" {
                return UIColor(red: 1.0, green: (65.0 / 255.0), blue: 0.0, alpha: 1.0)
            }
            return UIColor(CGColor: str.toGelColor()!)
        } else {
            return UIColor(red: 1.0, green: (65.0 / 255.0), blue: 0.0, alpha: 1.0)
        }
    }
    
    var isColorChanging: Bool {
        if let str = valueForKeyPath("gelColor") as? String {
            return (str.uppercaseString == "RGB" || str.uppercaseString == "LED" || str.lowercaseString == "seachanger")
        }
        return false
    }
    
    // MARK: Drawing
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        setTitleColor(color, forState: UIControlState.Normal)
        setTitleColor(UIColor.blackColor(), forState: UIControlState.Selected)
        
        let context = UIGraphicsGetCurrentContext()
        if state == .Selected {
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillEllipseInRect(context, CGRectInset(rect, 1.0, 1.0))
        } else {
            CGContextSetStrokeColorWithColor(context, color.CGColor)
            CGContextSetLineWidth(context, 2.0)
            CGContextStrokeEllipseInRect(context, CGRectInset(rect, 2.0, 2.0))
        }
    }
    
    // MARK: - Intrinsic Content Size
    override func intrinsicContentSize() -> CGSize {
        if self.traitCollection.horizontalSizeClass == .Compact {
            return CGSize(width: 34, height: 34)
        } else {
            return CGSize(width: 80, height: 80)
        }
    }
    
}
