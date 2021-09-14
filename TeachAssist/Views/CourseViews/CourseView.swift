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
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // Top bar
            HStack(alignment: .center) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation {
                        self.show = false
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
            Picker("Options", selection: $viewModel.selectedTab) {
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
            switch viewModel.selectedTab {
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
                    if viewModel.getCourse().evaluations.count == 0 {
                        Text("No Evaluations Available")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(TAColor.primaryTextColor)
                    } else {
                        ForEach(viewModel.getCourse().evaluations.reversed()) { evaluation in
                            EvaluationView(viewModel: .init(evaluation: evaluation,
                                                            editing: viewModel.editing,
                                                            didTapDelete: viewModel.didTapDeleteEvaluation(evaluation:),
                                                            didTapEdit: viewModel.didTapEditEvaluation(evaluation:)))
                        }
                        .padding(.bottom, 15)
                    }
                }
                .padding([.top, .trailing, .leading], TAPadding.viewEdgePadding)
            case .trends:
                TrendView(course: viewModel.getCourse())
            case .breakdown:
                BreakdownView(course: viewModel.getCourse())
                    .padding([.top, .bottom, .trailing, .leading], TAPadding.viewEdgePadding)
            }
            VStack {}.sheet(isPresented: $viewModel.showAddEvaluationView) {
                AddEvaluationView(show: $viewModel.showAddEvaluationView,
                                  addEvaluation: viewModel.addEvaluation(evaluation:))
            }
            VStack {}.sheet(isPresented: $viewModel.showEditEvaluationView) {
                EditEvaluationView(show: $viewModel.showEditEvaluationView,
                                   evaluation: viewModel.evaluationForEditing,
                                   editEvaluation: viewModel.editEvaluation(evaluation:))
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
        @Published var selectedTab: SelectedTab = .evaluations
        @Published var editCourse: Course = Course()
        @Published var editing: Bool = false
        @Published var showAddEvaluationView = false
        @Published var showEditEvaluationView = false
        var evaluationForEditing: Evaluation = Evaluation()
        
        init(course: Course) {
            self.course = course
        }
        
        func didTapEdit() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            selectedTab = .evaluations
            editing.toggle()
            if editing {
                editCourse = Course(course: course)
            }
        }
        
        func getCourse() -> Course {
            return editing ? editCourse : course
        }
        
        func didTapAddEvaluation() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showAddEvaluationView = true
        }
        
        func didTapEditEvaluation(evaluation: Evaluation) {
            evaluationForEditing = evaluation
            showEditEvaluationView = true
        }
        
        func didTapDeleteEvaluation(evaluation: Evaluation) {
            deleteEvaluation(evaluation: evaluation)
        }
        
        func addEvaluation(evaluation: Evaluation) {
            getCourse().evaluations.append(evaluation)
            getCourse().updateAverageForEstimate()
            objectWillChange.send()
        }
        
        func editEvaluation(evaluation: Evaluation) {
            guard let index = getCourse().evaluations.firstIndex(where: { $0.id == evaluation.id }) else { return }
            getCourse().evaluations[index] = evaluation
            getCourse().updateAverageForEstimate()
            objectWillChange.send()
        }
        
        func deleteEvaluation(evaluation: Evaluation) {
            getCourse().evaluations.removeAll(where: { $0.id == evaluation.id })
            getCourse().updateAverageForEstimate()
            objectWillChange.send()
        }
        
    }
}
