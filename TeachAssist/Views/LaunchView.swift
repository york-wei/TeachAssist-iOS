//
//  LaunchView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-06-04.
//

import SwiftUI

struct LaunchView: View {
    @ObservedObject var viewModel: ViewModel
    let logoSize = UIScreen.main.bounds.size.width / 2
    
    var body: some View {
        VStack {
            if viewModel.showLogo {
//                SwiftUIGIFPlayerView(gifName: (viewModel.colorScheme == .light) ? "logolight" : "logodark")
//                    .frame(width: logoSize, height: logoSize)
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(TAColor.backgroundColor)
        .ignoresSafeArea()
        .onAppear {
            viewModel.hideLogoAfterDelay()
        }
    }
}

extension LaunchView {
    class ViewModel: ObservableObject {
        @Published var colorScheme = UITraitCollection.current.userInterfaceStyle
        @Published var showLogo = true
       
        func hideLogoAfterDelay() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                self.showLogo = false
            }
        }
    }
}
