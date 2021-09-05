//
//  TrendView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-05.
//

import SwiftUI

struct TrendView: View {
    var body: some View {
        
        LineView(data: [90, 89, 94.4, 91.3, 94.4, 89, 94, 100], title: "Knowledge", style: ChartStyle(backgroundColor: TAColor.foregroundColor, accentColor: Color(#colorLiteral(red: 0.1529411765, green: 0.6274509804, blue: 0.6196078431, alpha: 1)), gradientColor: GradientColor(start: Color(#colorLiteral(red: 0.1254901961, green: 0.3254901961, blue: 0.4549019608, alpha: 1)), end: Color(#colorLiteral(red: 0.1769984036, green: 0.7524441806, blue: 0.7453995635, alpha: 1))), textColor: TAColor.primaryTextColor, legendTextColor: Color.black, dropShadowColor: Color.gray), valueSpecifier: "%.1f%%")
            .padding(30)

    }
}

struct TrendView_Previews: PreviewProvider {
    static var previews: some View {
        TrendView()
    }
}
