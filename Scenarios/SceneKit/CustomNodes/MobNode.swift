//
//  MobNode.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-26.
//

import SceneKit

class MobNode: SCNNode {
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let mobNode = loadMobNode()
        let animation = loadAnimation()
        mobNode.addAnimation(animation, forKey: .animationKey)
        
        let scale: Float = 0.003
        mobNode.scale = SCNVector3(SIMD3<Float>(repeating: scale))
        
        let physicsGeometry = SCNBox(boundingBox: mobNode.boundingBox)
        let mobBoxShape = SCNPhysicsShape(geometry: physicsGeometry, options: [
            SCNPhysicsShape.Option.scale: mobNode.scale,
            SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox
        ])
        
        let width = mobNode.boundingBox.max.x - mobNode.boundingBox.min.x
        let translate = SCNMatrix4MakeTranslation(-(width * scale) / 2, 0, 0)
        let rotate = SCNMatrix4MakeRotation(-.pi / 2, 0, 0, 1)
        let resultMatrix = SCNMatrix4Mult(translate, rotate)
        let translateMatrix = NSValue(scnMatrix4: resultMatrix)
        let mobPhysicsShape = SCNPhysicsShape(shapes: [mobBoxShape], transforms: [translateMatrix])
        
        let mobPhysicsBody = SCNPhysicsBody(type: .kinematic, shape: mobPhysicsShape)
        mobPhysicsBody.categoryBitMask = CollisionCategory.mob.rawValue
        mobPhysicsBody.contactTestBitMask = CollisionCategory.turrelProjectile.rawValue
        mobNode.physicsBody = mobPhysicsBody
        
        addChildNode(mobNode)
    }
    
    private func loadSceneSource(daeNamed: String) -> SCNSceneSource {
        guard
            let collada = Bundle.main.url(forResource: "\(String.resourcesDir)/\(daeNamed)", withExtension: "dae"),
            let sceneSource = SCNSceneSource(url: collada, options: nil)
        else {
            fatalError("Could not load file: \(daeNamed)")
        }
        
        return sceneSource
    }
    
    private func loadMobNode() -> SCNNode {
        let sceneSource = loadSceneSource(daeNamed: .mobNodeDaeName)
        guard
            let mobNode = sceneSource.entryWithIdentifier(.mobNodeIdentifier, withClass: SCNNode.self),
            let sceleton = sceneSource.entryWithIdentifier(.mobSceletonNodeIdentifier, withClass: SCNNode.self)
        else {
            fatalError("Could not load nodes")
        }
        
        sceleton.removeAllActions()
        mobNode.addChildNode(sceleton)
        mobNode.position = SCNVector3()
        return mobNode
    }
    
    private func loadAnimation() -> CAAnimation {
        let sceneSource = loadSceneSource(daeNamed: .mobNodeAnimationDaeName)
        guard
            let animation = sceneSource.entryWithIdentifier(.mobNodeAnimationIdentifier, withClass: CAAnimation.self)
        else {
            fatalError("Could not load animation")
        }
        
        return animation
    }
}


private extension String {
    static let resourcesDir = "art.scnassets"
    
    static let mobNodeDaeName = "lopolydudeMirrorRiggedExport"
    static let mobNodeAnimationDaeName = "lopolydudeMirrorRiggedWalk"
    
    static let mobNodeIdentifier = "Dude"
    static let mobSceletonNodeIdentifier = "Armature"
    static let mobNodeAnimationIdentifier = "\(String.mobNodeAnimationDaeName)-1"
    
    static let animationKey = "walking"
}
