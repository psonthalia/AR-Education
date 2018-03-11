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
    var positionArray: [[Character]] = []
    var originalPlayerX = 0
    var originalPlayerY = 0

    override func viewDidLoad() {
        let runButton = UIBarButtonItem(title: "Run", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RunClicked))
        self.navigationItem.rightBarButtonItem = runButton
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        codeView.text = "moveForward\nmoveForward\nmoveLeft\nmoveLeft\nmoveBackward\nmoveBackward\nmoveRight\nmoveRight"
    }
    @objc func dismissKeyboard() {
        codeView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    @objc func buildGrid() {
        var gridContents = ""
        if let filepath = Bundle.main.path(forResource: "testGrid", ofType: "txt") {
            do {
                gridContents = try String(contentsOfFile: filepath)
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        
        //convert string to 2D array
        var indexY = 0
        positionArray.append([])
        var indexX = 0
        for number:Character in gridContents {
            if(number != "\n") {
                positionArray[indexY].append(number)
                if(positionArray[indexY][indexX] == "s") {
                    originalPlayerX = indexX
                    originalPlayerY = indexY
                }
                indexX += 1
            } else {
                indexY += 1
                indexX = 0
                positionArray.append([])
            }
        }
        positionArray.removeLast()
    }
    @objc func RunClicked() {
        buildGrid()
        let lineArray = codeView.text.components(separatedBy:"\n")
        var commandArray = [SCNAction]()
        var playerX = originalPlayerX
        var playerZ = originalPlayerY
        
        for i in 0 ... lineArray.count-1 {
            if(lineArray[i].contains("moveForward")) {
//                let count:Double! = Double(lineArray[i].suffix(lineArray[i].count - 12))
                //IF there's nothing in front of it, then:
                commandArray.append(SCNAction.move(by: SCNVector3(0.1, 0, 0), duration: 0.5))
//                print(count)
                playerX += 1
                if(positionArray[playerZ][playerX] != "0" && positionArray[playerZ][playerX] != "*") {
                    break
                }
            }
            else if(lineArray[i].contains("moveBackward")) {
                //IF nothing behind it, then:
                commandArray.append(SCNAction.move(by: SCNVector3(-0.1, 0, 0), duration: 0.5))
                playerX -= 1
                if(positionArray[playerZ][playerX] != "0" && positionArray[playerZ][playerX] != "*") {
                    break
                }
            }
            else if(lineArray[i].contains("moveLeft")) {
                //IF nothing to the left of it, then:
                commandArray.append(SCNAction.move(by: SCNVector3(0, 0, 0.1), duration: 0.5))
                playerZ += 1
                if(positionArray[playerZ][playerX] != "0" && positionArray[playerZ][playerX] != "*") {
                    break
                }
            }
            else if(lineArray[i].contains("moveRight")) {
                //IF nothing to the right of it, then:
                commandArray.append(SCNAction.move(by: SCNVector3(0, 0, -0.1), duration: 0.5))
                playerZ -= 1
                if(positionArray[playerZ][playerX] != "0" && positionArray[playerZ][playerX] != "*") {
                    break
                }
            }
        }
        let hoverSequence = SCNAction.sequence(commandArray)
        ARCameraViewController.programSequence = hoverSequence
        self.performSegue(withIdentifier: Constants.Segue.toARCamera, sender: nil)
    }
}
