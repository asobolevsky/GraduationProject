//
//  MoleculesScenario.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-23.
//

import ARKit

class MoleculesScenario: NSObject, SceneKitScenario {
    
    private let session: ARSession
    private let rootNode: SCNNode
    
    private var acetaldehydeNode: SCNNode?
    private var ammoniaNode: SCNNode?
    private var canCloneNodes = true
    
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
        if let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "Molecules", bundle: nil) {
            config.trackingImages = referenceImages
            config.maximumNumberOfTrackedImages = 8
        }
        session.run(config, options: [ .removeExistingAnchors, .resetTracking ])
    }
    
    func stopSession() {
        session.pause()
    }
    
}

// MARK: - ARSCNViewDelegate

extension MoleculesScenario: ARSCNViewDelegate {
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
    
    // is called for each image anchor separately
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        
        print("Is image tracked: \(imageAnchor.isTracked)")
        
        if let acetaldehyde = acetaldehydeNode, let ammonia = ammoniaNode {
            let distance = acetaldehyde.distance(to: ammonia)
            
            if distance <= 0.08 && canCloneNodes {
                canCloneNodes = false
                
                let acetaldehydeClone = acetaldehyde.clone()
                acetaldehydeClone.position =  acetaldehyde.presentation.worldPosition
                
                let ammoniaClone = ammonia.clone()
                ammoniaClone.position = ammonia.presentation.worldPosition
                
                acetaldehyde.isHidden = true
                ammonia.isHidden = true
                
                let container = SCNNode()
                container.name = "ContainerNode"
                let median = acetaldehydeClone.position.median(to: ammoniaClone.position)
                container.position = median
                container.addChildNode(acetaldehydeClone)
                container.addChildNode(ammoniaClone)
                
                acetaldehydeClone.position = rootNode.convertPosition(acetaldehydeClone.position, to: container)
                ammoniaClone.position = rootNode.convertPosition(ammoniaClone.position, to: container)
                
                rootNode.addChildNode(container)
                
                let rotateAction = SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 10)
                container.runAction(SCNAction.repeatForever(rotateAction))
            } else if distance > 0.08 && canCloneNodes == false {
                acetaldehyde.isHidden = false
                ammonia.isHidden = false
                
                if let containerNode = rootNode.childNode(withName: "ContainerNode", recursively: true) {
                    containerNode.removeFromParentNode()
                }
                
                canCloneNodes = true
            }
        }
    }
}
