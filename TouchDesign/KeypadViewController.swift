//
//  KeypadViewController.swift
//  TouchDesign
//
//  Created by Harry Shamansky on 9/29/15.
//  Copyright © 2015 Harry Shamansky. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class KeypadViewController: UIViewController {

    var currentCommand: Command?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //advertiser?.stopAdvertisingPeer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Button Press
    @IBAction func keypadButtonDidPress(sender: UIButton) {
        
        if currentCommand == nil {
            currentCommand = Command(withKeystrokes: [])
        }
        
        switch (sender.titleLabel!.text!) {
            case "+":   // plus should be sent as the equals key (no shift)
                currentCommand?.keystrokes.append(kAndKeystroke)
            case "At":
                currentCommand?.keystrokes.append(kAtKeystroke)
            case "Enter":
                currentCommand?.keystrokes.append(kEnterKeystroke)
                (UIApplication.sharedApplication().delegate as! AppDelegate).multipeerManager.sendCommand(currentCommand!)
                currentCommand = nil
            case "Out":
                currentCommand?.keystrokes.append(kOutKeystroke)
                (UIApplication.sharedApplication().delegate as! AppDelegate).multipeerManager.sendCommand(currentCommand!)
                currentCommand = nil
            case "Thru":
                currentCommand?.keystrokes.append(kThruKeystroke)
            case "Full":
                currentCommand?.keystrokes.append(kFullKeystroke)
            case "Clear":
                currentCommand = nil
            default:
                currentCommand?.keystrokes.append(Keystroke(identifier: sender.titleLabel!.text!, keyEquivalent: sender.titleLabel!.text!.characters.first!, plaintext: sender.titleLabel!.text!))
        }
    }
}
