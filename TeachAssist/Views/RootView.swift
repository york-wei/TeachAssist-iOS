//
//  RootView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-05-17.
//

import SwiftUI
import CoreData

struct RootView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            if viewModel.isLaunching {
                // MARK: - Launch
                LaunchView(viewModel: LaunchView.ViewModel())
                    .transition(TATransition.fadeTransition)
                    .zIndex(2)
            }
            else if !UserState.shared.isLoggedIn {
                // MARK: - Login
                LoginView(viewModel: LoginView.ViewModel())
                    .zIndex(1)
            } else {
                // MARK: - Main
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
       
        func hideLaunchViewAfterDelay() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    self.isLaunching.toggle()
                }
            }
        }
    }
}