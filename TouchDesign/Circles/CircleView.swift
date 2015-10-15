//
//  CircleView.swift
//  TouchDesign
//
//  Created by Harry Shamansky on 10/12/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import UIKit

class CircleView: UIView {

    let startingWidth: CGFloat = 100.0
    
    var groupName: String? {
        didSet {
            titleLabel.text = groupName
        }
    }
    var color: UIColor?
    
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.frame = bounds
        titleLabel.textColor = UIColor(red: 1.0, green: (65.0/255.0), blue: 0.0, alpha: 1.0)
        titleLabel.font = UIFont.boldSystemFontOfSize(15.0)
        titleLabel.textAlignment = .Center
        titleLabel.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(titleLabel)
        
        backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        if let color = color {
            CGContextSetFillColorWithColor(context, color.CGColor)
        } else {
            CGContextSetFillColorWithColor(context, UIColor(red: 1.0, green: (65.0/255.0), blue: 0.0, alpha: 1.0).CGColor)
        }
        CGContextFillEllipseInRect(context, rect)
    }
    
    var previousIntensity: Int = 0
    
    var intensityLevel: Int {
        let scale = Int((self.frame.width / startingWidth) * 50) - 50
        return max(min(scale, 100), 0)
    }

}
