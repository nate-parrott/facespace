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
    required init(anchorNode: SCNNode, sceneNode: SCNNode, sceneView: ARSCNView) {
        self.anchorNode = anchorNode
        self.sceneNode = sceneNode
        self.sceneView = sceneView
    }
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
    
    class var info: Info {
        return Info(emoji: "❓", name: "Filter")
    }
    
    func stop() {
        
    }
    
    var sceneBackground: Any? {
        return nil
    }
    
    var lightingEnvironment: Any? {
        return nil
    }
}

extension FaceFilter {
    static let all: [FaceFilter.Type] = [
        BigSpenderFilter.self,
        DataFilter.self,
        BubbleFilter.self,
        MetalFaceFilter.self,
        BrandmanFilter.self,
        SkullFilter.self,
        ToiletFilter.self
    ]
}
