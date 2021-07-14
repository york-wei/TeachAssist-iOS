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
