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

    @Published var username: String = KeychainWrapper.standard.string(forKey: "USERNAME") ?? "" {
        didSet {
            KeychainWrapper.standard.set(username, forKey: "USERNAME")
        }
    }
    
    @Published var password: String = KeychainWrapper.standard.string(forKey: "PASSWORD") ?? "" {
        didSet {
            KeychainWrapper.standard.set(password, forKey: "PASSWORD")
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
