//
//  ViewController.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/9/24.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var factsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        navigationController?.navigationBar.isHidden = true
        topView.applyGradient(colors: [AppColors.ABE87A, AppColors._16713D])
        setupTitle()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateIcon),
                                               name: .updateIcon,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clear),
                                               name: .clear,
                                               object: nil)
        factsLabel.text = "FACTS: \(String(describing: AppStorage.factsUnlock))"
        
        if AppStorage.scores > 1345 {
            highScoreLabel.text = "HIGH SCORES: \(String(describing: AppStorage.scores))"
        } else {
            highScoreLabel.text = "HIGH SCORES: 1345"
        }
    }
    
    @objc func clear() {
        factsLabel.text = "FACTS: \(String(describing: AppStorage.factsUnlock))"
        if AppStorage.scores > 1345 {
            highScoreLabel.text = "HIGH SCORES: \(String(describing: AppStorage.scores))"
        } else {
            highScoreLabel.text = "HIGH SCORES: 1345"
        }
        setupTitle()
    }
    
    @objc func updateIcon() {
        setupTitle()
    }
    
    private func setupTitle() {
        switch AppStorage.titleIcon {
        case 1:
            iconImageView.image = UIImage(named: "ic_title1")
        case 2:
            iconImageView.image = UIImage(named: "ic_title2")
        case 3:
            iconImageView.image = UIImage(named: "ic_title3")
        default:
            break
        }
    }
    
    @IBAction func handleMenuButton(_ sender: UIButton) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        
        switch sender.tag {
        case 0:
            let vc = GameViewController.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = GuideViewController.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = ChallengesViewController.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = OptionsViewController.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
            
        }
    }
    
    
}

extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
}
