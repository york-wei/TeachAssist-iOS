//
//  MagnifierRect.swift
//  
//
//  Created by Samu András on 2020. 03. 04..
//

import SwiftUI

public struct MagnifierRect: View {
    @Binding var currentNumber: Double
    var valueSpecifier:String
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    public var body: some View {
        ZStack{
            Text("\(self.currentNumber, specifier: valueSpecifier)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .offset(x: 0, y: 0)
                .foregroundColor(TAColor.primaryTextColor)
//            if (self.colorScheme == .dark ){
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(Color.white, lineWidth: self.colorScheme == .dark ? 2 : 0)
//                    .frame(width: 60, height: 170)
//            }else{
//                RoundedRectangle(cornerRadius: 16)
//                    .offset(y: -30)
//                    .frame(width: 60, height: 170)
//                    .foregroundColor(Color.white)
//                    .shadow(color: TAColor.dropShadowColor, radius: 5, x: 0, y: 2)
//                    .blendMode(.multiply)
//            }
        }
    }
}
