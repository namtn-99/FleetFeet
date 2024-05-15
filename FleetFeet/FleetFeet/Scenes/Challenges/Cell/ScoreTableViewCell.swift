//
//  ScoreTableViewCell.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/15/24.
//

import UIKit

final class ScoreTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var layerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        layerView.applyGradient(colors: [AppColors._6A7CD8, AppColors._0F0D6C])
    }
    
    func configCell(index: Int, title: String, score: Int) {
        titleLabel.text = "\(String(describing: index)) \(title)"
        scoreLabel.text = String(describing: score)
    }
}
