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
        NavigationView {
            // MARK: - Main Course List
            ScrollView(showsIndicators: false) {
                RefreshControl(coordinateSpace: .named("MainScrollViewRefresh")) {
                    viewModel.didPullToRefresh()
                }
                // Top bar
                HStack(alignment: .center) {
                    Button(action: {
                        viewModel.didTapSettings()
                    }) {
                        SmallButtonView(imageName: "line.horizontal.3.decrease")
                    }
                    .buttonStyle(TAButtonStyle(scale: 1.07))
                    .disabled(viewModel.loading)
                    Spacer()
                    Text(userState.username)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(TAColor.primaryTextColor)
                    Spacer()
                    Button(action: {
                        viewModel.didTapLinks()
                    }) {
                        SmallButtonView(imageName: "person")
                    }
                    .buttonStyle(TAButtonStyle(scale: 1.07))
                    .disabled(viewModel.loading)
                }
                .padding([.trailing, .leading], TAPadding.viewEdgePadding)
                if let overallAverage = viewModel.overallAverage {
                    RingView(percentage: overallAverage, animate: $viewModel.loading)
                        .padding(10)
                    Text("Term Average")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(TAColor.primaryTextColor)
                        .padding(.top, 10)
                        .redacted(reason: viewModel.loading ? .placeholder : [])
                }
                VStack(spacing: 15) {
                    if viewModel.courses.count == 0 {
                        Text("No Courses Available")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(TAColor.primaryTextColor)
                    } else {
                        ForEach(viewModel.courses) { course in
                            if course.link != nil {
                                NavigationLink(destination: CourseView(viewModel: .init(course: viewModel.currentCourse))) {
                                    CourseCellView(course: course, animate: $viewModel.loading)
                                }
                                .simultaneousGesture(TapGesture().onEnded {
                                    viewModel.didTapCourse(course: course)
                                })
                                .buttonStyle(TAButtonStyle(scale: 1.02))
                            } else {
                                CourseCellView(course: course, animate: $viewModel.loading)
                            }
                        }
                    }
                }
                .padding([.top, .bottom, .trailing, .leading], TAPadding.viewEdgePadding)
            }
            .coordinateSpace(name: "MainScrollViewRefresh")
            .navigationBarHidden(true)
        }
        .ignoresSafeArea()
        .alert(isPresented: $viewModel.showError, content: {
            Alert(title: Text(viewModel.currentError.description),
                  message: Text("Your marks could not be updated."),
                  dismissButton: .default(Text("OK")) {
                    withAnimation {
                        self.viewModel.loading = false
                    }
                  })
        })
        .sheet(isPresented: $viewModel.showLinksView) {
            LinksView(show: $viewModel.showLinksView,
                      viewModel: .init(userState: userState))
        }
        .sheet(isPresented: $viewModel.showSettingsView) {
            SettingsView(show: $viewModel.showSettingsView,
                         viewModel: .init(userState: userState))
        }
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
        var currentCourse: Course = Course()
        @Published var showLinksView: Bool = false
        @Published var showSettingsView: Bool = false
        
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
                    withAnimation {
                        self.loading = false
                    }
                }
            }
        }
        
        func didTapSettings() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showSettingsView = true
        }
        
        func didTapLinks() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showLinksView = true
        }
        
        func didPullToRefresh() {
            if !loading {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                refresh()
            }
        }
        
        func didTapCourse(course: Course) {
            guard course.link != nil else { return }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            currentCourse = course
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
        
        private func refresh() {
            withAnimation {
                loading = true
            }
            guard !userState.isDemoUser() else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        self.loading = false
                    }
                }
                return
            }
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
                var newCourses = try TAParser.shared.parseCourseList(html: response.dataString)
                var thrownError: Error? = nil
                let group = DispatchGroup()
                for course in newCourses where course.link != nil {
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
                    // if the new courses are not the same as old courses, reset persisted courses
                    if self.courses == newCourses {
                        for (i, course) in newCourses.enumerated() where course.link == nil {
                            if self.courses[i].link != nil {
                                // replace new course that is closed with old course that is open
                                newCourses[i] = self.courses[i]
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        PersistenceController.shared.saveCourses(courses: newCourses)
                        self.courses = newCourses
                        self.updateOverallAverage()
                        withAnimation {
                            self.loading = false
                        }
                        print("successful refresh")
                    }
                }
            } catch let error {
                handleError(error: TAError.getTAError(error))
            }
        }
    }
}
