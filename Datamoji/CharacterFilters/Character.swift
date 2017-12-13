//
//  Character.swift
//  ARFace
//
//  Created by Nate Parrott on 12/1/17.
//  Copyright © 2017 Nate Parrott. All rights reserved.
//

import Foundation
import SceneKit

class Character {
    init() {
        
    }
    
    var sceneName: String!
    var morpherName: String!
    var scale: Float = 1
    var selfieXRotation: Double = 0 // in degrees
    var arScale: Double = 1
    var arOffset = SCNVector3(0, 0, 0)
    
    enum Mode {
        case selfie
        case ar
    }
    
    func create(mode: Mode) -> (node: SCNNode, morpher: SCNMorpher) {
        let collada = SCNScene(named: sceneName, inDirectory: "characters.scnassets", options: nil)!
        
        let character = collada.rootNode.childNode(withName: "character", recursively: true)!
        let charScale = 0.2 * scale * character.scaleToNormalize
        character.scale = SCNVector3(charScale, charScale, charScale)
        
        let characterWrapper = SCNNode()
        characterWrapper.addChildNode(character)
        let height = characterWrapper.boundingBox.max.y - characterWrapper.boundingBox.min.y
        
        switch mode {
        case .selfie:
            character.position = SCNVector3(0, -height/2, 0)
            characterWrapper.rotation = SCNVector4(1, 0, 0, selfieXRotation / 180 * Double.pi)
            character.childNode(withName: "shadow", recursively: true)?.isHidden = true
        case .ar:
            character.position = SCNVector3(arOffset.x / Float(arScale), arOffset.y / Float(arScale), arOffset.z / Float(arScale))
            characterWrapper.scale = SCNVector3(arScale, arScale, arScale)
        }
        
        let morpher = character.childNode(withName: morpherName, recursively: true)!.morpher!
        morpher.unifiesNormals = true
        
        return (node: characterWrapper, morpher: morpher)
    }
}

class HqToiletCharacter : Character {
    override init() {
        super.init()
        sceneName = "hqtoilet2.scn"
        morpherName = "toilet"
        scale = 1.5
        selfieXRotation = 30
        arScale = 3
    }
}


class ToiletCharacter : Character {
    override init() {
        super.init()
        sceneName = "toilet3x.scn"
        morpherName = "lid"
        scale = 1.5
        selfieXRotation = 30
        arScale = 3
    }
}

class MonsterCharacter : Character {
    override init() {
        super.init()
        sceneName = "monster-adjusted.scn"
        morpherName = "Cube_001"
    }
}

class SkullCharacter : Character {
    override init() {
        super.init()
        sceneName = "skullboi-fixed.scn"
        morpherName = "head"
        arScale = 3
        arOffset = SCNVector3(0, 0.5, 0)
    }
}
