//
//  SceneKitRootViewController.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-22.
//

import UIKit

class SceneKitRootViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if targetEnvironment(simulator)
        #error("ARKit is not supported in iOS Simulator. Connect a physical iOS device and select it as your Xcode run destination, or select Generic iOS Device as a build-only destination.")
        #endif
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let scenarioController = segue.destination as? SceneKitScenarioViewController,
            let configurator = sender as? SceneKitScenarioViewControllerConfigurator
        else {
            return
        }
        
        scenarioController.configurator = configurator
    }
    
    // MARK: - Actions
    
    @IBAction func showImageDetection(_ button: UIButton) {
        presentController(for: .imageDetection, title: button.titleLabel?.text)
    }
    
    @IBAction func showFaceTracking(_ button: UIButton) {
        presentController(for: .faceTracking, title: button.titleLabel?.text)
    }
    
    @IBAction func showPlaneDetection(_ button: UIButton) {
        presentController(for: .planeDetection, title: button.titleLabel?.text)
    }
    
    // MARK: - Private
    
    private func presentController(for scenarioType: SceneKitScenarioType, title: String?) {
        let configurator = SceneKitScenarioViewControllerConfigurator(title: title, scenarioType: scenarioType)
        performSegue(withIdentifier: .scenarioSegueID, sender: configurator)
    }
    
}

private extension String {
    static let scenarioSegueID = "PresentARScenario"
}
