//
//  PopupViewController.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/9/24.
//

import UIKit

enum PopupType {
    case clearData
    case fact
}

final class PopupViewController: UIViewController {
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var layerView: UIView!
 
    var screenType: PopupType = .clearData
    
    var titleStr: String?
    var content: String?
    
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
        
        titleLabel.text = titleStr ?? ""
        contentLabel.text = content ?? ""
        primaryButton.applyGradient(colors: [AppColors._29CAFF, AppColors._015AC8])
        secondButton.applyGradient(colors: [AppColors._29CAFF, AppColors._015AC8])
        
        switch screenType {
        case .clearData:
            break
        case .fact:
            primaryButton.isHidden = true
            secondButton.setTitle("OK", for: .normal)
        }
        
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
