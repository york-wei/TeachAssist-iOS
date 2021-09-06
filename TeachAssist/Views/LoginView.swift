//
//  LoginView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-06-05.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: ViewModel
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
                .fontWeight(.semibold)
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
                LoginButtonView(isLoading: $viewModel.isLoading)
            }
            .buttonStyle(TAButtonStyle(scale: 1.02))
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
        
        let userState: UserState
        
        init(userState: UserState) {
            self.userState = userState
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
            TAService.shared.authenticateStudent(username: username, password: password, completion: { result in
                switch result {
                case .failure(let authenticationError):
                    self.handleError(error: authenticationError)
                case .success(let authenticationResponse):
                    self.handleAuthenticationSuccess(response: authenticationResponse)
                }
            })
        }
        
        private func handleError(error: TAError) {
            DispatchQueue.main.async {
                self.errorText = error.description
                withAnimation {
                    self.isLoading = false
                    self.showError = true
                }
            }
        }
        
        private func handleAuthenticationSuccess(response: AuthenticationResponse) {
            do {
                let courses = try TAParser.shared.parseCourseList(html: response.dataString)
                var thrownError: Error? = nil
                let group = DispatchGroup()
                for course in courses where course.link != nil {
                    group.enter()
                    DispatchQueue.global(qos: .userInteractive).async {
                        TAService.shared.fetchCourse(link: course.link!,
                                                     sessionToken: response.sessionToken,
                                                     studentId: response.studentId) { result in
                            switch result {
                            case .failure(let courseFetchError):
                                thrownError = courseFetchError
                            case .success(let courseFetchResponse):
                                do {
                                    try TAParser.shared.parseCourse(course: course, html: courseFetchResponse.dataString)
                                } catch let error {
                                    thrownError = error
                                }
                            }
                            group.leave()
                        }
                    }
                }
                group.notify(queue: .main) {
                    // all course fetches finished, check for errors
                    if let error = thrownError {
                        self.handleError(error: TAError.getTAError(error))
                        return
                    }
                    // save courses and login details
                    DispatchQueue.main.async {
                        PersistenceController.shared.saveCourses(courses: courses)
                        self.userState.username = self.username
                        self.userState.password = self.password
                        self.userState.fromLogin = true
                        self.userState.isLoggedIn = true
                    }
                }
            } catch let error {
                handleError(error: TAError.getTAError(error))
            }
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(viewModel: .init(fadeIn: false))
//            .previewDevice("iPhone 12 mini")
//            .previewDisplayName("iPhone 12 Mini")
        
//        LoginView(viewModel: .init(fadeIn: false))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
//            .previewDisplayName("iPhone 12")

//        LoginView(viewModel: .init(fadeIn: false))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
//            .previewDisplayName("iPhone 12 Pro Max")

//        LoginView(viewModel: .init(fadeIn: false))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//            .previewDisplayName("iPhone 8")
        
//        LoginView(viewModel: .init(fadeIn: false))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
//            .previewDisplayName("iPhone 8 Plus")
//    }
//}
