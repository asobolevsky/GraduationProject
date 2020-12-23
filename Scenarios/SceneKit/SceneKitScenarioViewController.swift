//
//  SceneKitScenarioViewController.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-22.
//

import UIKit

enum ARScenario {
    case imageDetection
    case faceTracking
    case planeDetection
}

struct SceneKitScenarioViewControllerConfigurator {
    let title: String?
    let scenario: ARScenario
}

class SceneKitScenarioViewController: UIViewController {
    
    var configurator: SceneKitScenarioViewControllerConfigurator?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Private
    
    private func configureView() {
        guard let configurator = configurator else {
            return
        }
        
        title = configurator.title
    }
    
}
