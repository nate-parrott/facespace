//
//  BrandmanFilter.swift
//  Datamoji
//
//  Created by Nate Parrott on 12/12/17.
//  Copyright © 2017 Nate Parrott. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class BrandmanFilter : FaceFilter {
    var faceNode: SCNNode!
    var head: SCNNode!
    var morpher: SCNMorpher!
    
    override func setup() {
        super.setup()
        head = SCNScene(named: "brandman3fixed.scn", inDirectory: "brandman.scnassets", options: nil)!.rootNode.childNode(withName: "brandman", recursively: true)!
        head.rotation = SCNVector4(1, 0, 0, 0)
        // head.scale = SCNVector3(1/3000, 1/3000, 1/3000)
        head.centerAndNormalize(scale: 0.29)
        head.position.y += 0.04
        head.position.z -= 0.04
        morpher = head.morpher!
        anchorNode.addChildNode(head)
        morpher.unifiesNormals = true
    }
    
    override func update(anchor: ARFaceAnchor) {
        super.update(anchor: anchor)
        morpher.setWeight(anchor.getBlendShape(.jawOpen) * 2, forTargetNamed: "jawOpen")
        morpher.setWeight(anchor.getBlendShape(.mouthClose), forTargetNamed: "mouthClose")
        morpher.setWeight(anchor.getBlendShape(.eyeBlinkRight), forTargetNamed: "eyeBlinkRight")
        morpher.setWeight(anchor.getBlendShape(.eyeBlinkLeft), forTargetNamed: "eyeBlinkLeft")
        morpher.setWeight(anchor.getBlendShape(.jawForward), forTargetNamed: "jawForward")
        morpher.setWeight(anchor.getBlendShape(.mouthSmileLeft) * 2 - 0.7, forTargetNamed: "mouthSmileLeft")
        morpher.setWeight(anchor.getBlendShape(.mouthSmileRight) * 2 - 0.7, forTargetNamed: "mouthSmileRight")
        morpher.setWeight(anchor.getBlendShape(.mouthPucker) * 2, forTargetNamed: "mouthPucker")
    }
    
    override var info: Info {
        return Info(emoji: "👹", name: "Brand-man")
    }
}

