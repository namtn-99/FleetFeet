//
//  ScoreTableViewCell.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/15/24.
//

import UIKit

final class ScoreTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var layerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        layerView.applyGradient(colors: [AppColors._6A7CD8, AppColors._0F0D6C])
        iconImageView.isHidden = true
    }
    
    func configCell(index: Int, title: String, score: Int, isUser: Bool = false) {
        scoreLabel.text = String(describing: score)
        
        if isUser {
            titleLabel.text = title
            iconImageView.isHidden = false
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
        } else {
            titleLabel.text = "\(String(describing: index)) \(title)"
            iconImageView.isHidden = true
        }
    }
}
