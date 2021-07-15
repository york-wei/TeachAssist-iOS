//
//  LongButtonView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-07-14.
//

import SwiftUI

protocol LongButtonProtocol {
    func longButtonPressed()
}

struct LongButtonView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .center)) {
            Rectangle()
                .foregroundColor(Color(#colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)))
                .frame(height: 65)
                .cornerRadius(15)
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)), radius: 10, x: 0, y: 5)
            
            if viewModel.isLoading {
                ActivityIndicator(isAnimating: true) {
                    $0.color = .white
                }
                .transition(TATransition.fadeTransition)
            } else {
                Text("Sign In")
                    .font(.body)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .transition(TATransition.fadeTransition)
            }
        }
        .onTapGesture {
            viewModel.handleButtonPress()
        }
        .scaleEffect(viewModel.buttonPressed ? 1.05 : 1)
        .animation(.spring())
        .disabled(viewModel.isLoading)
    }
}

extension LongButtonView {
    class ViewModel: ObservableObject {
        @Published var buttonPressed: Bool = false
        @Binding var isLoading: Bool
        let caller: LongButtonProtocol
        
        init(caller: LongButtonProtocol, isLoading: Binding<Bool>) {
            self.caller = caller
            self._isLoading = isLoading
        }
        
        func handleButtonPress() {
            self.buttonPressed = true
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.buttonPressed = false
                self.caller.longButtonPressed()
            }
        }
    }
}
