//
//  LoginView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-06-05.
//

import Foundation
import SwiftUI

struct LoginView: View {
        
    @State var fadeIn = true
    @State var selectedUsername = false
    @State var selectedPassword = false
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
}

extension LoginView {
    class ViewModel: ObservableObject {
        @Published var username = ""
        @Published var password = ""
        
        let userState: UserState
        
        init(userState: UserState) {
            self.userState = userState
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct SecureTextField: UIViewRepresentable {
    
    var title: String
    @Binding var text: String
    var onEditingChanged: (Bool) -> Void
    
    func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.placeholder = title
//        view.font = UIFont.preferredFont(forTextStyle: UIFont()
//        view.textColor = UIColor(Color("PrimaryTextColor"))
        view.delegate = context.coordinator
        view.isSecureTextEntry = true
        view.endEditing(true)
        view.keyboardType = UIKeyboardType.asciiCapable
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(p: self)
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        DispatchQueue.main.async {
            uiView.text = text
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        var parent: SecureTextField
        
        init(p: SecureTextField) {
            self.parent = p
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.onEditingChanged(true)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.onEditingChanged(false)
            if let text = textField.text {
                self.parent.text = text
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
        }
    }
    
}
