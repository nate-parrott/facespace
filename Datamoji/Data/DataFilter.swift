import Foundation
import ARKit
import SceneKit

class DataFilter : FaceFilter {
    var geometry: ARSCNFaceGeometry!
    var faceNode: SCNNode!
    var happinessText: SCNNode!
    var demographicText: SCNNode!
    var lastTextUpdate = Date.timeIntervalSinceReferenceDate + 5
    
    override func setup() {
        super.setup()
        geometry = ARSCNFaceGeometry(device: sceneView.device!)
        faceNode = SCNNode(geometry: geometry)
        geometry.firstMaterial!.fillMode = .lines
        geometry.firstMaterial!.diffuse.contents = UIColor(red: 1, green: 0.8, blue: 1, alpha: 0.9)
        anchorNode.addChildNode(faceNode)
        
        let headContent = SCNScene(named: "head.scn", inDirectory: "data.scnassets", options: nil)!.rootNode.childNode(withName: "head", recursively: true)!
        happinessText = headContent.childNode(withName: "happiness", recursively: true)!
        demographicText = headContent.childNode(withName: "demographic", recursively: true)!
        anchorNode.addChildNode(headContent)
    }
    
    override func update(anchor: ARFaceAnchor) {
        geometry.update(from: anchor.geometry)
        let smile = anchor.getBlendShape(.mouthSmileLeft) + anchor.getBlendShape(.mouthSmileRight)
        let frown = anchor.getBlendShape(.mouthFrownLeft) + anchor.getBlendShape(.mouthFrownRight)
        let happiness = smile - frown
        // frown: <0; happy: 1
        let happinessScaled = Int((happiness - 0.5) * 2 * 100)
        if (Date.timeIntervalSinceReferenceDate - lastTextUpdate) > 0.1 {
            lastTextUpdate = Date.timeIntervalSinceReferenceDate
            (happinessText.geometry! as! SCNText).string = "HAPPINESS:\n\(happinessScaled)"
            // print("Hp: \(happiness)")
            let possibleDemographicStrings: [String] = ["MALE\n27", "TRACKING\nERROR", "MALE\n22", "MALE\n24", "MALE\n26", "MALE\n23"]
            (demographicText.geometry as! SCNText).string = possibleDemographicStrings[Int(arc4random() % UInt32(possibleDemographicStrings.count))]
        }
    }
    
    override func configureCamera(_ camera: SCNCamera) {
        super.configureCamera(camera)
        DispatchQueue.main.async {
            camera.colorGrading.contents = UIImage(named: "data_color_grading.png")!
        }
    }
    
    override class var info: Info {
        return Info(emoji: "🔢", name: "Data")
    }
}

