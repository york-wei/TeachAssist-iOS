//
//  MainView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-25.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            RefreshControl(coordinateSpace: .named("MainScrollViewRefresh")) {
                print("refreshed")
            }
            VStack {
                ForEach(viewModel.courses) { course in
                    if let code = course.code {
                        Text(code)
                    }
                }
            }
        }.coordinateSpace(name: "MainScrollViewRefresh")
    }
}

extension MainView {
    class ViewModel: ObservableObject {
        let userState: UserState
        @Published var courses: [Course]
        @Published var overallAverage: Double?
        
        init(userState: UserState) {
            self.userState = userState
            self.courses = PersistenceController.shared.fetchSavedCourses()
            updateOverallAverage()
        }
        
        private func updateOverallAverage() {
            var count: Int = 0
            var sum: Double = 0
            for course in courses where course.average != nil {
                count += 1
                sum += course.average!
            }
            if count > 0 {
                overallAverage = sum / Double(count)
            }
        }
    }
}
