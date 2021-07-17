//
//  LongButtonView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-07-14.
//

import SwiftUI

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
        .animation(.spring())
        .disabled(viewModel.isLoading)
    }
}

extension LongButtonView {
    class ViewModel: ObservableObject {
        @Binding var isLoading: Bool
        
        init(isLoading: Binding<Bool>) {
            self._isLoading = isLoading
        }
    }
}

struct LongButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.03 : 1)
    }
}
