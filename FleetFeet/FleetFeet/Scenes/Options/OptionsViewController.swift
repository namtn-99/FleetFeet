//
//  OptionsViewController.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/9/24.
//

import UIKit

final class OptionsViewController: UIViewController {

    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var icon1Button: UIButton!
    @IBOutlet weak var icon2Button: UIButton!
    @IBOutlet weak var icon3Button: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var clearDataButton: UIButton!
    @IBOutlet weak var musicStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        clearDataButton.applyGradient(colors: [AppColors.ABE87A, AppColors._16713D])
        shareButton.applyGradient(colors: [AppColors.ABE87A, AppColors._16713D])
    }

    @IBAction func handleIconButton(_ sender: UIButton) {
    }
    
    @IBAction func handleShareButton(_ sender: Any) {
    }
    
    @IBAction func handleClearDataButton(_ sender: Any) {
        let vc = PopupViewController.instantiate()
        vc.titleStr = "CLEAR DATA"
        vc.content = "Are you sure you want to clear the game data?"
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    @IBAction func handleBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension OptionsViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "Options", bundle: nil)
}
