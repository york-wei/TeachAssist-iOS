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
                            .fixedSize(horizontal: false, vertical: true)
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
                EvaluationProgressBarView(percentage: viewModel.evaluation.overall ?? 0)
                    .padding(.top, 5)
                if viewModel.expanded && !viewModel.editing {
                    Group {
                        HStack {
                            Text("K/U (\(viewModel.evaluation.knowledge.getWeightString()))")
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
                            Text(viewModel.evaluation.knowledge.getPercentString())
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                        }
                        .padding(.top, 5)
                        EvaluationProgressBarView(percentage: viewModel.evaluation.knowledge.percent ?? 0)
                            .padding(.top, 5)
                        HStack {
                            Text("T (\(viewModel.evaluation.thinking.getWeightString()))")
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
                            Text(viewModel.evaluation.thinking.getPercentString())
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                        }
                        .padding(.top, 5)
                        EvaluationProgressBarView(percentage: viewModel.evaluation.thinking.percent ?? 0)
                            .padding(.top, 5)
                        HStack {
                            Text("C (\(viewModel.evaluation.communication.getWeightString()))")
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
                            Text(viewModel.evaluation.communication.getPercentString())
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                        }
                        .padding(.top, 5)
                        EvaluationProgressBarView(percentage: viewModel.evaluation.communication.percent ?? 0)
                            .padding(.top, 5)
                        HStack {
                            Text("A (\(viewModel.evaluation.application.getWeightString()))")
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
                            Text(viewModel.evaluation.application.getPercentString())
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                        }
                        .padding(.top, 5)
                        EvaluationProgressBarView(percentage: viewModel.evaluation.application.percent ?? 0)
                            .padding(.top, 5)
                        HStack {
                            Text("O/F (\(viewModel.evaluation.final.getWeightString()))")
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
                            Text(viewModel.evaluation.final.getPercentString())
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .foregroundColor(TAColor.primaryTextColor)
                        }
                        .padding(.top, 5)
                        EvaluationProgressBarView(percentage: viewModel.evaluation.final.percent ?? 0)
                        .padding(.top, 5)
                    }
                    if let feedback = viewModel.evaluation.feedback {
                        Text(feedback)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(TAColor.primaryTextColor)
                            .fixedSize(horizontal: false, vertical: true)
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
                        .fixedSize(horizontal: false, vertical: true)
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
        var didTapDelete: (Evaluation) -> Void
        var didTapEdit: (Evaluation) -> Void
        @Published var expanded = false
        
        init(evaluation: Evaluation,
             editing: Bool,
             didTapDelete: @escaping((Evaluation) -> Void),
             didTapEdit: @escaping((Evaluation) -> Void)) {
            self.evaluation = evaluation
            self.editing = editing
            self.didTapDelete = didTapDelete
            self.didTapEdit = didTapEdit
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
            didTapEdit(evaluation)
        }
        
        func didTapDeleteEvaluation() {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            didTapDelete(evaluation)
        }
    }
}
