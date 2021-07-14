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
    let logoSize = UIScreen.main.bounds.size.width / 3.5
    let topPadding = UIScreen.main.bounds.size.height / 10
    
    var body: some View {
        VStack(alignment: .center) {
            HStack { Spacer() }
            Image("Logo")
                .resizable()
                .frame(width: logoSize, height: logoSize)
                .padding(.top, topPadding)
                .shadow(color: TAColor.themeDropShadowColor, radius: 3)
            Text("TeachAssist")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(TAColor.primaryTextColor)
            Text("For YRDSB")
                .font(.subheadline)
                .fontWeight(.regular)
                .foregroundColor(TAColor.secondaryTextColor)
                .padding(3)
            Spacer()
            LongButtonView(viewModel: LongButtonView.ViewModel(caller: viewModel, isLoading: $viewModel.isLoading))
        }
        .padding(TAPadding.viewEdgePadding)
        .opacity(viewModel.fadeIn ? 0 : 1)
        .offset(x: 0, y: viewModel.fadeIn ? 50 : 0)
        .onAppear() {
            viewModel.playFadeInAnimation()
        }
    }
}

extension LoginView {
    class ViewModel: ObservableObject, LongButtonProtocol {
        
        @Published var username = ""
        @Published var password = ""
        
        @Published var fadeIn = true
        @Published var selectedUsername = false
        @Published var selectedPassword = false
        
        @Published var showInvalidLogin = false
        @Published var isLoading = false
        
        init() {}
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
            //self.isLoading = true
            // do the login here
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginView.ViewModel(fadeIn: false))
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Mini"))
            .previewDisplayName("iPhone 12 Mini")

//        LoginView(viewModel: LoginView.ViewModel(fadeIn: false))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
//            .previewDisplayName("iPhone 12 Pro Max")

//        LoginView(viewModel: LoginView.ViewModel(fadeIn: false))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//            .previewDisplayName("iPhone 8")
        
//        LoginView(viewModel: LoginView.ViewModel(fadeIn: false))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
//            .previewDisplayName("iPhone 8 Plus")
    }
}
