//
//  TAConstants.swift
//  TeachAssist
//
//  Created by York Wei on 2021-06-03.
//

import SwiftUI

struct TAColor {
    static let backgroundColor = Color("BackgroundColor")
    static let foregroundColor = Color("ForegroundColor")
    static let dropShadowColor = Color("DropShadowColor")
    static let themeColor = Color("ThemeColor")
    static let highlightColor = Color("HighlightColor")
    static let themeDropShadowColor = Color("ThemeDropShadowColor")
    static let primaryTextColor = Color("PrimaryTextColor")
    static let secondaryTextColor = Color("SecondaryTextColor")
    static let ringBackgroundColor = Color("RingBackgroundColor")
    static let progressBarBackgroundColor = Color("ProgressBarBackgroundColor")
    static let themeGradient = Gradient(colors: [Color(#colorLiteral(red: 0.1254901961, green: 0.3254901961, blue: 0.4549019608, alpha: 1)), Color(#colorLiteral(red: 0.1529411765, green: 0.6274509804, blue: 0.6196078431, alpha: 1)), Color(#colorLiteral(red: 0.1882352941, green: 0.8078431373, blue: 0.5333333333, alpha: 1))])
}

struct TATransition {
    static let fadeTransition = AnyTransition.opacity.animation(.easeIn(duration: 0.3))
}

struct TAPadding {
    static let viewEdgePadding = CGFloat(30)
}

struct TAUrl {
    static let loginUrl = URL(string: "https://ta.yrdsb.ca/yrdsb/")!
    static let errorUrl = URL(string: "https://ta.yrdsb.ca/live/index.php?error_message=3")!
    static func courseUrl(link: String) -> URL {
        return URL(string: "https://ta.yrdsb.ca/live/students/" + link)!
    }
}
