//
//  TeachAssistApp.swift
//  TeachAssist
//
//  Created by York Wei on 2021-05-17.
//

import SwiftUI

@main
struct TeachAssistApp: App {

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: .init(userState: UserState()))
                .environmentObject(UserState())
        }
    }
    
}
