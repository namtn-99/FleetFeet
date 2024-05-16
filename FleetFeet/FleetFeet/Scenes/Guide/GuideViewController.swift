//
//  GuideViewController.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/9/24.
//

import UIKit

final class GuideViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var guideContentView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    private var currentGuide = 0
    private var guides = [
        "Welcome! Experience an emotional and playful experiment with our app!\nLet me tell you in detail what you can do!",
        "In Game your task to get to the ball and bring it to the finish line through the crowd of opponents on the field. The control is due to arrow buttons, which you will see on the screen.\nA point is scored only when you reach the finish line with the ball. It will be in the hands of one of the opponents. You will need to touch him to pick up the ball.\nIf you bump into an opponent, one life will be taken away from you. There are 5 lives in total. If you bump into an opponent with a ball, the opponent will get the ball from you.",
        "In the Challenges section you'll have two competitions: complete tasks and discover new facts about the sport or compete against other users in a daily tournament for prizes."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        nextButton.applyGradient(colors: [AppColors._29CAFF, AppColors._015AC8])
        previousButton.applyGradient(colors: [AppColors._29CAFF, AppColors._015AC8])
        contentTextView.text = guides[0].uppercased()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLayout()
    }
    
    private func updateLayout() {
        let fixedWidth = contentTextView.frame.size.width
        let newSize = contentTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        contentHeightConstraint.constant = newSize.height + 50
        guideContentView.applyGradient(colors: [AppColors.ABE87A, AppColors._16713D])
    }
    
    @IBAction func handlePreviousButton(_ sender: UIButton) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        
        if currentGuide > 0 {
            currentGuide -= 1
            print(currentGuide)
            titleLabel.text = "GUIDE " + String(describing: Int(currentGuide + 1)) + "/3"
            contentTextView.text = guides[currentGuide].uppercased()
            updateLayout()
        }
    }
    
    @IBAction func handleNextButton(_ sender: UIButton) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        
        if currentGuide < 2 {
            currentGuide += 1
            print(currentGuide)
            titleLabel.text = "GUIDE " + String(describing: Int(currentGuide + 1)) + "/3"
            contentTextView.text = guides[currentGuide].uppercased()
            updateLayout()
        }
    }
    
    @IBAction func handleBackButton(_ sender: UIButton) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        navigationController?.popViewController(animated: true)
    }
}

extension GuideViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "Guide", bundle: nil)
}
