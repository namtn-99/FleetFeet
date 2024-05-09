//
//  PopupViewController.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/9/24.
//

import UIKit

enum PopupType {
    case clearData
    
    var title: String {
        switch self  {
        case .clearData:
            return "CLEAR DATA"
        }
    }
    
    var content: String {
        switch self {
        case .clearData:
            return "Are you sure you want to clear the game data?"
        }
    }
}

final class PopupViewController: UIViewController {
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var layerView: UIView!
 
    var screenType: PopupType = .clearData
    
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
        
        titleLabel.text = screenType.title
        contentLabel.text = screenType.content.uppercased()
        primaryButton.applyGradient(colors: [AppColors._29CAFF, AppColors._015AC8])
        secondButton.applyGradient(colors: [AppColors._29CAFF, AppColors._015AC8])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layerView.applyGradient(colors: [AppColors.ABE87A, AppColors._16713D])
    }
    
    @IBAction func handleSecondButton(_ sender: Any) {
        dismiss(animated: false)
    }
    
}

extension PopupViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "Popup", bundle: nil)
}
