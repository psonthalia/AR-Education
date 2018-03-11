//
//  Multiplayer.swift
//  AR Education
//
//  Created by Paran Sonthalia on 3/11/18.
//  Copyright © 2018 Mango Apps. All rights reserved.
//

import Foundation
import UIKit
import Firebase
//import FirebaseDatabase

class MultiplayerViewController: UIViewController {
    var ref: DatabaseReference!
    var positionArray: [[Character]] = []
    var originalPlayerX = 0
    var originalPlayerY = 0
    @IBOutlet weak var joinGameField: UITextField!
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        buildGrid()
    }
    
    @objc func buildGrid() {
        var gridContents = ""
        if let filepath = Bundle.main.path(forResource: "multiplayer", ofType: "txt") {
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
            if(number != " ") {
                positionArray[indexY].append(number)
                print(number)
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
    
    @IBAction func joinGame(_ sender: Any) {
        ARCameraMultiplayerViewController.code = joinGameField.text!
        ARCameraMultiplayerViewController.playerName = "player2"
        ARCameraMultiplayerViewController.positionArray = positionArray
        self.performSegue(withIdentifier: Constants.Segue.toARMultiplayerCamera, sender: nil)
    }
    @IBAction func createGame(_ sender: Any) {
        let code = String(arc4random_uniform(10001))
        print(code)

        let childUpdates = ["/\(code)/player1": ["first"],
                            "/\(code)/player2": ["first"]]
        
        self.ref.updateChildValues(childUpdates)
        
        
        ARCameraMultiplayerViewController.code = code
        ARCameraMultiplayerViewController.playerName = "player1"
        ARCameraMultiplayerViewController.positionArray = positionArray
        self.performSegue(withIdentifier: Constants.Segue.toARMultiplayerCamera, sender: nil)
    }
}
