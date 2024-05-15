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
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart4: UIImageView!
    @IBOutlet weak var heart5: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var titleIconImageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
    }
    
    private func setupView() {
        topView.applyGradient(colors: [AppColors.ABE87A, AppColors._16713D])
    }
    
    func updateScore(with score: Int) {
        
    }
    
    func showEndGame() {
        let vc = EndGameViewController.instantiate()
        vc.score = 10
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    private func setupScene() {
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .fill
            
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
