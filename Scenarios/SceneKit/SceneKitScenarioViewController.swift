//
//  SceneKitScenarioViewController.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-22.
//

import ARKit

enum SceneKitScenarioType {
    case imageDetection
    case faceTracking
    case planeDetection
}

struct SceneKitScenarioViewControllerConfigurator {
    let title: String?
    let scenarioType: SceneKitScenarioType
}

class SceneKitScenarioViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var statusLabel: UILabel!
    
    var configurator: SceneKitScenarioViewControllerConfigurator?
    private var scenario: SceneKitScenario?
    private var statusMessage: String? {
        didSet {
            updateStatusLabel()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scenario?.startSession()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        scenario?.stopSession()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Configuration
    
    private func setup() {
        guard let configurator = configurator else {
            return
        }
        
        title = configurator.title
        
        scenario = createScenario(for: configurator.scenarioType, session: sceneView.session)
        setupScene()
    }
    
    private func createScenario(for type: SceneKitScenarioType, session: ARSession) -> SceneKitScenario {
        switch type {
        case .faceTracking:     return MoleculesScenario(with: session, rootNode: sceneView.scene.rootNode)
        case .imageDetection:   return MoleculesScenario(with: session, rootNode: sceneView.scene.rootNode)
        case .planeDetection:   return TowerDefenceScenario(with: session, rootNode: sceneView.scene.rootNode)
        }
    }
    
    private func setupScene() {
        sceneView.showsStatistics = true
        sceneView.delegate = scenario
        sceneView.scene.physicsWorld.contactDelegate = scenario
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [ .showPhysicsShapes ]
        
//        setupTest()
    }
    
    private func setupTest() {
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.systemRed
//        material.metalness.intensity = 2
//
//        let geometry = SCNSphere(radius: 0.2)
//        geometry.firstMaterial = material
//
//        let node = SCNNode(geometry: geometry)
//        node.position = SCNVector3(0, 0, -1)
//
//        let physicsShape = SCNPhysicsShape(geometry: geometry, options: nil)
//        let physicsBody = SCNPhysicsBody(type: .kinematic, shape: physicsShape)
//        physicsBody.isAffectedByGravity = false
//        node.physicsBody = physicsBody
        
        let node = MobNode()
        node.position = SCNVector3(0, 0, -2)
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    private func updateStatusLabel() {
        DispatchQueue.main.async {
            self.statusLabel.text = self.statusMessage
        }
    }
    
}
