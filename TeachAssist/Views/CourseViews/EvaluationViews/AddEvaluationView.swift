//
//  AddEvaluationView.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-04.
//

// NEEDS REFACTORING :)

import SwiftUI

struct AddEvaluationView: View {
    @Binding var show: Bool
    var addEvaluation: (Evaluation) -> Void
    
    @State var hasKnowledge = false
    @State var hasThinking = false
    @State var hasCommunication = false
    @State var hasApplication = false
    @State var hasOther = false
    @State var hasFinals = false
    
    @State var kPercent = 0.0
    @State var tPercent = 0.0
    @State var cPercent = 0.0
    @State var aPercent = 0.0
    @State var oPercent = 0.0
    @State var fPercent = 0.0
    
    @State var kWeight = 0.0
    @State var tWeight = 0.0
    @State var cWeight = 0.0
    @State var aWeight = 0.0
    @State var oWeight = 0.0
    @State var fWeight = 0.0
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // Top bar
            HStack(alignment: .center) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    show = false
                }) {
                    SmallButtonView(imageName: "xmark")
                }
                .buttonStyle(TAButtonStyle(scale: 1.07))
                Spacer()
                Text("New Evaluation")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(TAColor.primaryTextColor)
                Spacer()
                Button(action: {
                    let evaluation = Evaluation()
                    evaluation.name = "New Evaluation"
                    if hasKnowledge {
                        evaluation.knowledge = Section(type: .knowledge, percent: kPercent, weight: kWeight)
                    }
                    if hasThinking {
                        evaluation.thinking = Section(type: .thinking, percent: tPercent, weight: tWeight)
                    }
                    if hasCommunication {
                        evaluation.communication = Section(type: .communication, percent: cPercent, weight: cWeight)
                    }
                    if hasApplication {
                        evaluation.application = Section(type: .application, percent: aPercent, weight: aWeight)
                    }
                    if hasOther {
                        evaluation.other = Section(type: .other, percent: oPercent, weight: oWeight)
                    }
                    if hasFinals {
                        evaluation.final = Section(type: .final, percent: fPercent, weight: fWeight)
                    }
                    addEvaluation(evaluation)
                    show = false
                }) {
                    SmallButtonView(imageName: "checkmark")
                }
                .buttonStyle(TAButtonStyle(scale: 1.07))
            }
            .padding(.top, 50)
            .padding([.trailing, .leading], TAPadding.viewEdgePadding)
            VStack(spacing: 15) {
                VStack(spacing: 5) {
                    HStack {
                        Text("Knowledge/Understanding")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasKnowledge ? 1 : 0.6)
                        Spacer()
                        Toggle("", isOn: $hasKnowledge)
                            .toggleStyle(SwitchToggleStyle(tint: TAColor.themeColor))
                            .labelsHidden()
                            .onTapGesture {
                                kPercent = 0
                                kWeight = 0
                            }
                    }
                    HStack {
                        Text(hasKnowledge ? String(format: "Percentage: %.1f%%", Double(kPercent)) : "Percentage")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasKnowledge ? 1 : 0.6)
                        Spacer()
                    }
                    Slider(value: $kPercent, in: 0...100, step: 0.1)
                        .toggleStyle(SwitchToggleStyle(tint: TAColor.themeColor))
                        .accentColor(TAColor.themeColor)
                        .disabled(!hasKnowledge)
                    HStack {
                        Text(hasKnowledge ? String(format: "Weight: %.1f", Double(kWeight)) : "Weight")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasKnowledge ? 1 : 0.6)
                        Spacer()
                    }
                    Slider(value: $kWeight, in: 0...100, step: 0.1)
                        .accentColor(TAColor.themeColor)
                        .disabled(!hasKnowledge)
                }
                VStack(spacing: 5) {
                    HStack {
                        Text("Thinking")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasThinking ? 1 : 0.6)
                        Spacer()
                        Toggle("", isOn: $hasThinking)
                            .toggleStyle(SwitchToggleStyle(tint: TAColor.themeColor))
                            .labelsHidden()
                            .onTapGesture {
                                tPercent = 0
                                tWeight = 0
                            }
                    }
                    HStack {
                        Text(hasThinking ? String(format: "Percentage: %.1f%%", Double(tPercent)) : "Percentage")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasThinking ? 1 : 0.6)
                        Spacer()
                    }
                    Slider(value: $tPercent, in: 0...100, step: 0.1)
                        .toggleStyle(SwitchToggleStyle(tint: TAColor.themeColor))
                        .accentColor(TAColor.themeColor)
                        .disabled(!hasThinking)
                    HStack {
                        Text(hasThinking ? String(format: "Weight: %.1f", Double(tWeight)) : "Weight")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasThinking ? 1 : 0.6)
                        Spacer()
                    }
                    Slider(value: $tWeight, in: 0...100, step: 0.1)
                        .accentColor(TAColor.themeColor)
                        .disabled(!hasThinking)
                }
                VStack(spacing: 5) {
                    HStack {
                        Text("Communication")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasCommunication ? 1 : 0.6)
                        Spacer()
                        Toggle("", isOn: $hasCommunication)
                            .toggleStyle(SwitchToggleStyle(tint: TAColor.themeColor))
                            .labelsHidden()
                            .onTapGesture {
                                cPercent = 0
                                cWeight = 0
                            }
                    }
                    HStack {
                        Text(hasCommunication ? String(format: "Percentage: %.1f%%", Double(cPercent)) : "Percentage")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasCommunication ? 1 : 0.6)
                        Spacer()
                    }
                    Slider(value: $cPercent, in: 0...100, step: 0.1)
                        .toggleStyle(SwitchToggleStyle(tint: TAColor.themeColor))
                        .accentColor(TAColor.themeColor)
                        .disabled(!hasCommunication)
                    HStack {
                        Text(hasCommunication ? String(format: "Weight: %.1f", Double(cWeight)) : "Weight")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasCommunication ? 1 : 0.6)
                        Spacer()
                    }
                    Slider(value: $cWeight, in: 0...100, step: 0.1)
                        .accentColor(TAColor.themeColor)
                        .disabled(!hasCommunication)
                }
                VStack(spacing: 5) {
                    HStack {
                        Text("Application")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasApplication ? 1 : 0.6)
                        Spacer()
                        Toggle("", isOn: $hasApplication)
                            .toggleStyle(SwitchToggleStyle(tint: TAColor.themeColor))
                            .labelsHidden()
                            .onTapGesture {
                                aPercent = 0
                                aWeight = 0
                            }
                    }
                    HStack {
                        Text(hasApplication ? String(format: "Percentage: %.1f%%", Double(aPercent)) : "Percentage")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasApplication ? 1 : 0.6)
                        Spacer()
                    }
                    Slider(value: $aPercent, in: 0...100, step: 0.1)
                        .toggleStyle(SwitchToggleStyle(tint: TAColor.themeColor))
                        .accentColor(TAColor.themeColor)
                        .disabled(!hasApplication)
                    HStack {
                        Text(hasApplication ? String(format: "Weight: %.1f", Double(aWeight)) : "Weight")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasApplication ? 1 : 0.6)
                        Spacer()
                    }
                    Slider(value: $aWeight, in: 0...100, step: 0.1)
                        .accentColor(TAColor.themeColor)
                        .disabled(!hasApplication)
                }
                VStack(spacing: 5) {
                    HStack {
                        Text("Other")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasOther ? 1 : 0.6)
                        Spacer()
                        Toggle("", isOn: $hasOther)
                            .toggleStyle(SwitchToggleStyle(tint: TAColor.themeColor))
                            .labelsHidden()
                            .onTapGesture {
                                oPercent = 0
                                oWeight = 0
                            }
                    }
                    HStack {
                        Text(hasOther ? String(format: "Percentage: %.1f%%", Double(oPercent)) : "Percentage")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasOther ? 1 : 0.6)
                        Spacer()
                    }
                    Slider(value: $oPercent, in: 0...100, step: 0.1)
                        .toggleStyle(SwitchToggleStyle(tint: TAColor.themeColor))
                        .accentColor(TAColor.themeColor)
                        .disabled(!hasOther)
                    HStack {
                        Text(hasOther ? String(format: "Weight: %.1f", Double(oWeight)) : "Weight")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasOther ? 1 : 0.6)
                        Spacer()
                    }
                    Slider(value: $oWeight, in: 0...100, step: 0.1)
                        .accentColor(TAColor.themeColor)
                        .disabled(!hasOther)
                }
                VStack(spacing: 5) {
                    HStack {
                        Text("Finals")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasFinals ? 1 : 0.6)
                        Spacer()
                        Toggle("", isOn: $hasFinals)
                            .toggleStyle(SwitchToggleStyle(tint: TAColor.themeColor))
                            .labelsHidden()
                            .onTapGesture {
                                fPercent = 0
                                fWeight = 0
                            }
                    }
                    HStack {
                        Text(hasFinals ? String(format: "Percentage: %.1f%%", Double(fPercent)) : "Percentage")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasFinals ? 1 : 0.6)
                        Spacer()
                    }
                    Slider(value: $fPercent, in: 0...100, step: 0.1)
                        .toggleStyle(SwitchToggleStyle(tint: TAColor.themeColor))
                        .accentColor(TAColor.themeColor)
                        .disabled(!hasFinals)
                    HStack {
                        Text(hasFinals ? String(format: "Weight: %.1f", Double(fWeight)) : "Weight")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(TAColor.primaryTextColor)
                            .opacity(hasFinals ? 1 : 0.6)
                        Spacer()
                    }
                    Slider(value: $fWeight, in: 0...100, step: 0.1)
                        .accentColor(TAColor.themeColor)
                        .disabled(!hasFinals)
                }
            }
            .padding([.top, .trailing, .leading], TAPadding.viewEdgePadding)
        }
        .background(TAColor.backgroundColor.ignoresSafeArea())
    }
}
