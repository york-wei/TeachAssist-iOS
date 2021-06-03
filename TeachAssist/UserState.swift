//
//  UserState.swift
//  TeachAssist
//
//  Created by York Wei on 2021-05-17.
//

import Foundation
import SwiftUI
import SwiftKeychainWrapper

class UserState: ObservableObject {
    
    // MARK: - Properties
    @Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "IS_LOGGED_IN") {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "IS_LOGGED_IN")
        }
    }
    
    @Published var isLoading: Bool = false

    @Published var username: String = UserDefaults.standard.string(forKey: "USERNAME") ?? "" {
        didSet {
            UserDefaults.standard.set(username, forKey: "USERNAME")
        }
    }
    
    @Published var password: String = UserDefaults.standard.string(forKey: "PASSWORD") ?? "" {
        didSet {
            UserDefaults.standard.set(password, forKey: "PASSWORD")
        }
    }
    
    @Published var interfaceTheme: InterfaceTheme = {
        let rawValue = UserDefaults.standard.integer(forKey: "INTERFACE_THEME")
        return InterfaceTheme(rawValue: rawValue) ?? .system
    }() {
        didSet {
            UserDefaults.standard.set(interfaceTheme.rawValue, forKey: "INTERFACE_THEME")
        }
    }
    
}

enum InterfaceTheme: Int {
    case system
    case light
    case dark
}
