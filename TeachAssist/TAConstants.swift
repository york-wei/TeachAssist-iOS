//
//  TAConstants.swift
//  TeachAssist
//
//  Created by York Wei on 2021-06-03.
//

import SwiftUI

struct TAColor {
    static let backgroundColor = Color("BackgroundColor")
    static let themeColor = Color("ThemeColor")
    static let themeDropShadowColor = Color("ThemeDropShadowColor")
    static let primaryTextColor = Color("PrimaryTextColor")
    static let secondaryTextColor = Color("SecondaryTextColor")
}

struct TATransition {
    static let fadeTransition = AnyTransition.opacity.animation(.easeIn(duration: 0.3))
}

struct TAPadding {
    static let viewEdgePadding = CGFloat(30)
}
