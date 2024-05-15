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
        primaryButton.applyGradient(colors: [AppColors.ABE87A, AppColors._16713D])
    }
    
    func configCell(title: String) {
        primaryButton.setTitle(title, for: .normal)
    }
    
    @IBAction func handlePrimaryButton(_ sender: Any) {
        didSelected?()
    }
}
