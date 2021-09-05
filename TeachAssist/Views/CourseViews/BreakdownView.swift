//
//  BreakdownView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-05.
//

import SwiftUI

struct BreakdownView: View {
    let course: Course
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(20)
                .shadow(color: TAColor.dropShadowColor, radius: 5, x: 0, y: 2)
            VStack(alignment: .leading, spacing: 5) {
                Text("Section Averages")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(TAColor.primaryTextColor)
                    .padding(.bottom, 10)
                Group {
                    HStack {
                        Text("K/U (\(course.knowledge.getWeightString()))")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                        Spacer()
                        Text(course.knowledge.getPercentString())
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                    }
                    .padding(.top, 5)
                    ProgressBarView(percentage: course.knowledge.percent ?? 0, animate: .constant(false))
                        .padding(.top, 5)
                }
                Group {
                    HStack {
                        Text("T (\(course.thinking.getWeightString()))")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                        Spacer()

                        Text(course.thinking.getPercentString())
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                    }
                    .padding(.top, 5)
                    ProgressBarView(percentage: course.thinking.percent ?? 0, animate: .constant(false))
                        .padding(.top, 5)
                }
                Group {
                    HStack {
                        Text("C (\(course.communication.getWeightString()))")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                        Spacer()
                        Text(course.communication.getPercentString())
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                    }
                    .padding(.top, 5)
                    ProgressBarView(percentage: course.communication.percent ?? 0, animate: .constant(false))
                        .padding(.top, 5)
                }
                Group {
                    HStack {
                        Text("A (\(course.application.getWeightString()))")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                        Spacer()
                        Text(course.application.getPercentString())
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                    }
                    .padding(.top, 5)
                    ProgressBarView(percentage: course.application.percent ?? 0, animate: .constant(false))
                        .padding(.top, 5)
                }
                Group {
                    HStack {
                        Text("O (\(course.other.getWeightString()))")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                        Spacer()
                        Text(course.other.getPercentString())
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                    }
                    .padding(.top, 5)
                    ProgressBarView(percentage: course.other.percent ?? 0, animate: .constant(false))
                        .padding(.top, 5)
                }
                Group {
                    HStack {
                        Text("F (\(course.final.getWeightString()))")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                        Spacer()
                        Text(course.final.getPercentString())
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                    }
                    .padding(.top, 5)
                    ProgressBarView(percentage: course.final.percent ?? 0, animate: .constant(false))
                        .padding(.top, 5)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding([.leading, .trailing], 28)
            .padding([.top, .bottom], 38)
        }
        .foregroundColor(TAColor.foregroundColor)
    }
}
