//
//  ProgressBarView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-03.
//

import SwiftUI

struct ProgressBarView: View {
    let percentage: Double
    @Binding var animate : Bool
    
    var body: some View {
        ZStack {
            GeometryReader { geometryReader in
                Capsule()
                    .foregroundColor(TAColor.progressBarBackgroundColor)
                    .frame(height: 7)
                    .zIndex(0)
                Capsule()
                    .fill(LinearGradient(gradient: TAColor.themeGradient, startPoint: .leading, endPoint: .trailing))
                    .frame(width: animate ? 0 : CGFloat(geometryReader.size.width) * CGFloat(self.percentage / 100), height: 5)
                    .hueRotation(.degrees(animate ? -45 : 0))
                    .offset(x: 1, y: 1)
                    .animation(Animation.easeInOut(duration: 0.6))
                    .zIndex(1)
            }
        }
    }
}
