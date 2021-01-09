//
//  TowerDefenceScenario.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-25.
//

import ARKit

enum TowerDefenceRefImage: String {
    init?(refImageName: String) {
        let caseName = refImageName
            .split(separator: "_")
            .map { String($0).capitalized }
            .joined()
            .uncapitalized()
        
        guard let caseItem = TowerDefenceRefImage(rawValue: caseName) else {
            return nil
        }
        
        self = caseItem
    }
    
    case mobBase
    case towerBase
    
    var imageName: String {
        return rawValue
            .splitBefore(separator: { $0.isUppercase })
            .map { String($0).lowercased() }
            .joined(separator: "_")
    }
}

class TowerDefenceScenario: NSObject, SceneKitScenario {
    
    private let session: ARSession
    private let rootNode: SCNNode
    
    private var mobSpawnTimer: Timer?
    private var spawnMobs: [SCNNode] = []
    private let mobSpeed: Float = 0.1
    private var mobMoveDirection = SCNVector3(0, 0, 1)
    private var lastUpdateTime: TimeInterval = 0
    private var updateTimeDelta: TimeInterval = 0
    
    required init(with session: ARSession, rootNode: SCNNode) {
        self.session = session
        self.rootNode = rootNode
    }
    
    // MARK: - SceneKitScenario
    
    func startSession() {
        guard ARImageTrackingConfiguration.isSupported else {
            return
        }
        
        let config = ARImageTrackingConfiguration()
        if let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "TowerDefence", bundle: nil) {
            config.trackingImages = referenceImages
            config.maximumNumberOfTrackedImages = 8
        }
        session.run(config, options: [ .removeExistingAnchors, .resetTracking ])
    }
    
    func stopSession() {
        session.pause()
    }
    
    // MARK: - Models
    
    private func startSpawningMobs(within parentNode: SCNNode) {
        mobSpawnTimer?.invalidate()
        
        mobSpawnTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [unowned self] _ in
            let mobNode = self.spawnMob()
            parentNode.addChildNode(mobNode)
            spawnMobs.append(mobNode)
        })
        mobSpawnTimer?.fire()
    }
    
    private func spawnMob(at position: SCNVector3 = SCNVector3()) -> SCNNode {
        let mobNode = MobNode()
        mobNode.position = position
        return mobNode
    }
    
    private func moveSpawnMobs(_ mobs: [SCNNode], by delta: SCNVector3, duration: TimeInterval) {
        mobs.forEach { mob in
            let distance = (mobMoveDirection - mob.position) * Float(duration / 60)
            let moveAction = SCNAction.move(by: distance, duration: duration)
            mob.runAction(moveAction)
        }
    }
    
    private func createTower(withing parentNode: SCNNode) {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemGray
        material.metalness.intensity = 2
        
        let geometry = SCNCylinder(radius: 0.02, height: 0.06)
        geometry.firstMaterial = material
        
        let towerNode = SCNNode(geometry: geometry)
        parentNode.addChildNode(towerNode)
    }
    
    private func createTurrel(withing parentNode: SCNNode) {
        let turrelNode = TurrelNode()
        turrelNode.startFire(at: SCNVector3())
        parentNode.addChildNode(turrelNode)
    }
    
//    private func setupPlane(with anchor: ARPlaneAnchor) -> SCNNode {
//        let geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
//
//        let material = SCNMaterial()
//        material.diffuse.contents = "art.scnassets/plane_grid.png"
//        material.diffuse.wrapS = .repeat
//        material.diffuse.wrapT = .repeat
//
//        let scaleX = (Float(geometry.width) / 0.1).rounded()
//        let scaleY = (Float(geometry.height) / 0.1).rounded()
//        //we then apply the scaling
//        material.diffuse.contentsTransform = SCNMatrix4MakeScale(scaleX, scaleY, 0)
//
//        geometry.firstMaterial = material
//
//        let planeNode = SCNNode(geometry: geometry)
//        planeNode.simdPosition = anchor.center
//        planeNode.eulerAngles.x = -.pi / 2
//        return planeNode
//    }
}

// MARK: - ARSCNViewDelegate

extension TowerDefenceScenario: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if spawnMobs.count > 0 {
            let moveDelta = mobMoveDirection * mobSpeed * Float(updateTimeDelta)
            moveSpawnMobs(spawnMobs, by: moveDelta, duration: updateTimeDelta)
        }
        
        updateTimeDelta = time - lastUpdateTime
        lastUpdateTime = time
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard
            let imageAnchor = anchor as? ARImageAnchor,
            let refImageName = imageAnchor.referenceImage.name,
            let refImage = TowerDefenceRefImage(refImageName: refImageName)
        else {
            return
        }
        
        switch refImage {
        case .mobBase: startSpawningMobs(within: node)
//        case .towerBase: createTower(withing: node)
        case .towerBase: createTurrel(withing: node)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard
            let imageAnchor = anchor as? ARImageAnchor,
            let refImageName = imageAnchor.referenceImage.name,
            let refImage = TowerDefenceRefImage(refImageName: refImageName)
        else {
            return
        }
        
        switch refImage {
        case .towerBase: break
//            mobMoveDirection = node.presentation.position;
            
        default: break
        }
    }
}

// MARK: - SCNPhysicsContactDelegate

extension TowerDefenceScenario: SCNPhysicsContactDelegate {
    private func isContact(_ contact: SCNPhysicsContact,
                           between categoryA: CollisionCategory,
                           and categoryB: CollisionCategory) -> Bool {
        return (contact.nodeA.physicsBody?.categoryBitMask == categoryA.rawValue &&
                    contact.nodeB.physicsBody?.categoryBitMask == categoryB.rawValue) ||
            (contact.nodeB.physicsBody?.categoryBitMask == categoryA.rawValue &&
                contact.nodeA.physicsBody?.categoryBitMask == categoryB.rawValue)
    }
    
    private func node(with category: CollisionCategory, in contact: SCNPhysicsContact) -> SCNNode? {
        if contact.nodeA.physicsBody?.categoryBitMask == category.rawValue {
            return contact.nodeA
        }
        
        if contact.nodeB.physicsBody?.categoryBitMask == category.rawValue {
            return contact.nodeB
        }
        
        return nil
    }
 
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if isContact(contact, between: .turrelProjectile, and: .mob) {
            
            contact.nodeA.removeFromParentNode()
            contact.nodeB.removeFromParentNode()
        }
    }
}
