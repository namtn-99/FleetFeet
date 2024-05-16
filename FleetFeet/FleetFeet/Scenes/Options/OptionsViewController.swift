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
        
        setMusicStatus()
        setTitleButton()
    }
    
    private func setMusicStatus() {
        let musicImage = AppStorage.isOnMusic ? UIImage(named: "ic_music_on") : UIImage(named: "ic_music_off")
        musicStatusLabel.text = AppStorage.isOnMusic ? "ON" : "OFF"
        musicButton.setImage(musicImage, for: .normal)
    
    }
    
    private func setTitleButton() {
        switch AppStorage.titleIcon {
        case 1:
            icon1Button.setImage(UIImage(named: "ic_button1_on"), for: .normal)
            icon2Button.setImage(UIImage(named: "ic_button2_off"), for: .normal)
            icon3Button.setImage(UIImage(named: "ic_button3_off"), for: .normal)
        case 2:
            icon1Button.setImage(UIImage(named: "ic_button1_off"), for: .normal)
            icon2Button.setImage(UIImage(named: "ic_button2_on"), for: .normal)
            icon3Button.setImage(UIImage(named: "ic_button3_off"), for: .normal)
        case 3:
            icon1Button.setImage(UIImage(named: "ic_button1_off"), for: .normal)
            icon2Button.setImage(UIImage(named: "ic_button2_off"), for: .normal)
            icon3Button.setImage(UIImage(named: "ic_button3_on"), for: .normal)
        default:
            break
        }
        NotificationCenter.default.post(name: .updateIcon, object: nil)
    }
    
    @IBAction func handleMusicButton(_ sender: Any) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        
        AppStorage.isOnMusic.toggle()
        setMusicStatus()
    }
    
    @IBAction func handleIconButton(_ sender: UIButton) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        AppStorage.titleIcon = sender.tag
        setTitleButton()
    }
    
    @IBAction func handleShareButton(_ sender: Any) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        AppStorage.isShared = true
        let text = "Share our app Better Run on Store"
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func handleClearDataButton(_ sender: Any) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        
        let vc = PopupViewController.instantiate()
        vc.titleStr = "CLEAR DATA"
        vc.content = "Are you sure you want to clear the game data?"
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    @IBAction func handleBackButton(_ sender: Any) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension OptionsViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "Options", bundle: nil)
}
