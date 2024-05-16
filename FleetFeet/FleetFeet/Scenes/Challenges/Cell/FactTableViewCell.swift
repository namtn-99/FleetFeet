//
//  FactTableViewCell.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/15/24.
//

import UIKit

final class FactTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var primaryButton: UIButton!
    
    var didSelected: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
      //  primaryButton.applyGradient(colors: [AppColors._6A7CD8, AppColors._0F0D6C])
    }
    
    func configCell(title: String, isDone: Bool) {
        if isDone {
            primaryButton.applyGradient(colors: [AppColors.ABE87A, AppColors._16713D])
        } else {
            primaryButton.applyGradient(colors: [AppColors._6A7CD8, AppColors._0F0D6C])
        }
        primaryButton.setTitle(title, for: .normal)
    }
    
    @IBAction func handlePrimaryButton(_ sender: Any) {
        if AppStorage.isOnMusic {
            playSound(with: "buttons")
        }
        
        didSelected?()
    }
}
