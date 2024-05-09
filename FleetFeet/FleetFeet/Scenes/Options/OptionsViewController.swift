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
        clearDataButton.applyGradient(colors: [AppColors._29CAFF, AppColors._015AC8])
        shareButton.applyGradient(colors: [AppColors._29CAFF, AppColors._015AC8])
    }

    @IBAction func handleIconButton(_ sender: UIButton) {
    }
    
    @IBAction func handleShareButton(_ sender: Any) {
    }
    
    @IBAction func handleClearDataButton(_ sender: Any) {
        let vc = PopupViewController.instantiate()
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
