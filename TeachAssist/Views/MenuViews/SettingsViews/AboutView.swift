//
//  AboutView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-06.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let year = String(Calendar.current.component(.year, from: Date()))
    
    var body: some View {
        ZStack (alignment: .top){
            HStack(alignment: .center) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    SmallButtonView(imageName: "chevron.left")
                }
                .buttonStyle(TAButtonStyle(scale: 1.07))
                Spacer()
                Text("About")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(TAColor.primaryTextColor)
                Spacer()
                Button(action: {
                }) {
                    SmallButtonView(imageName: "xmark")
                }
                .opacity(0)
            }
            .padding(.top, 40)
            .padding([.trailing, .leading], TAPadding.viewEdgePadding)
            VStack {
                Spacer()
                Image("Logo")
                    .resizable()
                    .frame(width: 150, height: 150 * 0.71)
                    .shadow(color: TAColor.themeDropShadowColor, radius: 5)
                Text("TeachAssist")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(TAColor.primaryTextColor)
                Text("Version \(version)\n© \(year) York Wei")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(TAColor.primaryTextColor)
                    .padding(3)
                    .multilineTextAlignment(.center)
                Spacer()
                Text("This app is not affiliated with the TeachAssist Foundation or YRDSB. Use at own discretion.")
                    .font(.caption2)
                    .fontWeight(.regular)
                    .foregroundColor(TAColor.secondaryTextColor)
                    .multilineTextAlignment(.center)
            }
            .padding([.top, .bottom, .leading, .trailing], TAPadding.viewEdgePadding)
        }
        .ignoresSafeArea()
        .background(TAColor.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
    }
}
