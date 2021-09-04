//
//  CourseView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-03.
//

import SwiftUI

enum SelectedTab {
    case evaluations
    case trends
    case breakdown
}

struct CourseView: View {
    @Binding var show: Bool
    @State var currentOffsetX: CGFloat = 0
    @State var selectedTab = SelectedTab.evaluations
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // Top bar
            HStack(alignment: .center) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation {
                        currentOffsetX = UIScreen.main.bounds.width
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.show = false
                        }
                    }
                }) {
                    SmallButtonView(imageName: "chevron.backward")
                }
                .buttonStyle(TAButtonStyle(scale: 1.07))
                Spacer()
                if let code = viewModel.getCourse().code {
                    Text(code)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(TAColor.primaryTextColor)
                }
                Spacer()
                Button(action: {
                    viewModel.didTapEdit()
                }) {
                    SmallButtonView(imageName: viewModel.editing ? "pencil.slash" : "pencil")
                }
                .buttonStyle(TAButtonStyle(scale: 1.07))
            }
            .padding(.top, 50)
            .padding([.trailing, .leading], TAPadding.viewEdgePadding)
            // Course average ring
            if let average = viewModel.getCourse().average {
                RingView(percentage: average, animate: .constant(false))
                    .padding(10)
                Text(viewModel.editing ? "Predicted Course Average" : "Course Average")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(TAColor.primaryTextColor)
                    .padding(.top, 10)
            }
            // Picker
            Picker("Options", selection: $selectedTab) {
                Text("Evaluations")
                    .tag(SelectedTab.evaluations)
                Text("Trends")
                    .tag(SelectedTab.trends)
                Text("Breakdown")
                    .tag(SelectedTab.breakdown)
            }
                .pickerStyle(SegmentedPickerStyle())
                .animation(.none)
                .padding([.top, .trailing, .leading], TAPadding.viewEdgePadding)
            // Selected view
            switch selectedTab {
            case .evaluations:
                VStack {
                    if viewModel.editing {
                        Button(action: {
                            viewModel.didTapAddEvaluation()
                        }) {
                            AddEvaluationButtonView()
                        }
                        .buttonStyle(TAButtonStyle(scale: 1.02))
                        .padding(.bottom, 15)
                    }
                    ForEach(viewModel.getCourse().evaluations.reversed()) { evaluation in
                        EvaluationView(viewModel: .init(evaluation: evaluation,
                                                        editing: viewModel.editing,
                                                        didTapDelete: viewModel.didTapDeleteEvaluation(evaluation:),
                                                        didTapEdit: viewModel.didTapEditEvaluation(evaluation:)))
                    }
                    .padding(.bottom, 15)
                }
                .padding([.top, .trailing, .leading], TAPadding.viewEdgePadding)
            case .trends:
                EmptyView()
            case .breakdown:
                EmptyView()
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
        .sheet(isPresented: $viewModel.showAddEvaluationView) {
            Text("add")
        }
        .sheet(isPresented: $viewModel.showEditEvaluationView) {
            Text("edit")
        }
    }
}

extension CourseView {
    class ViewModel: ObservableObject {
        @Published var course: Course
        @Published var editCourse: Course = Course()
        @Published var editing: Bool = false
        @Published var showAddEvaluationView = false
        @Published var showEditEvaluationView = false
        
        init(course: Course) {
            self.course = course
        }
        
        func didTapEdit() {
            editing.toggle()
            if editing {
                editCourse = Course(course: course)
            }
        }
        
        func getCourse() -> Course {
            return editing ? editCourse : course
        }
        
        func didTapAddEvaluation() {
            showAddEvaluationView = true
        }
        
        func didTapEditEvaluation(evaluation: Evaluation) {
            showEditEvaluationView = true
        }
        
        func didTapDeleteEvaluation(evaluation: Evaluation) {
            deleteEvaluation(evaluation: evaluation)
        }
        
        private func addEvaluation(evaluation: Evaluation) {
            getCourse().evaluations.append(evaluation)
            objectWillChange.send()
        }
        
        private func editEvaluation(evaluation: Evaluation) {
            
        }
        
        private func deleteEvaluation(evaluation: Evaluation) {
            getCourse().evaluations.removeAll(where: { $0.id == evaluation.id })
            objectWillChange.send()
        }
        
    }
}
