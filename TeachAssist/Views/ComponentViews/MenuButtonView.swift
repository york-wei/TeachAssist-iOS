//
//  MenuButtonView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-05.
//

import SwiftUI

struct ArrowButtonView: View {
    let label: String
    var body: some View {
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

struct ThemeButtonView: View {
    let theme: InterfaceTheme
    
    var body: some View {
        HStack {
            Text("Theme:")
                .font(.subheadline)
                .foregroundColor(TAColor.primaryTextColor)
                .fontWeight(.semibold)
            Spacer()
            Text(theme.name)
                .font(.subheadline)
                .foregroundColor(TAColor.themeColor)
                .fontWeight(.semibold)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding([.top, .bottom, .leading, .trailing], 20)
    }
}

struct LogOutButtonView: View {
    var body: some View {
        HStack {
            Text("Log Out")
                .font(.subheadline)
                .foregroundColor(Color.red)
                .fontWeight(.semibold)
            Spacer()
            Image(systemName: "square.and.arrow.up")
                .font(.subheadline)
                .foregroundColor(TAColor.primaryTextColor)
                .rotationEffect(.degrees(90))
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding([.top, .bottom, .leading, .trailing], 20)
    }
}
