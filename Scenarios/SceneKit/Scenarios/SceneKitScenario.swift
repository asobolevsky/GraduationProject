//
//  SceneKitScenario.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-23.
//

import ARKit

protocol SceneKitScenario {
    init(with session: ARSession)
    
    func startSession()
    func stopSession()
}
