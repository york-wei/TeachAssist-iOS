//
//  LaunchView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-06-04.
//

import SwiftUI
import SSSwiftUIGIFView

struct LaunchView: View {

    @Environment(\.colorScheme) var colorScheme
    @State var showLogo = true
    
    var body: some View {
        VStack {
            if showLogo {
                SwiftUIGIFPlayerView(gifName: (colorScheme == .light) ? "logolight" : "logodark")
                    .frame(width: 200, height: 200)
            }
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(TAColor.backgroundColor)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                showLogo = false
            }
        }
    }
    
}
