//
//  ARCameraMultiplayerViewController.swift
//  AR Education
//
//  Created by Paran Sonthalia on 3/11/18.
//  Copyright © 2018 Mango Apps. All rights reserved.
//

import UIKit
import ARKit
import Firebase

class ARCameraMultiplayerViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    var gridContents:String = ""
    static var programSequence:SCNAction! = nil
    static var positionArray: [[Character]] = []
    static var timeToCollectible = 0.0
    var displayPlane = true
    var collectibleNode2 = SCNNode()
    var robotNode2 = SCNNode()
    var pointerNode2 = SCNNode()
    var robotOpponentNode2 = SCNNode()

    var x:Float = 0.0
    var y:Float = 0.0
    var z:Float = 0.0
    var originalX:Float = 0.0
    
    @IBOutlet weak var codeField: UITextField!
    static var code = ""
    static var playerName = ""
    var ref: DatabaseReference!
    var postDict: [String] = []
    
    @IBOutlet weak var codeLabel: UILabel!
    var playerX = 0
    var playerZ = 0
    
    var opponentX = 0
    var opponentY = 0
    
    var movesCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeLabel.text = ARCameraMultiplayerViewController.code
        if(ARCameraMultiplayerViewController.playerName == "player1") {
            playerX = 1
            playerZ = 1
            opponentX = 14
            opponentY = 14
        } else {
            playerX = 14
            playerZ = 14
            opponentX = 1
            opponentY = 1
        }
        addTapGestureToSceneView()
        configureLighting()
        
        codeField.delegate = self
        
        ref = Database.database().reference()
        
        var tempString = ""
        if(ARCameraMultiplayerViewController.playerName == "player1") {
            tempString = "player2"
        } else {
            tempString = "player1"
        }
        var refHandler = ref.child(ARCameraMultiplayerViewController.code).child(tempString).observe(DataEventType.value, with: { (snapshot) in
            self.postDict = snapshot.value as! [String]
            if(self.postDict[self.postDict.count-1].contains("moveForward")) {
                self.robotOpponentNode2.runAction(SCNAction.move(by: SCNVector3(0.2, 0, 0), duration: 0.5))
            } else if(self.postDict[self.postDict.count-1].contains("moveBackward")) {
                self.robotOpponentNode2.runAction(SCNAction.move(by: SCNVector3(-0.2, 0, 0), duration: 0.5))
            } else if(self.postDict[self.postDict.count-1].contains("moveLeft")) {
                self.robotOpponentNode2.runAction(SCNAction.move(by: SCNVector3(0, 0, -0.2), duration: 0.5))
            } else if(self.postDict[self.postDict.count-1].contains("moveRight")) {
                self.robotOpponentNode2.runAction(SCNAction.move(by: SCNVector3(0, 0, 0.2), duration: 0.5))
            }
            print(self.postDict)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func setUpSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARCameraMultiplayerViewController.setUpGrid(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var array = postDict
        let codeFieldText = codeField.text!
        array.append(codeFieldText)
        if(codeFieldText.contains("moveBackward")) {
            //IF there's nothing in front of it, then:
            if (0 <= playerZ-1 && (ARCameraMultiplayerViewController.positionArray[playerZ-1][playerX] == "0" || ARCameraMultiplayerViewController.positionArray[playerZ-1][playerX] == "*")) {
                robotNode2.runAction(SCNAction.move(by: SCNVector3(0.2, 0, 0), duration: 0.5))
                pointerNode2.runAction(SCNAction.move(by: SCNVector3(0.2, 0, 0), duration: 0.5))
                playerZ -= 1
                if(ARCameraMultiplayerViewController.positionArray[playerZ][playerX] == "*") {
                    //                    ARCameraViewController.timeToCollectible = timeToCollectible
                }
                self.ref.child(ARCameraMultiplayerViewController.code).updateChildValues([ARCameraMultiplayerViewController.playerName: array])
                //                timeToCollectible += 0.5
                
            }
        }
            
        else if(codeFieldText.contains("moveForward")) {
            //IF nothing behind it, then:
            print(ARCameraMultiplayerViewController.positionArray[playerZ+1][playerX])
            if((ARCameraMultiplayerViewController.positionArray.count-1) >= (playerZ+1) && (ARCameraMultiplayerViewController.positionArray[playerZ+1][playerX] == "0" || ARCameraMultiplayerViewController.positionArray[playerZ+1][playerX] == "*")) {
                print("asdf2")
                robotNode2.runAction(SCNAction.move(by: SCNVector3(-0.2, 0, 0), duration: 0.5))
                pointerNode2.runAction(SCNAction.move(by: SCNVector3(-0.2, 0, 0), duration: 0.5))
                playerZ += 1
                if(ARCameraMultiplayerViewController.positionArray[playerZ][playerX] == "*") {
                    //                    ARCameraViewController.timeToCollectible = timeToCollectible
                }
                self.ref.child(ARCameraMultiplayerViewController.code).updateChildValues([ARCameraMultiplayerViewController.playerName: array])
                //                timeToCollectible += 0.5
            }
        }
            
        else if(codeFieldText.contains("moveRight")) {
            print(ARCameraMultiplayerViewController.positionArray)
            print(ARCameraMultiplayerViewController.positionArray.count)
            
            if(0 <= playerX-1 && (ARCameraMultiplayerViewController.positionArray[playerZ][playerX-1] == "0" || ARCameraMultiplayerViewController.positionArray[playerZ][playerX-1] == "*")) {
                robotNode2.runAction(SCNAction.move(by: SCNVector3(0, 0, 0.2), duration: 0.5))
                pointerNode2.runAction(SCNAction.move(by: SCNVector3(0, 0, 0.2), duration: 0.5))
                playerX -= 1
                if(ARCameraMultiplayerViewController.positionArray[playerZ][playerX] == "*") {
                    //                    ARCameraViewController.timeToCollectible = timeToCollectible
                }
                self.ref.child(ARCameraMultiplayerViewController.code).updateChildValues([ARCameraMultiplayerViewController.playerName: array])
                //                timeToCollectible += 0.5
            }
        }
            
        else if(codeFieldText.contains("moveLeft")) {
            if(ARCameraMultiplayerViewController.positionArray[playerZ].count-1 >= playerX+1 && (ARCameraMultiplayerViewController.positionArray[playerZ][playerX+1] == "0" || ARCameraMultiplayerViewController.positionArray[playerZ][playerX+1] == "*")) {
                robotNode2.runAction(SCNAction.move(by: SCNVector3(0, 0, -0.2), duration: 0.5))
                pointerNode2.runAction(SCNAction.move(by: SCNVector3(0, 0, -0.2), duration: 0.5))
                playerX += 1
                if(ARCameraMultiplayerViewController.positionArray[playerZ][playerX] == "*") {
                    //                    ARCameraViewController.timeToCollectible = timeToCollectible
                }
                self.ref.child(ARCameraMultiplayerViewController.code).updateChildValues([ARCameraMultiplayerViewController.playerName: array])
                //                timeToCollectible += 0.5
            }
        }
        
        return true
    }

    
    @objc func setUpGrid(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.translation
        x = translation.x - 0.5
        originalX = translation.x - 0.5
        y = translation.y
        z = translation.z - 2.0
        
        guard let robotScene = SCNScene(named: "robot_c.scn"),
            let robotNode = robotScene.rootNode.childNode(withName: "robot_combine", recursively: false)
            else { return }
        
        guard let pointerScene = SCNScene(named: "pointr.scn"),
            let pointerNode = pointerScene.rootNode.childNode(withName: "pointer", recursively: false)
            else { return }
        
        guard let waScene = SCNScene(named: "walla.scn"),
            let waNode = waScene.rootNode.childNode(withName: "wa", recursively: false)
            else { return }
        
        guard let wbScene = SCNScene(named: "wallb.scn"),
            let wbNode = wbScene.rootNode.childNode(withName: "wb", recursively: false)
            else { return }
        
        guard let wcScene = SCNScene(named: "wallc.scn"),
            let wcNode = wcScene.rootNode.childNode(withName: "wc", recursively: false)
            else { return }
        
        guard let wdScene = SCNScene(named: "walld.scn"),
            let wdNode = wdScene.rootNode.childNode(withName: "wd", recursively: false)
            else { return }
        
        guard let weScene = SCNScene(named: "walle.scn"),
            let weNode = weScene.rootNode.childNode(withName: "we", recursively: false)
            else { return }
        
        guard let wfScene = SCNScene(named: "wallf.scn"),
            let wfNode = wfScene.rootNode.childNode(withName: "wf", recursively: false)
            else { return }
        
        guard let wgScene = SCNScene(named: "wallg.scn"),
            let wgNode = wgScene.rootNode.childNode(withName: "wg", recursively: false)
            else { return }
        
        guard let whScene = SCNScene(named: "wallh.scn"),
            let whNode = whScene.rootNode.childNode(withName: "wh", recursively: false)
            else { return }
        
        guard let wiScene = SCNScene(named: "walli.scn"),
            let wiNode = wiScene.rootNode.childNode(withName: "wi", recursively: false)
            else { return }
        
        guard let wjScene = SCNScene(named: "wallj.scn"),
            let wjNode = wjScene.rootNode.childNode(withName: "wj", recursively: false)
            else { return }
        
        guard let collectibleScene = SCNScene(named: "collectibl.scn"),
            let collectibleNode = collectibleScene.rootNode.childNode(withName: "collectible", recursively: false)
            else { return }
        
        guard let spikeScene = SCNScene(named: "spik.scn"),
            let spikeNode = spikeScene.rootNode.childNode(withName: "spike", recursively: false)
            else { return }
        
        guard let robotOpponentScene = SCNScene(named: "robot_c_e.scn"),
            let robotOpponentNode = robotOpponentScene.rootNode.childNode(withName: "robot_c_e", recursively: false)
            else { return }
        
        for i in 0...ARCameraMultiplayerViewController.positionArray.count-1 {
            for j in 0...ARCameraMultiplayerViewController.positionArray[i].count-1 {
                let number = ARCameraMultiplayerViewController.positionArray[i][j]
                displayPlane = false
                if(number == "a") {
                    let node = waNode.copy() as!SCNNode
                    node.position = SCNVector3(x,y+0.075,z)
                    sceneView.scene.rootNode.addChildNode(node)
                }
                else if(number == "b") {
                    let node = wbNode.copy() as!SCNNode
                    node.position = SCNVector3(x,y+0.075,z)
                    sceneView.scene.rootNode.addChildNode(node)
                }
                else if(number == "c") {
                    let node = wcNode.copy() as!SCNNode
                    node.position = SCNVector3(x,y,z)
                    sceneView.scene.rootNode.addChildNode(node)
                }
                else if(number == "d") {
                    let node = wdNode.copy() as!SCNNode
                    node.position = SCNVector3(x,y,z)
                    sceneView.scene.rootNode.addChildNode(node)
                }
                else if(number == "e") {
                    let node = weNode.copy() as!SCNNode
                    node.position = SCNVector3(x,y,z)
                    sceneView.scene.rootNode.addChildNode(node)
                }
                else if(number == "f") {
                    let node = wfNode.copy() as!SCNNode
                    node.position = SCNVector3(x,y,z)
                    sceneView.scene.rootNode.addChildNode(node)
                }
                else if(number == "g") {
                    let node = wgNode.copy() as!SCNNode
                    node.position = SCNVector3(x,y,z)
                    sceneView.scene.rootNode.addChildNode(node)
                }
                else if(number == "h") {
                    let node = whNode.copy() as!SCNNode
                    node.position = SCNVector3(x,y,z)
                    sceneView.scene.rootNode.addChildNode(node)
                }
                else if(number == "i") {
                    let node = wiNode.copy() as!SCNNode
                    node.position = SCNVector3(x,y,z)
                    sceneView.scene.rootNode.addChildNode(node)
                }
                else if(number == "j") {
                    let node = wjNode.copy() as!SCNNode
                    node.position = SCNVector3(x,y,z)
                    sceneView.scene.rootNode.addChildNode(node)
                }
                else if(number == "o") {
                    let node = spikeNode.copy() as!SCNNode
                    node.position = SCNVector3(x,y,z)
                    sceneView.scene.rootNode.addChildNode(node)
                }
                else if(number == "s") {
                    robotNode2 = robotNode.copy() as!SCNNode
                    robotNode2.position = SCNVector3(x,y-0.387,z)
                    sceneView.scene.rootNode.addChildNode(robotNode2)
                    
                    pointerNode2 = pointerNode.copy() as!SCNNode
                    pointerNode2.position = SCNVector3(x+0.1,y,z)
                    sceneView.scene.rootNode.addChildNode(pointerNode2)
                }
                else if(number == "x") {
                    robotOpponentNode2 = robotOpponentNode.copy() as!SCNNode
                    robotOpponentNode2.position = SCNVector3(x,y-0.387,z)
                    sceneView.scene.rootNode.addChildNode(robotOpponentNode2)
                }
                else if(number == "*") {
                    collectibleNode2 = collectibleNode.copy() as!SCNNode
                    collectibleNode2.position = SCNVector3(x,y+0.075,z)
                    sceneView.scene.rootNode.addChildNode(collectibleNode2)
                    if(ARCameraMultiplayerViewController.timeToCollectible != 0.0) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + ARCameraMultiplayerViewController.timeToCollectible + 0.2) {
                            self.collectibleNode2.removeFromParentNode()
                        }
                    }
                }
                x += 0.2
            }
            x = originalX
            z += 0.2
        }
        sceneView.scene.rootNode.addChildNode(robotOpponentNode2)
    }
}

//extension float4x4 {
//    var translation: float3 {
//        let translation = self.columns.3
//        return float3(translation.x, translation.y, translation.z)
//    }
//}
//
//extension UIColor {
//    open class var transparentLightBlue: UIColor {
//        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
//    }
//}

extension ARCameraMultiplayerViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        // 3
        plane.materials.first?.diffuse.contents = UIColor.transparentLightBlue
        
        // 4
        let planeNode = SCNNode(geometry: plane)
        
        // 5
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        // 6
        node.addChildNode(planeNode)
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        if(displayPlane == false) {
            plane.width = 0
            plane.height = 0
        }
        
        // 3
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
}

