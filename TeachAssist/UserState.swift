//
//  UserState.swift
//  TeachAssist
//
//  Created by York Wei on 2021-05-17.
//

import Foundation
import SwiftUI

enum InterfaceTheme: Int {
    case system
    case light
    case dark
}

class UserState: ObservableObject {
    
    // MARK: - Properties
    @Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn") {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }
    
    @Published var isLoading: Bool = false

    @Published var username: String = UserDefaults.standard.string(forKey: "username") ?? "" {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    
    @Published var password: String = UserDefaults.standard.string(forKey: "password") ?? "" {
        didSet {
            UserDefaults.standard.set(password, forKey: "password")
        }
    }
    
    @Published var interfaceTheme: InterfaceTheme = {
        let rawValue = UserDefaults.standard.integer(forKey: "interfaceTheme")
        return InterfaceTheme(rawValue: rawValue) ?? .system
    }() {
        didSet {
            UserDefaults.standard.set(interfaceTheme.rawValue, forKey: "interfaceTheme")
        }
    }
    
}
