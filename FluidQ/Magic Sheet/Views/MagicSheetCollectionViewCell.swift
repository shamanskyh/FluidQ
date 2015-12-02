//
//  MagicSheetCollectionViewCell.swift
//  FluidQ
//
//  Created by Harry Shamansky on 11/27/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import UIKit

class MagicSheetCollectionViewCell: UICollectionViewCell {
    
    override func intrinsicContentSize() -> CGSize {
        if let groupView = self.contentView.subviews.first as? MagicSheetPurposeGroupView {
            return groupView.intrinsicContentSize()
        }
        return CGSizeZero
    }
    
}
