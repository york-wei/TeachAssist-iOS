//
//  EvaluationView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-04.
//

import SwiftUI

struct EvaluationView: View {
    var evaluation: Evaluation
    var editing: Bool
    @State var expanded = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(20)
                .shadow(color: TAColor.dropShadowColor, radius: 5, x: 0, y: 2)
            VStack(alignment: .leading, spacing: 5) {
                
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.leading, .trailing], 28)
            .padding([.top, .bottom], 38)
        }
        .foregroundColor(TAColor.foregroundColor)
    }
}
