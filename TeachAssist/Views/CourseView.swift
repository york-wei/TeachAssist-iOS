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
            
        }
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

extension CourseView {
    class ViewModel: ObservableObject {
        @Published var course: Course
        
        init(course: Course) {
            self.course = course
        }
        
    }
}
