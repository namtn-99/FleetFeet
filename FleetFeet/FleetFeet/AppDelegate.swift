//
//  AppDelegate.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/9/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        updateFacts()
        return true
    }
    
    private func updateFacts() {
        AppStorage.factsUnlock = 0
        if AppStorage.scores > 76 {
            AppStorage.factsUnlock += 1
        }
        if AppStorage.playCount > 10 {
            AppStorage.factsUnlock += 1
        }
        if AppStorage.scores > 154 {
            AppStorage.factsUnlock += 1
        }
        if AppStorage.isShared {
            AppStorage.factsUnlock += 1
        }
        if AppStorage.scores > 1345 {
            AppStorage.factsUnlock += 1
        }
        
        if let date = AppStorage.comDate {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: date, to: Date())
            if let differenceInDays = components.day,
                differenceInDays >= 3 {
                AppStorage.factsUnlock += 1
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

