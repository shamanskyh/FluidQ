//
//  MagicSheetSpacerView.swift
//  FluidQ
//
//  Created by Harry Shamansky on 12/7/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import UIKit

class MagicSheetHalfSizeSpacerView: UIView {
    override func intrinsicContentSize() -> CGSize {
        if self.traitCollection.horizontalSizeClass == .Compact {
            return CGSize(width: 17, height: 34)
        } else {
            return CGSize(width: 40, height: 60)
        }
    }
}

class MagicSheetThirdSizeSpacerView: UIView {
    override func intrinsicContentSize() -> CGSize {
        if self.traitCollection.horizontalSizeClass == .Compact {
            return CGSize(width: 11, height: 34)
        } else {
            return CGSize(width: 26, height: 60)
        }
    }
}
