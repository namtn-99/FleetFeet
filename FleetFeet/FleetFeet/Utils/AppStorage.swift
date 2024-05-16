//
//  AppConstant.swift
//  FleetFeet
//
//  Created by trinh.ngoc.nam on 5/16/24.
//

import UIKit

enum AppStorage {
    @Storage(key: "isOnMusic", defaultValue: false)
    static var isOnMusic: Bool
    
    @Storage(key: "titleIcon", defaultValue: 1)
    static var titleIcon: Int
    
    @Storage(key: "scores", defaultValue: 0)
    static var scores: Int
    
    @Storage(key: "playCount", defaultValue: 0)
    static var playCount: Int
    
    @Storage(key: "factsUnlock", defaultValue: 0)
    static var factsUnlock: Int
    
    @Storage(key: "isShared", defaultValue: false)
    static var isShared: Bool
    
    @Storage(key: "comeDate", defaultValue: nil)
    static var comDate: Date?

    static func clearData() {
        AppStorage.isOnMusic = false
        AppStorage.titleIcon = 1
        AppStorage.scores = 0
        AppStorage.playCount = 0
        AppStorage.isShared = false
        AppStorage.comDate = nil
        AppStorage.factsUnlock = 0
    }
}
