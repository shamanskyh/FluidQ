//
//  MagicSheetPurposeGroupView.swift
//  FluidQ
//
//  Created by Harry Shamansky on 11/16/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import UIKit

class MagicSheetPurposeGroupView: UIView {
    
    var titleLabel: UILabel
    private var rowStacks: [UIStackView] = []
    private let labelBottomMargin: CGFloat = 10.0
    private var largestRowCount = 0
    
    init(withInstrumentGroup instrumentGroup: InstrumentGroup) {
        
        titleLabel = UILabel()
        
        super.init(frame: CGRectZero)
        
        // make the row stack views
        var widestRowIndex = 0;
        for (index, row) in instrumentGroup.instruments.enumerate() {
            let circleViews = row.map({ MagicSheetCircleView(withInstrument: $0) })
            
            for circleView in circleViews {
                let heightConstraint = circleView.heightAnchor.constraintEqualToAnchor(nil, constant: circleSize)
                heightConstraint.active = true
                heightConstraint.identifier = "heightConstraint"
                circleView.widthAnchor.constraintEqualToAnchor(circleView.heightAnchor, multiplier: 1.0).active = true
                
                circleView.addTarget(self, action: "didTap:", forControlEvents: UIControlEvents.TouchUpInside)
                circleView.userInteractionEnabled = true
            }
            
            if row.count > largestRowCount {
                largestRowCount = row.count
                widestRowIndex = index
            }
            
            let rowStack = UIStackView(arrangedSubviews: circleViews)
            rowStack.translatesAutoresizingMaskIntoConstraints = false
            rowStack.axis = .Horizontal
            rowStacks.append(rowStack)
        }
        
        let margins = self.layoutMarginsGuide
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        rowStacks.forEach({ self.addSubview($0) })
        
        
        // set constraints for the label
        titleLabel.text = instrumentGroup.purpose
        titleLabel.font = UIFont.boldSystemFontOfSize(labelFontSize)
        titleLabel.textColor = UIColor(red: 1.0, green: (65.0 / 255.0), blue: 0.0, alpha: 1.0)
        titleLabel.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        titleLabel.topAnchor.constraintEqualToAnchor(margins.topAnchor).active = true
        
        // widest row should butt up against leading
        let widestRow = rowStacks[widestRowIndex];
        widestRow.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor).active = true
        
        // set constraints for each row
        for (index, row) in rowStacks.enumerate() {
            if index == 0 {
                row.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: labelBottomMargin).active = true
            } else {
                row.topAnchor.constraintEqualToAnchor(rowStacks[index - 1].bottomAnchor).active = true
            }
            row.centerXAnchor.constraintEqualToAnchor(widestRow.centerXAnchor).active = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTap(button: MagicSheetCircleView) {
        print("tapped!!!!")
    }
    
    override func updateConstraints() {
        
        titleLabel.font = UIFont.boldSystemFontOfSize(labelFontSize)
        
        for rowStack in rowStacks {
            for subview in rowStack.subviews {
                if let circleView = subview as? MagicSheetCircleView {
                    
                    // TODO: Surely a better way to update the constraint than deleting and re-adding
                    
                    circleView.removeConstraints(circleView.constraints.filter({ $0.identifier == "heightConstraint" }))
                    let newHeightConstraint = circleView.heightAnchor.constraintEqualToAnchor(nil, constant: circleSize)
                    newHeightConstraint.active = true
                    newHeightConstraint.identifier = "heightConstraint"
                }
            }
        }
        super.updateConstraints()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let height = titleLabel.intrinsicContentSize().height + (CGFloat(rowStacks.count) * circleSize) + labelBottomMargin
        let width = max(titleLabel.intrinsicContentSize().width, CGFloat(largestRowCount) * circleSize)
        
        return CGSize(width: width, height: height)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    // MARK: Interface Sizes
    private var labelFontSize: CGFloat {
        return 20.0
    }
    
    private var circleSize: CGFloat {
        return 70.0
    }

}
