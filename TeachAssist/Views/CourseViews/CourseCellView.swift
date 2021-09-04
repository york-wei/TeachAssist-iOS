//
//  CourseCellView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-03.
//

import SwiftUI

struct CourseCellView: View {
    let course: Course
    @Binding var animate : Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(20)
                .shadow(color: TAColor.dropShadowColor, radius: 5, x: 0, y: 2)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    if let code = course.code {
                        if let name = course.name {
                            Text("\(code): \(name)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(TAColor.primaryTextColor)
                                .lineLimit(1)
                        } else {
                            Text(code)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(TAColor.primaryTextColor)
                        }
                    }
                    Spacer()
                }
                HStack {
                    if let period = course.period {
                        Text("Period \(period)")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                    }
                    if let room = course.room {
                        Text("Room \(room)")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                    }
                    Spacer()
                    if let average = course.average {
                        Text(String(format: "%.1f%%", average))
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(TAColor.primaryTextColor)
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                            .padding(.leading, 5)
                            .padding(.trailing, 5)
                            .background(TAColor.highlightColor)
                            .cornerRadius(5)
                    }
                }
                if let average = course.average {
                    ProgressBarView(percentage: average, animate: $animate)
                        .padding(.top, 5)
                } else {
                    Text("Current Mark Unavailable")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(TAColor.primaryTextColor)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.leading, .trailing], 28)
            .padding([.top, .bottom], 38)
            .redacted(reason: animate ? .placeholder : [])
        }
        .foregroundColor(TAColor.foregroundColor)
    }
}
