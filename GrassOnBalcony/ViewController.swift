//
//  ViewController.swift
//  GrassOnBalcony
//
//  Created by Vikash Kumar on 26/07/18.
//  Copyright © 2018 Vikash Kumar. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var grids = [Grid]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Add a touch event
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(tapped))
        sceneView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // 1. When a plane detection happened
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        let grid = Grid(anchor: anchor as! ARPlaneAnchor)
//        self.grids.append(grid)
//        node.addChildNode(grid)
    }
    // 2. When the detected plane got updated
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        let grid = self.grids.filter { grid in
//            return grid.anchor.identifier == anchor.identifier
//            }.first
//
//        guard let foundGrid = grid else {
//            return
//        }
//
//        foundGrid.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    @objc func tapped(gesture: UITapGestureRecognizer) {
        // Get exact position where touch happened on screen of iPhone (2D coordinate)
        let touchPosition = gesture.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchPosition, types: .existingPlaneUsingExtent)
        
        if !hitTestResult.isEmpty {
            guard let hitResult = hitTestResult.first else {
                return
            }
            addGrass(hitTestResult: hitResult)
        }
    }
    
    func addGrass(hitTestResult: ARHitTestResult) {
        let scene = SCNScene(named: "art.scnassets/mouthshark.dae")
        let node = scene?.rootNode.childNode(withName: "shark", recursively: true)
        node?.scale = SCNVector3(0.05, 0.05, 0.05)
        node?.position = SCNVector3(hitTestResult.worldTransform.columns.3.x,
                                         hitTestResult.worldTransform.columns.3.y,
                                         hitTestResult.worldTransform.columns.3.z
        )
        self.sceneView.scene.rootNode.addChildNode(node!)
    }
}
