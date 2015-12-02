//
//  MagicSheetViewController.swift
//  FluidQ
//
//  Created by Harry Shamansky on 11/16/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import UIKit

class MagicSheetViewController: UICollectionViewController {

    var instrumentGroups: [InstrumentGroup] = []
    
    var selectedChannels: [Int] = []
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    init(instruments: [Instrument]) {
        
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)

        // group by purpose first
        // use parallel arrays
        var purposes: [String] = []
        var groupedInstruments: [[Instrument]] = []
        let filteredInstruments = instruments.filter({ $0.purpose != nil })

        for i in 0..<filteredInstruments.count {
            if purposes.count == 0 {
                purposes.append(filteredInstruments[i].purpose!)
                groupedInstruments.append([filteredInstruments[i]])
            } else {
                var foundMatch = false
                for j in 0..<purposes.count {
                    if filteredInstruments[i].purpose == purposes[j] {
                        groupedInstruments[j].append(filteredInstruments[i])
                        foundMatch = true
                    }
                }
                if !foundMatch {
                    purposes.append(filteredInstruments[i].purpose!)
                    groupedInstruments.append([filteredInstruments[i]])
                }
            }
        }
        
        for i in 0..<groupedInstruments.count {
            instrumentGroups.append(InstrumentGroup(withInstruments: groupedInstruments[i], purpose: purposes[i]))
        }
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTap:")
        
        //collectionView?.delaysContentTouches = false
        //collectionView?.canCancelContentTouches = false
        //collectionView?.exclusiveTouch = false
    }
    
    func didTap(gestureRecognizer: UITapGestureRecognizer) {
        let tapPoint = gestureRecognizer.locationInView(self.view)
        let indexPath = collectionView?.indexPathForItemAtPoint(tapPoint)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.registerClass(MagicSheetCollectionViewCell.self, forCellWithReuseIdentifier: "MagicSheetCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            self.collectionViewLayout.invalidateLayout()
            self.collectionView?.reloadData()

//            for subview in self.view.subviews {
//                if let groupView = subview as? MagicSheetPurposeGroupView {
//                    groupView.setNeedsUpdateConstraints()
//                    groupView.updateConstraintsIfNeeded()
//                    groupView.updateCircleConstraints()
//                }
//            }
            }, completion: { (context: UIViewControllerTransitionCoordinatorContext) -> Void in
                //self.collectionViewLayout.invalidateLayout()
                //self.collectionView?.reloadData()
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UICollectionViewDataSource Protocol Conformance
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instrumentGroups.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MagicSheetCell", forIndexPath: indexPath) as! MagicSheetCollectionViewCell
            
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let groupView = MagicSheetPurposeGroupView(withInstrumentGroup: instrumentGroups[indexPath.item])
        groupView.setNeedsUpdateConstraints()
        groupView.updateConstraintsIfNeeded()
        
        cell.contentView.addSubview(groupView)
        return cell
    }
    
    
}

extension MagicSheetViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let groupView = MagicSheetPurposeGroupView(withInstrumentGroup: instrumentGroups[indexPath.item])
        groupView.setNeedsUpdateConstraints()
        groupView.updateConstraintsIfNeeded()
        
        return CGSizeMake(min(groupView.intrinsicContentSize().width, collectionView.frame.width), min(groupView.intrinsicContentSize().height, collectionView.frame.height))

    }
    
}