//
//  Utils.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/16/24.
//

import UIKit

class Utils {
    class func swapRootViewController(_ newRootViewController: UIViewController, completion: (() -> Void)? = nil) {
        guard let window = UIApplication.keyWindow() else {
            return
        }
        window.rootViewController = newRootViewController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil) { _ in
            completion?()
        }
    }
}

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    class func keyWindow() -> UIWindow? {
        return UIApplication.shared.windows.first
    }
}
