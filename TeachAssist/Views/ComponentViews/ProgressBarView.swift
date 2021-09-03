//
//  ProgressBarView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-03.
//

import SwiftUI

struct ProgressBarView: View {
    let percentage: Double
    var body: some View {
        ZStack {
            GeometryReader { geometryReader in
                Capsule()
                    .foregroundColor(TAColor.progressBackgroundColor)
                    .frame(height: 5)
                Capsule()
                    .fill(LinearGradient(gradient: TAColor.themeGradient, startPoint: .leading, endPoint: .trailing))
                    .frame(width: CGFloat(geometryReader.size.width) * CGFloat(self.percentage / 100), height: 3)
                    .hueRotation(.degrees(0))
                    .offset(x: 1, y: 1)
            }
        }
    }
}
