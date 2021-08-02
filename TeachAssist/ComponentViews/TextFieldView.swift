//
//  TextFieldView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-07-19.
//

import SwiftUI

struct TextFieldView: View {
    @ObservedObject var viewModel: ViewModel
    @State var selected = false
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Image(systemName: viewModel.imageName)
                        .foregroundColor(TAColor.secondaryTextColor)
                        .font(.system(.subheadline))
                    Image(systemName: viewModel.imageName)
                        .foregroundColor(TAColor.themeColor)
                        .font(.system(.subheadline))
                        .opacity(selected ? 1 : 0)
                }
                if !viewModel.isSecure {
                    TextField(viewModel.title, text: $viewModel.text, onEditingChanged: {_ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            selected.toggle()
                        }
                    }, onCommit: {})
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                        .autocapitalization(.none)
                        .keyboardType(.asciiCapable)
                        .disableAutocorrection(true)
                        .foregroundColor(TAColor.primaryTextColor)
                } else {
                    SecureTextField(title: viewModel.title, text: $viewModel.text, onEditingChanged: {_ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            selected.toggle()
                        }
                    })
                    .frame(height: 20)
                }
            }
            .padding(.bottom, 9)
            ZStack {
                Rectangle()
                    .foregroundColor(TAColor.secondaryTextColor)
                    .frame(height: 1)
                Rectangle()
                    .foregroundColor(TAColor.themeColor)
                    .frame(height: 2)
                    .opacity(selected ? 1 : 0)
            }
        }
    }
}

extension TextFieldView {
    class ViewModel: ObservableObject {
        let imageName: String
        let title: String
        let isSecure: Bool
        @Binding var text: String
        
        init(imageName: String, title: String, isSecure: Bool, text: Binding<String>) {
            self.imageName = imageName
            self.title = title
            self.isSecure = isSecure
            self._text = text
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView(viewModel: .init(imageName: "person.fill", title: "Student ID", isSecure: false, text: .constant("")))
    }
}
