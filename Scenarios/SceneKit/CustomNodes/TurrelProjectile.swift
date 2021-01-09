//
//  TurrelProjectile.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-26.
//

import SceneKit

class TurrelProjectile: SCNNode {
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let bulletGeometry = SCNSphere(radius: 0.005)
        bulletGeometry.firstMaterial?.diffuse.contents = UIColor.systemRed
        geometry = bulletGeometry
        
        
        let physicsShapeScale = SCNVector3(SIMD3<Float>(repeating: 0.1))
        let bulletPhysicslShape = SCNPhysicsShape(geometry: bulletGeometry, options: [
            SCNPhysicsShape.Option.scale: physicsShapeScale
        ])
        let bulletPhysicsBody = SCNPhysicsBody(type: .kinematic, shape: bulletPhysicslShape)
        bulletPhysicsBody.isAffectedByGravity = false
        bulletPhysicsBody.categoryBitMask = CollisionCategory.turrelProjectile.rawValue
        physicsBody = bulletPhysicsBody
    }
    
}
