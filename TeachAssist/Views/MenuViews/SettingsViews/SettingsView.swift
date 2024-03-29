//
//  SettingsView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-05.
//

import SwiftUI

struct SettingsView: View {
    @Binding var show: Bool
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                // Top bar
                HStack(alignment: .center) {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        show = false
                    }) {
                        SmallButtonView(imageName: "xmark")
                    }
                    .buttonStyle(TAButtonStyle(scale: 1.07))
                    Spacer()
                    Text("Settings")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(TAColor.primaryTextColor)
                    Spacer()
                    Button(action: {
                    }) {
                        SmallButtonView(imageName: "xmark")
                    }
                    .opacity(0)
                }
                .padding(.top, 40)
                .padding([.trailing, .leading], TAPadding.viewEdgePadding)
                ZStack {
                    Rectangle()
                        .foregroundColor(TAColor.foregroundColor)
                        .cornerRadius(20)
                        .shadow(color: TAColor.dropShadowColor, radius: 5, x: 0, y: 2)
                    VStack {
                        Button(action: {
                            viewModel.didTapThemeButton()
                        }) {
                            ThemeButtonView(theme: viewModel.userState.interfaceTheme)
                        }
                        Divider()
                        Button(action: {
                            viewModel.didTapRateInAppStoreButton()
                        }) {
                            ArrowButtonView(label: "Rate In App Store")
                        }
                        Divider()
                        Button(action: {
                            viewModel.didTapReportBugButton()
                        }) {
                            ArrowButtonView(label: "Report A Bug")
                        }
                        Divider()
                        NavigationLink(destination: AboutView()) {
                            ArrowButtonView(label: "About")
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            viewModel.didTapAboutButton()
                        })
                        Divider()
                        Button(action: {
                            viewModel.didTapLogoutButton()
                        }) {
                            LogOutButtonView()
                        }
                    }
                    .padding([.top, .bottom], 10)
                }
                .padding([.top, .trailing, .leading], TAPadding.viewEdgePadding)
            }
            .navigationBarHidden(true)
            .background(TAColor.backgroundColor.edgesIgnoringSafeArea(.all))
        }
        .ignoresSafeArea()
    }
}

extension SettingsView {
    class ViewModel: ObservableObject {
        let userState: UserState
        
        init(userState: UserState) {
            self.userState = userState
        }
        
        func didTapThemeButton() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            switch userState.interfaceTheme {
            case .system:
                userState.interfaceTheme = .dark
            case .dark:
                userState.interfaceTheme = .light
            case .light:
                userState.interfaceTheme = .system
            }
        }
        
        func didTapRateInAppStoreButton() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id1479482556") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        func didTapReportBugButton() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            if let url = URL(string: "https://forms.gle/uLMdy6KK1iofhbfT8") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        func didTapAboutButton() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        
        func didTapLogoutButton() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            PersistenceController.shared.wipeCourses()
            userState.logOutUser()
        }
        
        
    }
}
