//
//  EvaluationView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-04.
//

import SwiftUI

struct EvaluationView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(20)
                .shadow(color: TAColor.dropShadowColor, radius: 5, x: 0, y: 2)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    if let name = viewModel.evaluation.name {
                        Text(name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(TAColor.primaryTextColor)
                    }
                    Spacer()
                    Text(viewModel.evaluation.overall != nil ? String(format: "%.1f%%", viewModel.evaluation.overall!) : "Formative")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(TAColor.primaryTextColor)
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                        .background(TAColor.highlightColor)
                        .cornerRadius(5)
                }
                ProgressBarView(percentage: viewModel.evaluation.overall ?? 0, animate: .constant(false))
                    .padding(.top, 5)
                if viewModel.expanded && !viewModel.editing {
                    Group {
                        HStack {
                            Text("K/U (\(viewModel.getWeight(section: viewModel.evaluation.knowledge)))")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                            Spacer()
                            if let score = viewModel.evaluation.knowledge.score {
                                Text("(\(score))")
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .foregroundColor(TAColor.primaryTextColor)
                            }
                            Text(viewModel.getPercent(section: viewModel.evaluation.knowledge))
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                        }
                        .padding(.top, 5)
                        ProgressBarView(percentage: viewModel.evaluation.knowledge.percent ?? 0, animate: .constant(false))
                            .padding(.top, 5)
                        HStack {
                            Text("T (\(viewModel.getWeight(section: viewModel.evaluation.thinking)))")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                            Spacer()
                            if let score = viewModel.evaluation.thinking.score {
                                Text("(\(score))")
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .foregroundColor(TAColor.primaryTextColor)
                            }
                            Text(viewModel.getPercent(section: viewModel.evaluation.thinking))
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                        }
                        .padding(.top, 5)
                        ProgressBarView(percentage: viewModel.evaluation.thinking.percent ?? 0, animate: .constant(false))
                            .padding(.top, 5)
                        HStack {
                            Text("C (\(viewModel.getWeight(section: viewModel.evaluation.communication)))")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                            Spacer()
                            if let score = viewModel.evaluation.communication.score {
                                Text("(\(score))")
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .foregroundColor(TAColor.primaryTextColor)
                            }
                            Text(viewModel.getPercent(section: viewModel.evaluation.communication))
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                        }
                        .padding(.top, 5)
                        ProgressBarView(percentage: viewModel.evaluation.communication.percent ?? 0, animate: .constant(false))
                            .padding(.top, 5)
                        HStack {
                            Text("A (\(viewModel.getWeight(section: viewModel.evaluation.application)))")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                            Spacer()
                            if let score = viewModel.evaluation.application.score {
                                Text("(\(score))")
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .foregroundColor(TAColor.primaryTextColor)
                            }
                            Text(viewModel.getPercent(section: viewModel.evaluation.application))
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                        }
                        .padding(.top, 5)
                        ProgressBarView(percentage: viewModel.evaluation.application.percent ?? 0, animate: .constant(false))
                            .padding(.top, 5)
                        HStack {
                            Text("O/F (\(viewModel.getWeight(section: viewModel.evaluation.final)))")
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                            Spacer()
                            if let score = viewModel.evaluation.final.score {
                                Text("(\(score))")
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .foregroundColor(TAColor.primaryTextColor)
                            }
                            Text(viewModel.getPercent(section: viewModel.evaluation.final))
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                        }
                            .padding(.top, 5)
                        ProgressBarView(percentage: viewModel.evaluation.final.percent ?? 0, animate: .constant(false))
                            .padding(.top, 5)
                    }
                }
            }
            .opacity(viewModel.editing ? 0 : 1)
            .fixedSize(horizontal: false, vertical: true)
            .padding([.leading, .trailing], 28)
            .padding([.top, .bottom], 38)
            HStack {
                if let name = viewModel.evaluation.name {
                    Text(name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(TAColor.primaryTextColor)
                }
                Spacer()
                Button(action: {
                    viewModel.didTapEditEvaluation()
                }) {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .foregroundColor(TAColor.primaryTextColor)
                }
                Button(action: {
                    viewModel.didTapDeleteEvaluation()
                }) {
                    Image(systemName: "trash.circle")
                        .font(.title2)
                        .foregroundColor(Color.red)
                }
            }
            .opacity(viewModel.editing ? 1 : 0)
            .fixedSize(horizontal: false, vertical: true)
            .padding([.leading, .trailing], 28)
            .padding([.top, .bottom], 38)
        }
        .foregroundColor(TAColor.foregroundColor)
        .animation(.spring().speed(2))
        .onTapGesture {
            viewModel.didTapEvaluation()
        }
    }
}

extension EvaluationView {
    class ViewModel: ObservableObject {
        var evaluation: Evaluation
        var editing: Bool
        var delete: (Evaluation) -> Void
        @Published var expanded = false
        
        init(evaluation: Evaluation, editing: Bool, delete: @escaping((Evaluation) -> Void)) {
            self.evaluation = evaluation
            self.editing = editing
            self.delete = delete
        }
        
        func getWeight(section: Section) -> String {
            if let weight = section.weight,
               weight > 0 {
                return String(format: "Weight: %.1f", weight)
            }
            return "No Weight"
        }
        
        func getPercent(section: Section) -> String {
            if let percent = section.percent {
                return String(format: "%.1f%%", percent)
            }
            return "No Mark"
        }
        
        func didTapEvaluation() {
            if !editing {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation {
                    expanded.toggle()
                }
            }
        }
        
        func didTapEditEvaluation() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        
        func didTapDeleteEvaluation() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            delete(evaluation)
        }
    }
}
