//
//  AddEvaluationButtonView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-04.
//

import SwiftUI

struct AddEvaluationButtonView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(TAColor.foregroundColor)
                .cornerRadius(20)
                .shadow(color: TAColor.dropShadowColor, radius: 5, x: 0, y: 2)
            VStack(alignment: .center, spacing: 10) {
                Image(systemName: "plus")
                    .font(.title3)
                    .foregroundColor(TAColor.primaryTextColor)
                Text("Add Evaluation")
                    .font(.subheadline)
                    .foregroundColor(TAColor.primaryTextColor)
                    .fontWeight(.semibold)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.top, .bottom], 18)
        }
    }
}
