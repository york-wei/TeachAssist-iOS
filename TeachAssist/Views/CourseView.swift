//
//  CourseView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-03.
//

import SwiftUI

struct CourseView: View {
    @Binding var show: Bool
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
        }
        .background(TAColor.backgroundColor)
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
