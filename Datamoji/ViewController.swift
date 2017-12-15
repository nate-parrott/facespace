//
//  ViewController.swift
//  Datamoji
//
//  Created by Nate Parrott on 12/10/17.
//  Copyright © 2017 Nate Parrott. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var filterPicker: FilterPicker!
    private let workQueue = DispatchQueue(label: "workQueue") // serial queue by default
    private var sceneBgForCamera: Any?
    let defaultEnvironment = UIImage(named: "env.jpg")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        sceneView.automaticallyUpdatesLighting = true
        scene.lightingEnvironment.contents = defaultEnvironment
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.scene.physicsWorld.speed = 1
        
        sceneView.scene.rootNode.addChildNode(sceneNodeContainer)
        
        filterPicker.focusPicker.onChange = {
            [weak self] in
            guard let s = self else { return }
            s.faceFilterType = FaceFilter.all[s.filterPicker.focusPicker.selectedIndex]
        }
    }
    
    func updateFilter() {
        faceFilterType = FaceFilter.all[filterPicker.focusPicker.selectedIndex]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        if faceFilterType == nil {
            faceFilterType = FaceFilter.all.first!
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.sceneBgForCamera = self.sceneView.scene.background.contents
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: Filter picking and node containment
    
    let sceneNodeContainer = SCNNode()
    var sceneNode: SCNNode? {
        didSet(old) {
            old?.removeFromParentNode()
            if let n = sceneNode {sceneNodeContainer.addChildNode(n)  }
        }
    }
    let anchorNodeContainer = SCNNode()
    var anchorNode: SCNNode? {
        didSet(old) {
            old?.removeFromParentNode()
            if let a = anchorNode { anchorNodeContainer.addChildNode(a) }
        }
    }
    
    var faceFilterType: FaceFilter.Type! {
        didSet(old) {
            if faceFilterType != old {
                workQueue.async {
                    // clean up the old face filter:
                    self.faceFilter?.stop()
                    
                    // do it:
                    self.anchorNode = SCNNode()
                    self.sceneNode = SCNNode()
                    self.faceFilter = self.faceFilterType.init(anchorNode: self.anchorNode!, sceneNode: self.sceneNode!, sceneView: self.sceneView)
                }
            }
        }
    }
    
    var faceFilter: FaceFilter! {
        didSet {
            faceFilter.setup()
            faceFilter.configureCamera(sceneView.pointOfView!.camera!)
            faceFilter.show()
            sceneView.scene.background.contents = faceFilter.sceneBackground ?? sceneBgForCamera
            sceneView.scene.lightingEnvironment.contents = faceFilter.lightingEnvironment ?? defaultEnvironment
            _initializedFaceFilter = faceFilter
        }
    }
    private var _initializedFaceFilter: FaceFilter!
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if (anchor as? ARFaceAnchor) != nil {
            node.addChildNode(anchorNodeContainer)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor {
            _initializedFaceFilter?.update(anchor: faceAnchor)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
