//
//  ImageDetectionScenario.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-23.
//

import ARKit

class ImageDetectionScenario: NSObject, SceneKitScenario {
    
    private let session: ARSession
    private let rootNode: SCNNode
    
    private var acetaldehydeNode: SCNNode?
    private var ammoniaNode: SCNNode?
    private var canCloneNodes = true
    
    required init(with session: ARSession, rootNode: SCNNode) {
        self.session = session
        self.rootNode = rootNode
    }
    
    // MARK: - Session
    
    func startSession() {
        let config = ARImageTrackingConfiguration()
        if let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "SceneKitElements", bundle: nil) {
            config.trackingImages = referenceImages
            config.maximumNumberOfTrackedImages = 8
        }
        session.run(config, options: [ .removeExistingAnchors, .resetTracking ])
    }
    
    func stopSession() {
        session.pause()
    }
    
}

extension ImageDetectionScenario: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        
        guard [ "acetaldehyde", "ammonia" ].contains(imageAnchor.referenceImage.name ?? "") else {
            return
        }
        
        let material = SCNMaterial()
        material.metalness.intensity = 2.0
        
        let geometry = SCNSphere(radius: 0.1)
        geometry.firstMaterial = material
        
        let sphereNode = SCNNode(geometry: geometry)
        let scale: CGFloat = 0.2
        sphereNode.scale = SCNVector3(scale, scale, scale)
        
        if let refImageName = imageAnchor.referenceImage.name {
            switch refImageName {
            case "acetaldehyde":
                material.diffuse.contents = UIColor.systemRed
                acetaldehydeNode = sphereNode
                
            case "ammonia":
                material.diffuse.contents = UIColor.systemBlue
                ammoniaNode = sphereNode
                
            default: break
            }
        }
        
        print("Did add node for refImage named: \(imageAnchor.referenceImage.name)")
        node.addChildNode(sphereNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else {
            return
        }
        
        if canCloneNodes,  let acetaldehyde = acetaldehydeNode, let ammonia = ammoniaNode {
            let distance = acetaldehyde.distance(to: ammonia)
            
            print(distance)
            if distance < 0.08 {
                canCloneNodes = false
                
                let acetaldehydeClone = acetaldehyde.clone()
                acetaldehydeClone.position =  acetaldehyde.presentation.worldPosition
                
                let ammoniaClone = ammonia.clone()
                ammoniaClone.position = ammonia.presentation.worldPosition
                
                acetaldehyde.isHidden = true
                ammonia.isHidden = true
                
                let container = SCNNode()
                container.addChildNode(acetaldehydeClone)
                container.addChildNode(ammoniaClone)
                
                rootNode.addChildNode(container)
                
                let rotateAction = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 10)
                container.runAction(SCNAction.repeatForever(rotateAction))
                
                print(acetaldehydeClone.position)
            }
        }
    }
}
