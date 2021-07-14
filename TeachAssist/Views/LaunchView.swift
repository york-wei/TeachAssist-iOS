//
//  LaunchView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-06-04.
//

import SwiftUI
import SSSwiftUIGIFView

struct LaunchView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            if viewModel.showLogo {
                SwiftUIGIFPlayerView(gifName: (viewModel.colorScheme == .light) ? "logolight" : "logodark")
                    .frame(width: 200, height: 200)
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(TAColor.backgroundColor)
        .onAppear {
            viewModel.hideLogoAfterDelay()
        }
    }
}

extension LaunchView {
    class ViewModel: ObservableObject {
        @Environment(\.colorScheme) var colorScheme
        @Published var showLogo = true
       
        func hideLogoAfterDelay() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                self.showLogo = false
            }
        }
    }
}
