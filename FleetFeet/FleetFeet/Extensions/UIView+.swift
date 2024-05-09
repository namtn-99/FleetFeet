//
//  UIView+.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/9/24.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIView {
    func applyGradient(colors: [UIColor],
                       startPoint: CGPoint = CGPoint(x: 0.5, y: 0),
                       endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
          layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
          
          // Create a CAGradientLayer
          let gradientLayer = CAGradientLayer()
          gradientLayer.frame = bounds
          gradientLayer.colors = colors.map { $0.cgColor }
          gradientLayer.startPoint = startPoint
          gradientLayer.endPoint = endPoint
          
          // Insert the gradient layer below other layers
          layer.insertSublayer(gradientLayer, at: 0)
      }
}


extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
