//
//  CurrentUser.swift
//  garage-kids-ios
//
//  Created by Alexey Titov on 8/7/19.
//  Copyright © 2019 TRINITY digital. All rights reserved.
//

import Foundation

class CurrentUser {
    
    static let shared = CurrentUser()
    
    private init() {}
    
    var hasSeenOnboarding: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        }
        set {
            return UserDefaults.standard.set(newValue, forKey: "hasSeenOnboarding")
        }
    }
    
//    var age: Int {
//        get {
//            return UserDefaults.standard.integer(forKey: "age")
//        }
//        set {
//            return UserDefaults.standard.set(newValue, forKey: "age")
//        }
//    }

//    var name: String {
//        get {
//            return UserDefaults.standard.string(forKey: "name") ?? ""
//        }
//        set {
//            return UserDefaults.standard.set(newValue, forKey: "name")
//        }
//    }
}
