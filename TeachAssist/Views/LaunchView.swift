//
//  LaunchView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-06-04.
//

import SwiftUI

struct LaunchView: View {
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150 * 0.71)
                .shadow(color: TAColor.themeDropShadowColor, radius: 5)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(TAColor.backgroundColor)
        .ignoresSafeArea()
    }
}
