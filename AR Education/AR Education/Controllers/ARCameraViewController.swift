//
//  ViewController.swift
//  AR Education
//
//  Created by Paran Sonthalia on 3/10/18.
//  Copyright © 2018 Mango Apps. All rights reserved.
//

import UIKit
import ARKit

class ARCameraViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    var gridContents:String = ""
    static var programSequence:SCNAction! = nil
    static var positionArray: [[Character]] = []
    static var timeToCollectible = 0.0
    var displayPlane = true
    var collectibleNode2 = SCNNode()
    var pointerNode2 = SCNNode()

    var x:Float = 0.0
    var y:Float = 0.0
    var z:Float = 0.0
    var originalX:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToSceneView()
        configureLighting()
        
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
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARCameraViewController.setUpGrid(withGestureRecognizer:)))
        
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func setUpGrid(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.translation
        x = translation.x - 1.2
        originalX = translation.x - 1.2
        y = translation.y
        z = translation.z - 1.5
        
        /* iPhone X
        x = translation.x - 0.2
        originalX = translation.x - 0.2
        y = translation.y
        z = translation.z - 1.2
        */
        
        /*  iPhone 6s
        x = translation.x - 1.2
        originalX = translation.x - 1.2
        y = translation.y
        z = translation.z - 1.5
        */
 
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
        
        for i in 0...ARCameraViewController.positionArray.count-1 {
            for j in 0...ARCameraViewController.positionArray[i].count-1 {
                let number = ARCameraViewController.positionArray[i][j]
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
                    let node = robotNode.copy() as!SCNNode
                    node.position = SCNVector3(x,y-0.387,z)
                    pointerNode2 = pointerNode.copy() as! SCNNode
                    pointerNode2.position = SCNVector3(x+0.05,y+0.05,z)
                    if(ARCameraViewController.programSequence != nil) {
                        node.runAction(ARCameraViewController.programSequence)
                        pointerNode2.runAction(ARCameraViewController.programSequence)
                    }
                    sceneView.scene.rootNode.addChildNode(node)
                    sceneView.scene.rootNode.addChildNode(pointerNode2)
                }
                else if(number == "*") {
                    collectibleNode2 = collectibleNode.copy() as!SCNNode
                    collectibleNode2.position = SCNVector3(x,y+0.075,z)
                    sceneView.scene.rootNode.addChildNode(collectibleNode2)
                    
                    if(ARCameraViewController.timeToCollectible != 0.0) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + ARCameraViewController.timeToCollectible + 0.2) { // change 2 to desired number of seconds
                            self.collectibleNode2.removeFromParentNode()
                            
                            let myalert = UIAlertController(title: "Congratulations!", message: "You have completed the level!", preferredStyle: UIAlertControllerStyle.alert)
                            
                            myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                print("Selected")
                            })
                            
                            self.present(myalert, animated: true)
                            ARCameraViewController.timeToCollectible = 0.0
                        }
                    }
                }
                x += 0.2
            }
            x = originalX
            z += 0.2
        }
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

extension ARCameraViewController: ARSCNViewDelegate {
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
