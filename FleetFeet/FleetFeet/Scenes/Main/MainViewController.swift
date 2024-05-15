//
//  ViewController.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/9/24.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        navigationController?.navigationBar.isHidden = true
        topView.applyGradient(colors: [AppColors.ABE87A, AppColors._16713D])
    }
    
    @IBAction func handleMenuButton(_ sender: UIButton) {
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
