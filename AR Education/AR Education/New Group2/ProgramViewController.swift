//
//  ProgramViewController.swift
//  AR Education
//
//  Created by Paran Sonthalia on 3/10/18.
//  Copyright © 2018 Mango Apps. All rights reserved.
//

import UIKit
import ARKit
import Foundation

class ProgramViewController: UIViewController {
    @IBOutlet weak var codeView: UITextView!
    override func viewDidLoad() {
        let runButton = UIBarButtonItem(title: "Run", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RunClicked))
        self.navigationItem.rightBarButtonItem = runButton
    }
    @objc func RunClicked() {
        let lineArray = codeView.text.components(separatedBy:"\n")
        var commandArray = [SCNAction]()
        for i in 0 ... lineArray.count-1 {
            if(lineArray[i].contains("moveForward")) {
                let count = Int(lineArray[i].suffix(lineArray[i].count - 12))
                commandArray.append(SCNAction.move(by: SCNVector3(1.0, 0, 0), duration: 1))
                print(count!)
            }
        }
        let hoverSequence = SCNAction.sequence(commandArray)
        ViewController.programSequence = hoverSequence
        self.performSegue(withIdentifier: Constants.Segue.toARCamera, sender: nil)
    }
}
