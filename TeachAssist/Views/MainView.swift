//
//  MainView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var userState: UserState
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            // Top bar
            HStack(alignment: .center) {
                Button(action: {
                    
                }) {
                    SmallButtonView(imageName: "line.horizontal.3.decrease")
                }
                .buttonStyle(SmallButtonStyle())
                .disabled(viewModel.loading)
                Spacer()
                Text(userState.username)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(TAColor.primaryTextColor)
                Spacer()
                Button(action: {
                    
                }) {
                    SmallButtonView(imageName: "person.fill")
                }
                .buttonStyle(SmallButtonStyle())
                .disabled(viewModel.loading)
            }
            ScrollView(showsIndicators: false) {
                RefreshControl(coordinateSpace: .named("MainScrollViewRefresh")) {
                    viewModel.didPullToRefresh()
                }
                if let overallAverage = viewModel.overallAverage {
                    RingView(percentage: overallAverage, animate: $viewModel.loading)
                        .padding(10)
                    Text("Term Average")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(TAColor.primaryTextColor)
                        .padding(10)
                }
//                    ForEach(viewModel.courses) { course in
//                        if let code = course.code {
//                            Text(code)
//                        }
//                    }
            }.coordinateSpace(name: "MainScrollViewRefresh")
        }
        .padding(TAPadding.viewEdgePadding)
        .alert(isPresented: $viewModel.showError, content: {
            Alert(title: Text(viewModel.currentError.description),
                  message: Text("Your marks could not be updated."),
                  dismissButton: .default(Text("OK")) {
                    self.viewModel.loading = false
                  })
        })
    }
}

extension MainView {
    class ViewModel: ObservableObject {
        let userState: UserState
        @Published var courses: [Course]
        @Published var overallAverage: Double?
        @Published var loading: Bool = true
        @Published var showError: Bool = false
        var currentError: TAError = TAError.unknownError
        
        init(userState: UserState) {
            self.userState = userState
            self.courses = PersistenceController.shared.fetchSavedCourses()
            updateOverallAverage()
            // Refresh if user is not coming from login
            if !userState.fromLogin {
                refresh()
            } else {
                userState.fromLogin = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.loading = false
                }
            }
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
        
        func didPullToRefresh() {
            if !loading {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                refresh()
            }
        }
        
        private func refresh() {
            loading = true
            TAService.shared.authenticateStudent(username: userState.username, password: userState.password, completion: { result in
                switch result {
                case .failure(let authenticationError):
                    self.handleError(error: authenticationError)
                case .success(let authenticationResponse):
                    self.handleAuthenticationSuccess(response: authenticationResponse)
                }
            })
        }
        
        private func handleError(error: Error) {
            currentError = TAError.getTAError(error)
            DispatchQueue.main.async {
                self.showError = true
            }
        }
        
        private func handleAuthenticationSuccess(response: AuthenticationResponse) {
            do {
                let courses = try TAParser.shared.parseCourseList(html: response.dataString)
                var thrownError: Error? = nil
                let group = DispatchGroup()
                for course in courses where course.link != nil {
                    group.enter()
                    DispatchQueue.global(qos: .userInteractive).async {
                        TAService.shared.fetchCourse(link: course.link!,
                                                     sessionToken: response.sessionToken,
                                                     studentId: response.studentId) { result in
                            switch result {
                            case .failure(let courseFetchError):
                                thrownError = courseFetchError
                            case .success(let courseFetchResponse):
                                do {
                                    try TAParser.shared.parseCourse(course: course, html: courseFetchResponse.dataString)
                                } catch let error {
                                    thrownError = error
                                }
                            }
                            group.leave()
                        }
                    }
                }
                group.notify(queue: .main) {
                    // all course fetches finished, check for errors
                    if let error = thrownError {
                        self.handleError(error: TAError.getTAError(error))
                        return
                    }
                    // TODO: update course data with new fetch
                    DispatchQueue.main.async {
                        PersistenceController.shared.saveCourses(courses: courses)
                        self.courses = courses
                        self.loading = false
                        print("successful refresh")
                    }
                }
            } catch let error {
                handleError(error: TAError.getTAError(error))
            }
        }
    }
}
