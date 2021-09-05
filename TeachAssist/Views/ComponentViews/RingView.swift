//
//  RingView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-30.
//

import SwiftUI

struct RingView: View {
    let percentage : Double
    @Binding var animate : Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(TAColor.ringBackgroundColor, style: StrokeStyle(lineWidth: 11))
                .frame(width: 150, height: 150)
            Circle()
                .trim(from: !animate ? CGFloat(1 - percentage / 100) : 1, to: 1)
                .stroke(LinearGradient(gradient: TAColor.themeGradient ,startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 13, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20, 0], dashPhase: 0))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .frame(width: 150, height: 150)
                .shadow(color: TAColor.themeDropShadowColor, radius: 6, x: 0, y: 3)
                .hueRotation(.degrees(!animate ? 0 : -45))
                .animation(Animation.easeInOut(duration: 0.6))
            Text(String(format: "%.1f%%", percentage))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(TAColor.primaryTextColor)
                .redacted(reason: animate ? .placeholder : [])
        }
    }
}

struct RingView_Previews: PreviewProvider {
    static var previews: some View {
        RingView(percentage: 80, animate: .constant(false))
    }
}

