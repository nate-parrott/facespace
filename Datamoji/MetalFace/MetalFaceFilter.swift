import Foundation
import ARKit
import SceneKit

class MetalFaceFilter : FaceFilter {
    var geometry: ARSCNFaceGeometry!
    
    override func setup() {
        super.setup()
        geometry = ARSCNFaceGeometry(device: sceneView.device!)
        let faceNode = SCNNode(geometry: geometry)
        geometry.firstMaterial!.lightingModel = .physicallyBased
        geometry.firstMaterial!.metalness.contents = 1
        geometry.firstMaterial!.roughness.contents = 0.1
        // geometry.firstMaterial!.normal.contents = UIImage(named: "rock-normal.jpg")!
        geometry.firstMaterial!.normal.contentsTransform = SCNMatrix4MakeScale(0.5, 0.5, 0.5)
        anchorNode.addChildNode(faceNode)
    }
    
    override func update(anchor: ARFaceAnchor) {
        geometry.update(from: anchor.geometry)
        let t = Float(anchor.getBlendShape(.jawOpen)) / 2
        geometry.firstMaterial!.normal.contentsTransform = SCNMatrix4MakeScale(t, t, t)
    }
    
    override class var info: Info {
        return Info(emoji: "👽", name: "Metal")
    }
    
    override var lightingEnvironment: Any? {
        return UIImage(named: "scarybg-bright.jpg")!
    }
    
    override var sceneBackground: Any? {
        return UIImage(named: "scarybg.jpg")!
    }
}


