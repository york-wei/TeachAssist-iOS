//
//  LoginView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-06-05.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: ViewModel
    let topPadding = UIScreen.main.bounds.size.height / 10
    
    var body: some View {
        VStack(alignment: .center) {
            HStack { Spacer() }
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150 * 0.71)
                .padding(.top, topPadding)
                .shadow(color: TAColor.themeDropShadowColor, radius: 5)
            Text("TeachAssist")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(TAColor.primaryTextColor)
            Text("For YRDSB")
                .font(.subheadline)
                .fontWeight(.regular)
                .foregroundColor(TAColor.secondaryTextColor)
                .padding(3)
            TextFieldView(viewModel: .init(imageName: "person.fill", title: "Student Number", isSecure: false, text: $viewModel.username))
                .padding(.top, topPadding * 0.65)
                .disabled(viewModel.isLoading)
            TextFieldView(viewModel: .init(imageName: "lock.fill", title: "Password", isSecure: true, text: $viewModel.password))
                .padding(.top, topPadding * 0.65)
                .disabled(viewModel.isLoading)
            Spacer()
            Text(viewModel.errorText)
                .font(.subheadline)
                .fontWeight(.regular)
                .foregroundColor(.red)
                .opacity(viewModel.showError ? 1 : 0)
                .padding(10)
            Button(action: {
                viewModel.longButtonPressed()
            }) {
                LongButtonView(viewModel: .init(isLoading: $viewModel.isLoading))
            }
            .buttonStyle(LongButtonStyle())
            .disabled(viewModel.isLoading)
        }
        .padding(TAPadding.viewEdgePadding)
        .opacity(viewModel.fadeIn ? 0 : 1)
        .offset(x: 0, y: viewModel.fadeIn ? 50 : 0)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear() {
            viewModel.playFadeInAnimation()
        }
    }
}

extension LoginView {
    class ViewModel: ObservableObject {
        
        @Published var username = ""
        @Published var password = ""
        
        @Published var fadeIn = true
        @Published var selectedUsername = false
        @Published var selectedPassword = false
        
        @Published var showError = false
        @Published var errorText = ""
        @Published var isLoading = false
        
        init() {}
        
        // Init for previews
        init(fadeIn: Bool) {
            self.fadeIn = fadeIn
        }
        
        func playFadeInAnimation() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(Animation.spring()) {
                    self.fadeIn = false
                }
            }
        }
        
        func longButtonPressed() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation {
                self.isLoading = true
                self.showError = false
            }
            TAService.shared.authenticateStudent(username: username, password: password, completion: { response in
                switch response {
                case .failure(let error):
                    self.handleLoginError(error: error)
                case .success(let authenticationResponse):
                    self.handleLoginSuccess(response: authenticationResponse)
                }
            })
        }
        
        private func handleLoginError(error: TAError) {
            DispatchQueue.main.async {
                switch error {
                case .badRequest:
                    self.errorText = "Could Not Reach TeachAssist"
                case .noConnection:
                    self.errorText = "No Connection"
                case .invalidLogin:
                    self.errorText = "Invalid Login"
                case .parsingError:
                    self.errorText = "Unexpected Error"
                }
                withAnimation {
                    self.isLoading = false
                    self.showError = true
                }
            }
        }
        
        private func handleLoginSuccess(response: AuthenticationResponse) {
            do {
                let courses = try TAParser.parseCourseList(html: response.dataString)
                print(courses)
            } catch {
                handleLoginError(error: .parsingError)
            }
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
//        LoginView(viewModel: .init(fadeIn: false))
//            .previewDevice("iPhone 12 mini")
//            .previewDisplayName("iPhone 12 Mini")
        
        LoginView(viewModel: .init(fadeIn: false))
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
            .previewDisplayName("iPhone 12")

//        LoginView(viewModel: .init(fadeIn: false))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
//            .previewDisplayName("iPhone 12 Pro Max")

//        LoginView(viewModel: .init(fadeIn: false))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//            .previewDisplayName("iPhone 8")
        
//        LoginView(viewModel: .init(fadeIn: false))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
//            .previewDisplayName("iPhone 8 Plus")
    }
}
