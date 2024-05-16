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
        heart1.image = UIImage(named: "ic_heart_fill")
        heart2.image = UIImage(named: "ic_heart_fill")
        heart3.image = UIImage(named: "ic_heart_fill")
        heart4.image = UIImage(named: "ic_heart_fill")
        heart5.image = UIImage(named: "ic_heart_fill")

        
        setupTitle()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateIcon),
                                               name: .updateIcon,
                                               object: nil)
    }
    
    @objc func updateIcon() {
        setupTitle()
    }
    
    private func setupTitle() {
        switch AppStorage.titleIcon {
        case 1:
            titleIconImageview.image = UIImage(named: "ic_title1")
        case 2:
            titleIconImageview.image = UIImage(named: "ic_title2")
        case 3:
            titleIconImageview.image = UIImage(named: "ic_title3")
        default:
            break
        }
    }
    
    func updateScore(with score: Int) {
        
    }
    
    func showEndGame() {
        let vc = EndGameViewController.instantiate()
        vc.score = AppStorage.scores
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    private func setupScene() {
        if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
            scene.scaleMode = .fill
            scene.gameDelegate = self
            skView.presentScene(scene)
        }
        
        skView.ignoresSiblingOrder = false
    }
}

extension GameViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "Game", bundle: nil)
}

extension GameViewController: GameDelegate {
    func gameOver() {
        showEndGame()
    }
    
    func updateScore() {
        scoreLabel.text = String(describing: AppStorage.scores)
    }
    
    func updateHeart(heart: Int) {
        heart1.image = UIImage(named: "ic_heart")
        heart2.image = UIImage(named: "ic_heart")
        heart3.image = UIImage(named: "ic_heart")
        heart4.image = UIImage(named: "ic_heart")
        heart5.image = UIImage(named: "ic_heart")
        switch heart {
        case 1:
            heart1.image = UIImage(named: "ic_heart_fill")
        case 2:
            heart1.image = UIImage(named: "ic_heart_fill")
            heart2.image = UIImage(named: "ic_heart_fill")
        case 3:
            heart1.image = UIImage(named: "ic_heart_fill")
            heart2.image = UIImage(named: "ic_heart_fill")
            heart3.image = UIImage(named: "ic_heart_fill")
        case 4:
            heart1.image = UIImage(named: "ic_heart_fill")
            heart2.image = UIImage(named: "ic_heart_fill")
            heart3.image = UIImage(named: "ic_heart_fill")
            heart4.image = UIImage(named: "ic_heart_fill")
        default:
            break
        }
    }
}
