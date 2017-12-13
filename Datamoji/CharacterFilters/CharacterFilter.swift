import Foundation
import ARKit
import SceneKit

class CharacterFilter : FaceFilter {
    
    var morpher: SCNMorpher!
    
    override func setup() {
        super.setup()
        let (node, morpher) = getCharacter().create(mode: .selfie)
        anchorNode.addChildNode(node)
        self.morpher = morpher
    }
    
    override func update(anchor: ARFaceAnchor) {
        super.update(anchor: anchor)
        morpher.applyBlendShapes(anchor.blendShapes)
    }
    
    func getCharacter() -> Character! {
        return nil
    }
}

class SkullFilter : CharacterFilter {
    override func getCharacter() -> Character! {
        return SkullCharacter()
    }
}

class ToiletFilter : CharacterFilter {
    override func getCharacter() -> Character! {
        return HqToiletCharacter()
    }
}
