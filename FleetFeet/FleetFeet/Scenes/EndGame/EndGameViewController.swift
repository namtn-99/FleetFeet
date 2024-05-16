//
//  EndGameViewController.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/15/24.
//

import UIKit

final class EndGameViewController: UIViewController {
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var scoresLabel: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
          blurView.topAnchor.constraint(equalTo: view.topAnchor),
          blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
          blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        scoresLabel.text = String(describing: score)
        replayButton.applyGradient(colors: [AppColors._29CAFF, AppColors._015AC8])
        menuButton.applyGradient(colors: [AppColors._29CAFF, AppColors._015AC8])
        scoreView.applyGradient(colors: [AppColors.ABE87A, AppColors._16713D])
    }

    @IBAction func handleReplayButton(_ sender: Any) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        
        NotificationCenter.default.post(name: .replay, object: nil)
        dismiss(animated: true)
    }
    
    
    @IBAction func handleMenuButton(_ sender: Any) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        
        let nav = UINavigationController(rootViewController: MainViewController.instantiate())
        Utils.swapRootViewController(nav)
    }
}

extension EndGameViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "EndGame", bundle: nil)
}
