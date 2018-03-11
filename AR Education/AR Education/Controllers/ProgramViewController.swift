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
    var runButton = UIBarButtonItem()
    var viewLevelButton = UIBarButtonItem()
    var fixedSpace = UIBarButtonItem()
    
    override func viewWillAppear(_ animated: Bool) {
        runButton = UIBarButtonItem(title: "Run", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RunClicked))
        viewLevelButton = UIBarButtonItem(title: "View Level", style: UIBarButtonItemStyle.plain, target: self, action: #selector(viewLevel))
        fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 20.0
        
        self.navigationItem.rightBarButtonItems = [runButton, fixedSpace, viewLevelButton]
    }

    override func viewDidLoad() {
        buildGrid()
        
        runButton = UIBarButtonItem(title: "Run", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RunClicked))
        viewLevelButton = UIBarButtonItem(title: "View Level", style: UIBarButtonItemStyle.plain, target: self, action: #selector(viewLevel))
        fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 20.0
        
        self.navigationItem.rightBarButtonItems = [runButton, fixedSpace, viewLevelButton]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        codeView.text = "moveForward\nmoveForward\nmoveLeft\nmoveLeft\nmoveBackward\nmoveBackward\nmoveRight\nmoveRight"
    }
    @objc func viewLevel() {
        viewLevelButton.isEnabled = true
        ARCameraViewController.programSequence = nil
        ARCameraViewController.positionArray = positionArray

        self.performSegue(withIdentifier: Constants.Segue.toARCamera, sender: nil)
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
        runButton.isEnabled = true
        let lineArray = codeView.text.components(separatedBy:"\n")
        var commandArray = [SCNAction]()
        var playerX = originalPlayerX
        var playerZ = originalPlayerY
        var timeToCollectible = 0.0
        
        for i in 0 ... lineArray.count-1 {
            if(lineArray[i].contains("moveForward")) {
                //IF there's nothing in front of it, then:
                if(positionArray[playerZ][playerX+1] != "0" && positionArray[playerZ][playerX+1] != "*") {
                    break
                }
                else {
                    commandArray.append(SCNAction.move(by: SCNVector3(0.2, 0, 0), duration: 0.5))
                    playerX += 1
                    if(positionArray[playerZ][playerX] == "*") {
                        ARCameraViewController.timeToCollectible = timeToCollectible
                    }
                    timeToCollectible += 0.5
                }
                
            }
            else if(lineArray[i].contains("moveBackward")) {
                //IF nothing behind it, then:
                if(positionArray[playerZ][playerX-1] != "0" && positionArray[playerZ][playerX-1] != "*") {
                    break
                } else {
                    commandArray.append(SCNAction.move(by: SCNVector3(-0.2, 0, 0), duration: 0.5))
                    playerX -= 1
                    if(positionArray[playerZ][playerX] == "*") {
                        ARCameraViewController.timeToCollectible = timeToCollectible
                    }
                    timeToCollectible += 0.5
                }
            }
            else if(lineArray[i].contains("moveLeft")) {
                //IF nothing to the left of it, then:
                if(positionArray[playerZ+1][playerX] != "0" && positionArray[playerZ+1][playerX] != "*") {
                    break
                } else {
                    commandArray.append(SCNAction.move(by: SCNVector3(0, 0, 0.2), duration: 0.5))
                    playerZ += 1
                    if(positionArray[playerZ][playerX] == "*") {
                        ARCameraViewController.timeToCollectible = timeToCollectible
                    }
                    timeToCollectible += 0.5
                }
            }
            else if(lineArray[i].contains("moveRight")) {
                //IF nothing to the right of it, then:
                if(positionArray[playerZ-1][playerX] != "0" && positionArray[playerZ-1][playerX] != "*") {
                    break
                } else {
                    commandArray.append(SCNAction.move(by: SCNVector3(0, 0, -0.2), duration: 0.5))
                    playerZ -= 1
                    if(positionArray[playerZ][playerX] == "*") {
                        ARCameraViewController.timeToCollectible = timeToCollectible
                    }
                    timeToCollectible += 0.5
                }
            }
        }
        let hoverSequence = SCNAction.sequence(commandArray)
        ARCameraViewController.programSequence = hoverSequence
        ARCameraViewController.positionArray = positionArray
        
        self.performSegue(withIdentifier: Constants.Segue.toARCamera, sender: nil)
    }
}
