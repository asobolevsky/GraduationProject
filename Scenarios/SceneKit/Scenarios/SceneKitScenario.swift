//
//  SceneKitScenario.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-23.
//

import ARKit

protocol SceneKitScenario: ARSCNViewDelegate, SCNPhysicsContactDelegate {
    init(with session: ARSession, rootNode: SCNNode)
    
    func startSession()
    func stopSession()
}
