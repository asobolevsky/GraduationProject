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
        case .faceTracking:     return ImageDetectionScenario(with: session, rootNode: sceneView.scene.rootNode)
        case .imageDetection:   return ImageDetectionScenario(with: session, rootNode: sceneView.scene.rootNode)
        case .planeDetection:   return ImageDetectionScenario(with: session, rootNode: sceneView.scene.rootNode)
        }
    }
    
    private func setupScene() {
        sceneView.showsStatistics = true
        sceneView.delegate = scenario
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
    }
    
    private func updateStatusLabel() {
        DispatchQueue.main.async {
            self.statusLabel.text = self.statusMessage
        }
    }
    
}
