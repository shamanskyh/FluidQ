//
//  CirclesViewController.swift
//  TouchDesign
//
//  Created by Harry Shamansky on 10/12/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import UIKit

class CirclesViewController: UIViewController {

    let multipeerManager = MultipeerManager()
    
    var circle1: CircleView?
    var circle2: CircleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Draw two circles and attach gesture recognizers to them
        circle1 = CircleView(frame: CGRect(x: 40, y: 40, width: 100, height: 100))
        circle1?.groupName = "Warm Front"
        circle1?.color = UIColor(red: (294.0/255.0), green: (199.0/255.0), blue: (156.0/255.0), alpha: 0.95)
        let panGestureRecognizer1 = UIPanGestureRecognizer(target: self, action: "handlePanCircle:")
        panGestureRecognizer1.delegate = self
        let pinchGestureRecognizer1 = UIPinchGestureRecognizer(target: self, action: "handlePinchCircle:")
        pinchGestureRecognizer1.delegate = self
        circle1?.addGestureRecognizer(panGestureRecognizer1)
        circle1?.addGestureRecognizer(pinchGestureRecognizer1)
        
        circle2 = CircleView(frame: CGRect(x: 40, y: 400, width: 100, height: 100))
        circle2?.groupName = "Cool Front"
        circle2?.color = UIColor(red: (192.0/255.0), green: (206.0/255.0), blue: (255.0/255.0), alpha: 0.95)
        let panGestureRecognizer2 = UIPanGestureRecognizer(target: self, action: "handlePanCircle:")
        panGestureRecognizer2.delegate = self
        let pinchGestureRecognizer2 = UIPinchGestureRecognizer(target: self, action: "handlePinchCircle:")
        pinchGestureRecognizer2.delegate = self
        circle2?.addGestureRecognizer(panGestureRecognizer2)
        circle2?.addGestureRecognizer(pinchGestureRecognizer2)
        
        view.addSubview(circle1!)
        view.addSubview(circle2!)
    }
    
    func handlePanCircle(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func handlePinchCircle(recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view as? CircleView {

            let scaledHeight = view.frame.height * recognizer.scale
            let scaledWidth = view.frame.width * recognizer.scale
            let centerPoint = view.center
            
            view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: scaledWidth, height: scaledHeight)
            view.center = centerPoint
            
            // send signal to the board if the intensity has changed significantly (avoid duplicate calls)
            if view.previousIntensity != view.intensityLevel {
                view.previousIntensity = view.intensityLevel
                
                if view.groupName == "Warm Front" {
                    multipeerManager.sendCommand(Command(withKeystrokes: [k1Keystroke, kAtKeystroke] + doubleToKeystrokes(Double(view.intensityLevel)) + [kEnterKeystroke]))
                } else {
                    multipeerManager.sendCommand(Command(withKeystrokes: [k2Keystroke, kAtKeystroke] + doubleToKeystrokes(Double(view.intensityLevel)) + [kEnterKeystroke]))
                }
            }
            recognizer.scale = 1
        }
        recognizer.view?.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CirclesViewController: UIGestureRecognizerDelegate {
    
    // allow pinch and pan at the same time
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
