import Foundation
import SceneKit
import ARKit

class BigSpenderFilter : FaceFilter {
    var geometry: ARSCNFaceGeometry!
    var glassesNode: SCNNode!
    let glassesFallDistance: Float = 0.1
    
    override func setup() {
        super.setup()
        geometry = ARSCNFaceGeometry(device: sceneView.device!, fillMesh: false)
        let node = SCNNode(geometry: geometry)
        geometry.firstMaterial!.colorBufferWriteMask = []
        node.renderingOrder = -1
        anchorNode.addChildNode(node)
        
        let glasses = SCNScene(named: "glasses.scn", inDirectory: "bigspender.scnassets", options:nil)!.rootNode.childNode(withName: "glasses", recursively: true)!
        glasses.centerAndNormalize(scale: 0.155)
        glassesNode = glasses
        glassesNode.position.y += glassesFallDistance
        glassesNode.opacity = 0.01
        let glassesContainer = SCNNode()
        glassesContainer.addChildNode(glasses)
        glassesContainer.position = SCNVector3(0, 0.02, 0.014)
        
        anchorNode.addChildNode(glassesContainer)
        
        // create particle system:
        // let mouthNode = SCNNode(geometry: SCNSphere(radius: 0.01))
        let particleSystem = SCNScene(named: "cash.scn", inDirectory: "bigspender.scnassets", options: nil)!.rootNode.childNode(withName: "cash", recursively: true)!
        // particleSystem.addChildNode(mouthNode)
        anchorNode.addChildNode(particleSystem)
        particleSystem.position = SCNVector3(0, -0.05, 0)
        self.particleSystem = particleSystem.particleSystems!.first!
        self.particleSystem.birthRate = 0
    }
    var particleSystem: SCNParticleSystem!
    
    override func update(anchor: ARFaceAnchor) {
        super.update(anchor: anchor)
        geometry.update(from: anchor.geometry)
        let emissionStart: Float = 0.05
        let emissionEnd: Float = 0.12
        let close: Float = anchor.blendShapes[.mouthClose]!.floatValue
        let emissionAmount = min(1, max(0, (close - emissionStart) / (emissionEnd - emissionStart)))
        self.particleSystem.birthRate = CGFloat(emissionAmount) * 300
    }
    
    override func show() {
        super.show()
        SCNTransaction.animationDuration = 0.3
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        glassesNode.position.y -= glassesFallDistance
        glassesNode.opacity = 1
    }
    
    override var info: Info {
        return Info(emoji: "🤑", name: "Big Spender")
    }
}

