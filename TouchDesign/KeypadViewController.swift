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

    @IBOutlet weak var commandLineLabel: UILabel!
    
    var currentCommand: Command?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commandLineLabel.text = ""
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
                commandLineLabel.text = currentCommand?.description
                currentCommand = nil
            case "Out":
                currentCommand?.keystrokes.append(kOutKeystroke)
                (UIApplication.sharedApplication().delegate as! AppDelegate).multipeerManager.sendCommand(currentCommand!)
                commandLineLabel.text = currentCommand?.description
                currentCommand = nil
            case "Thru":
                currentCommand?.keystrokes.append(kThruKeystroke)
            case "Full":
                currentCommand?.keystrokes.append(kFullKeystroke)
            case "Clear":
                commandLineLabel.text = ""
                currentCommand = nil
            default:
                currentCommand?.keystrokes.append(Keystroke(identifier: sender.titleLabel!.text!, keyEquivalent: sender.titleLabel!.text!.characters.first!, plaintext: sender.titleLabel!.text!))
        }
        
        if let command = currentCommand {
            commandLineLabel.text = command.description
        }
    }
}
