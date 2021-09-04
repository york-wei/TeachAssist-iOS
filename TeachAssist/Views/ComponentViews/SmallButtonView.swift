//
//  SmallButtonView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-02.
//

import SwiftUI

struct SmallButtonView: View {
    let imageName: String
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Rectangle()
                .foregroundColor(TAColor.foregroundColor)
                .frame(width: 45, height: 45)
                .cornerRadius(10)
                .shadow(color: TAColor.dropShadowColor, radius: 5, x: 2, y: 2)
            Image(systemName: imageName)
                .font(.title3)
                .foregroundColor(Color("PrimaryTextColor"))
        }
    }
}
