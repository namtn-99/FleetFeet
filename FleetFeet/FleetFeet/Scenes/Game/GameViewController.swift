//
//  GameViewController.swift
//  FleetFeet
//
//  Created by NamTrinh on 11/05/2024.
//

import UIKit
import SpriteKit

final class GameViewController: UIViewController {
    @IBOutlet weak var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }
    
    private func setupScene() {
        if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .fill
            
            // Present the scene
            skView.presentScene(scene)
        }
        
        skView.ignoresSiblingOrder = false
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
}

extension GameViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "Game", bundle: nil)
}
