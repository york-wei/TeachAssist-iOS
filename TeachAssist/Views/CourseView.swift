//
//  CourseView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-03.
//

import SwiftUI

struct CourseView: View {
    @Binding var show: Bool
    @State var currentOffsetX: CGFloat = 0
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // Top bar
            HStack(alignment: .center) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation {
                        show = false
                    }
                }) {
                    SmallButtonView(imageName: "chevron.backward")
                }
                .buttonStyle(TAButtonStyle(scale: 1.07))
                Spacer()
                if let code = viewModel.course.code {
                    Text(code)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(TAColor.primaryTextColor)
                }
                Spacer()
                Button(action: {
                    
                }) {
                    SmallButtonView(imageName: "pencil")
                }
                .buttonStyle(TAButtonStyle(scale: 1.07))
            }
            .padding(.top, 40)
            .padding([.trailing, .leading], TAPadding.viewEdgePadding)
            if let average = viewModel.course.average {
                RingView(percentage: average, animate: .constant(false))
                    .padding(10)
                Text("Course Average")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(TAColor.primaryTextColor)
                    .padding(.top, 10)
            }
        }
        .background(TAColor.backgroundColor.ignoresSafeArea())
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

extension CourseView {
    class ViewModel: ObservableObject {
        @Published var course: Course
        
        init(course: Course) {
            self.course = course
        }
        
    }
}
