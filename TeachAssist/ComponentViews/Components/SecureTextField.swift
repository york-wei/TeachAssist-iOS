//
//  SecureTextField.swift
//  TeachAssist
//
//  Created by York Wei on 2021-07-14.
//

import SwiftUI

struct SecureTextField: UIViewRepresentable {
    
    let title: String
    @Binding var text: String
    var onEditingChanged: (Bool) -> Void
    
    func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.placeholder = title
        view.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        view.textColor = UIColor(named: "PrimaryTextColor")
        view.delegate = context.coordinator
        view.isSecureTextEntry = true
        view.endEditing(true)
        view.keyboardType = UIKeyboardType.asciiCapable
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        DispatchQueue.main.async {
            uiView.text = text
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: SecureTextField
        
        init(parent: SecureTextField) {
            self.parent = parent
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
