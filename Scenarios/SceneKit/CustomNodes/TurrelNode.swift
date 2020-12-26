//
//  TurrelNode.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-25.
//

import SceneKit

class TurrelNode: SCNNode {
    
    private var bulletSpawnLocations: [SCNVector3] = []
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let barrelGeometry = SCNCylinder(radius: 0.01, height: 0.1)
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
        
        bulletSpawnLocations = [leftBarrelSpawnLocation, rightBarrelSpawnLocation]
        
        let bullet = SCNSphere(radius: 0.005)
        bullet.firstMaterial?.diffuse.contents = UIColor.systemRed
        let bulletNode = SCNNode(geometry: bullet)
        bulletNode.position = leftBarrelSpawnLocation
        addChildNode(bulletNode)
        
        let bulletCopy = bulletNode.clone()
        bulletNode.position = rightBarrelSpawnLocation
        addChildNode(bulletCopy)
        
        pivot = SCNMatrix4MakeTranslation(0, yOffset / 2, 0)
    }
    
}
