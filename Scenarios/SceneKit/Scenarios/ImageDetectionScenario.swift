//
//  ImageDetectionScenario.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-23.
//

import ARKit

class ImageDetectionScenario: SceneKitScenario {
    
    private let session: ARSession
    
    required init(with session: ARSession) {
        self.session = session
    }
    
    // MARK: - Session
    
    func startSession() {
        let config = ARImageTrackingConfiguration()
        session.run(config, options: [ .removeExistingAnchors, .resetTracking ])
    }
    
    func stopSession() {
        session.pause()
    }
    
}
