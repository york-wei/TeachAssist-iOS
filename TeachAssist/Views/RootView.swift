//
//  RootView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-05-17.
//

import SwiftUI
import CoreData

struct RootView: View {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject var userState: UserState

    var body: some View {
        ZStack {
            if viewModel.isLaunching {
                // MARK: - Launch
                LaunchView()
                    .transition(TATransition.fadeTransition)
                    .zIndex(2)
            }
            if !userState.isLoggedIn && !viewModel.isLaunching {
                // MARK: - Login
                LoginView(viewModel: .init(userState: userState))
                    .transition(TATransition.fadeTransition)
                    .zIndex(1)
            }
            if userState.isLoggedIn {
                // MARK: - Main
                MainView(viewModel: .init(userState: userState))
                    .transition(TATransition.fadeTransition)
                    .zIndex(0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.hideLaunchViewAfterDelay()
        }
    }
}

extension RootView {
    class ViewModel: ObservableObject {
        @Published var isLaunching = true
        let userState: UserState
        
        init(userState: UserState) {
            self.userState = userState
        }
       
        func hideLaunchViewAfterDelay() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    self.isLaunching.toggle()
                }
            }
        }
    }
}
