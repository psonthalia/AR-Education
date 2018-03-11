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
        let countLines:Int = codeView.text.components(separatedBy:"\n").count
        for i in 0 ... countLines {
            
        }
    }
}
