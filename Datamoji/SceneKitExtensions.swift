//
//  SceneKitExtensions.swift
//  Datamoji
//
//  Created by Nate Parrott on 12/12/17.
//  Copyright © 2017 Nate Parrott. All rights reserved.
//

import SceneKit
import ARKit

extension ARFaceAnchor {
    func getBlendShape(_ loc: ARFaceAnchor.BlendShapeLocation) -> CGFloat {
        return CGFloat(blendShapes[loc]?.floatValue ?? 0)
    }
}

extension SCNMaterial {
    func configureAsBubble(color: UIColor) {
        lightingModel = .physicallyBased
        metalness.contents = 0.2
        roughness.contents = 0
        diffuse.contents = color
        transparency = 0.33
        isDoubleSided = false
    }
}

extension Float {
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
}

extension SCNNode {
    func centerAndNormalize(scale: Float) {
        let bbox = boundingBox
        let cx = (bbox.max.x + bbox.min.x)/2
        let cy = (bbox.max.y + bbox.min.y)/2
        let cz = (bbox.max.z + bbox.min.z)/2
        let realScale = 1.0 / max(bbox.max.x - bbox.min.x, bbox.max.y - bbox.min.y, bbox.max.z - bbox.min.z) * scale
        self.scale = SCNVector3(realScale, realScale, realScale)
        position = SCNVector3(-cx * realScale, -cy * realScale, -cz * realScale)
    }
}

