//
//  TurrelNode.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-25.
//

import SceneKit

class TurrelNode: SCNNode {
    
    private var fireSpeed: TimeInterval = 0.3
    private let barrelSize: CGFloat = 0.1
    private var barrels: [SCNNode] = []
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func startFire(at direction: SCNVector3) {
        let coolDownAction = SCNAction.wait(duration: fireSpeed)
        barrels.enumerated().forEach { pair in
            let isEven = (pair.offset % 2 == 0)
            var sequenceOfActions: [SCNAction] = []
            
            if isEven == false {
                sequenceOfActions.append(coolDownAction)
            }
            
            let barrelRecoil = SCNAction.move(by: SCNVector3(-barrelSize / 2, 0, 0), duration: 0.1)
            sequenceOfActions.append(barrelRecoil)
            let projectileLaunch = SCNAction.run { [unowned self] node in
                self.launchProjectile(from: node)
            }
            sequenceOfActions.append(projectileLaunch)
            sequenceOfActions.append(barrelRecoil.reversed())
            
            if isEven {
                sequenceOfActions.append(coolDownAction)
            }
            
            let sequenceAction = SCNAction.sequence(sequenceOfActions)
            let repeatAction = SCNAction.repeatForever(sequenceAction)
            pair.element.runAction(repeatAction, forKey: .fireAnimationKey)
        }
    }
    
    func ceaseFire() {
        barrels.forEach { $0.removeAction(forKey: .fireAnimationKey) }
    }
    
    private func launchProjectile(from barrel: SCNNode) {
        let nodeScale: Float = 0.1
        let bullet = SCNSphere(radius: 0.005)
        bullet.firstMaterial?.diffuse.contents = UIColor.systemRed
        let bulletNode = SCNNode(geometry: bullet)
        bulletNode.position = barrel.convertPosition(bulletNode.position, to: self)
        addChildNode(bulletNode)
        
        let bulletPhysicslShape = SCNPhysicsShape(geometry: bullet, options: nil)
        let bulletPhysicsBody = SCNPhysicsBody(type: .kinematic, shape: bulletPhysicslShape)
        bulletPhysicsBody.isAffectedByGravity = false
        bulletNode.physicsBody = bulletPhysicsBody
        
        let launchAction = SCNAction.move(by: SCNVector3(0.3, 0, 0), duration: 1)
        let reapeatAction = SCNAction.repeatForever(launchAction)
        bulletNode.runAction(reapeatAction)
        
        scale = SCNVector3(SIMD3<Float>(repeating: nodeScale))
    }
    
    private func setup() {
        var yOffset: Float = 0
        
        // Base
        let baseGeometry = SCNCylinder(radius: 0.15, height: 0.02)
        yOffset += Float(baseGeometry.height / 2)
        baseGeometry.firstMaterial?.diffuse.contents = UIColor.systemRed
        let baseNode = SCNNode(geometry: baseGeometry)
        baseNode.position += SCNVector3(0, yOffset, 0)
        yOffset += Float(baseGeometry.height / 2)
        addChildNode(baseNode)
        
        // Leg
        let legFeometry = SCNCylinder(radius: 0.03, height: 0.1)
        yOffset += Float(legFeometry.height / 2)
        legFeometry.firstMaterial?.diffuse.contents = UIColor.systemGray
        let legNode = SCNNode(geometry: legFeometry)
        legNode.position += SCNVector3(0, yOffset, 0)
        yOffset += Float(legFeometry.height / 2)
        addChildNode(legNode)
        
        // Tower
        let towerFeometry = SCNBox(width: 0.2, height: 0.08, length: 0.2, chamferRadius: 0)
        yOffset += Float(towerFeometry.height / 2)
        towerFeometry.firstMaterial?.diffuse.contents = UIColor.systemPink
        let towerNode = SCNNode(geometry: towerFeometry)
        towerNode.position += SCNVector3(0, yOffset, 0)
        yOffset += Float(towerFeometry.height / 2)
        addChildNode(towerNode)
        
        // Barrels
        var xBarrelOffset = Float(towerFeometry.width / 2)
        let barrelGeometry = SCNCylinder(radius: 0.01, height: barrelSize)
        xBarrelOffset += Float(barrelGeometry.height / 2)
        barrelGeometry.firstMaterial?.diffuse.contents = UIColor.systemGray3
        
        let leftBarrelNode = SCNNode(geometry: barrelGeometry)
        leftBarrelNode.eulerAngles = SCNVector3(0, 0, -Float.pi / 2)
        leftBarrelNode.position += SCNVector3(xBarrelOffset, 0, -Float(towerFeometry.length / 4))
        towerNode.addChildNode(leftBarrelNode)
        
        let rightBarrelNode = leftBarrelNode.clone()
        leftBarrelNode.position += SCNVector3(0, 0, Float(towerFeometry.length / 2))
        towerNode.addChildNode(rightBarrelNode)
        
        var leftBarrelSpawnLocation = SCNVector3(0, Float(barrelGeometry.height / 2), 0)
        leftBarrelSpawnLocation = leftBarrelNode.convertPosition(leftBarrelSpawnLocation, to: self)
        
        var rightBarrelSpawnLocation = SCNVector3(0, Float(barrelGeometry.height / 2), 0)
        rightBarrelSpawnLocation = rightBarrelNode.convertPosition(rightBarrelSpawnLocation, to: self)
        
        barrels = [leftBarrelNode, rightBarrelNode]
        pivot = SCNMatrix4MakeTranslation(0, yOffset / 2, 0)
    }
    
}

private extension String {
    static let fireAnimationKey = "Fire"
}
