//
//  ViewController.swift
//  AR Education
//
//  Created by Paran Sonthalia on 3/10/18.
//  Copyright © 2018 Mango Apps. All rights reserved.
//

import UIKit
import ARKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    var gridContents:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToSceneView()
        configureLighting()
        //        addCar()
        
        if let filepath = Bundle.main.path(forResource: "testGrid", ofType: "txt") {
            do {
                gridContents = try String(contentsOfFile: filepath)
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
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
    
    //    func addCar(x: Float = 0, y: Float = 0, z: Float = -0.5) {
    //        guard let carScene = SCNScene(named: "car.dae") else { return }
    //        let carNode = SCNNode()
    //        let carSceneChildNodes = carScene.rootNode.childNodes
    //        for childNode in carSceneChildNodes {
    //            carNode.addChildNode(childNode)
    //        }
    //        carNode.position = SCNVector3(x, y, z)
    //        carNode.scale = SCNVector3(0.5, 0.5, 0.5)
    //
    //        let moveForward = SCNAction.move(by: SCNVector3(1.0, 0, 0), duration: 1)
    //        let moveBack = SCNAction.move(by: SCNVector3(-1.0,0,0), duration: 1)
    //        let waitAction = SCNAction.wait(duration: 0.25)
    //        let hoverSequence = SCNAction.sequence([moveForward,waitAction,moveBack])
    //        let loopSequence = SCNAction.repeatForever(hoverSequence)
    //        carNode.runAction(loopSequence)
    //
    //        self.sceneView.scene.rootNode.addChildNode(carNode)
    //
    //        sceneView.scene.rootNode.addChildNode(carNode)
    //    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.addCar(withGestureRecognizer:)))
        
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func setUpGrid(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.translation
        var x = translation.x
        let y = translation.y
        var z = translation.z
        
        guard let shipScene = SCNScene(named: "ship.scn"),
            let shipNode = shipScene.rootNode.childNode(withName: "ship", recursively: false)
            else { return }
        
        guard let robotScene = SCNScene(named: "robot_combine.scn"),
            let robotNode = robotScene.rootNode.childNode(withName: "robot_combine", recursively: false)
            else { return }
        
        guard let planeScene = SCNScene(named: "plane.scn"),
            let planeNode = planeScene.rootNode.childNode(withName: "plane", recursively: false)
            else { return }
        
        for number:Character in gridContents {
            if(number != "\n") {                
                if(number == "1") {
                    let shipNode2 = shipNode.copy() as!SCNNode
                    shipNode2.position = SCNVector3(x,y,z)
                    sceneView.scene.rootNode.addChildNode(shipNode2)
                }
                else if(number == "2") {
                    let robotNode2 = robotNode.copy() as!SCNNode
                    robotNode2.position = SCNVector3(x,y,z)
                    sceneView.scene.rootNode.addChildNode(robotNode2)
                }
                else if(number == "3") {
                    print("plane")
                    let planeNode2 = planeNode.copy() as!SCNNode
                    planeNode2.position = SCNVector3(x,y,z)
                    sceneView.scene.rootNode.addChildNode(planeNode2)
                }
                x += 0.3
            } else {
                x = translation.x
                z += 1
            }
        }
    }
    
    @objc func addCar(withGestureRecognizer recognizer: UIGestureRecognizer) {
        setUpGrid(withGestureRecognizer: recognizer)
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y
        let z = translation.z
        
        guard let carScene = SCNScene(named: "ship.scn"),
            let carNode = carScene.rootNode.childNode(withName: "ship", recursively: false)
            else { return }
        
        
        carNode.position = SCNVector3(x,y,z)
        let moveForward = SCNAction.move(by: SCNVector3(1.0, 0, 0), duration: 1)
        let moveBack = SCNAction.move(by: SCNVector3(-1.0,0,0), duration: 1)
        let waitAction = SCNAction.wait(duration: 0.25)
        let hoverSequence = SCNAction.sequence([moveForward,waitAction,moveBack])
        let loopSequence = SCNAction.repeatForever(hoverSequence)
        carNode.runAction(loopSequence)
        
        sceneView.scene.rootNode.addChildNode(carNode)
    }
    
}


extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

extension UIColor {
    open class var transparentLightBlue: UIColor {
        return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
    }
}

extension ViewController: ARSCNViewDelegate {
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
        
        // 3
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
}

