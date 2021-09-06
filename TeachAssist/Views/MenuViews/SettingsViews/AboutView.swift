//
//  AboutView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-06.
//

import SwiftUI

struct AboutView: View {
    @Binding var show: Bool
    @State var currentOffsetX: CGFloat = 0
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    let year = String(Calendar.current.component(.year, from: Date()))
    
    var body: some View {
        ZStack (alignment: .top){
            HStack(alignment: .center) {
                Button(action: {
                    withAnimation {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        show = false
                    }
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
                Text("For YRDSB")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(TAColor.secondaryTextColor)
                    .padding(3)
                Text("Version \(version)\n© \(year) York Wei")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(TAColor.primaryTextColor)
                    .padding(3)
                    .multilineTextAlignment(.center)
                Spacer()
                Text("This app is not affiliated with the TeachAssist Foundation or YRDSB. Use at own discretion.")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(TAColor.secondaryTextColor)
                    .multilineTextAlignment(.center)
            }
            .padding([.top, .bottom, .leading, .trailing], TAPadding.viewEdgePadding)
        }
        .ignoresSafeArea()
        .background(TAColor.backgroundColor)
        .offset(x: currentOffsetX)
        .gesture(DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        if value.translation.width > 0 {
                            currentOffsetX = value.translation.width
                        }
                    }
                    .onEnded { value in
                        if currentOffsetX > UIScreen.main.bounds.width / 2 || value.predictedEndLocation.x - value.location.x > 250 {
                            withAnimation {
                                currentOffsetX = UIScreen.main.bounds.width
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.show = false
                                }
                            }
                        } else {
                            withAnimation {
                                currentOffsetX = 0
                            }
                        }
                    })
    }
}
