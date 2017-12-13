//
//  FaceFilter.swift
//  Datamoji
//
//  Created by Nate Parrott on 12/10/17.
//  Copyright © 2017 Nate Parrott. All rights reserved.
//

import Foundation
import ARKit
import SceneKit
import CoreImage

class FaceFilter {
    init(anchor: ARFaceAnchor, anchorNode: SCNNode, sceneNode: SCNNode, sceneView: ARSCNView) {
        self.anchor = anchor
        self.anchorNode = anchorNode
        self.sceneNode = sceneNode
        self.sceneView = sceneView
    }
    let anchor: ARFaceAnchor
    let anchorNode: SCNNode
    let sceneNode: SCNNode
    weak var sceneView: ARSCNView!
    
    func setup() {
        // add content to the sceneNode and anchorNode
    }
    
    func configureCamera(_ camera: SCNCamera) {
        camera.colorGrading.contents = nil
    }
    
    func show() {
        
    }
    
    func update(anchor: ARFaceAnchor) {
        
    }
    
    struct Info {
        let emoji: String
        let name: String
    }
    
    var info: Info {
        return Info(emoji: "❓", name: "Filter")
    }
}
