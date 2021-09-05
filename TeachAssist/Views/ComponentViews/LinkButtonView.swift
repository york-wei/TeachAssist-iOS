//
//  LinkButtonView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-05.
//

import SwiftUI

struct LinkButtonView: View {
    let label: String
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(TAColor.foregroundColor)
                .cornerRadius(10)
                .shadow(color: TAColor.dropShadowColor, radius: 5, x: 0, y: 2)
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(TAColor.primaryTextColor)
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundColor(TAColor.primaryTextColor)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.top, .bottom, .leading, .trailing], 20)
        }
    }
}
