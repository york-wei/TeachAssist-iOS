//
//  Evaluation.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-23.
//

import Foundation

class Evaluation: ObservableObject, Identifiable {
    
    let id = UUID()
    
    var name: String?
    var knowledge: Section = Section(type: .knowledge)
    var thinking: Section = Section(type: .thinking)
    var communication: Section = Section(type: .communication)
    var application: Section = Section(type: .application)
    var other: Section = Section(type: .other)
    var final: Section = Section(type: .final)
    var overall: Double?
    var feedback: String?
    
    init() { }
    // init method for copying an evaluation
    init(evaluation: Evaluation) {
        self.name = evaluation.name
        self.knowledge = Section(section: evaluation.knowledge)
        self.thinking = Section(section: evaluation.thinking)
        self.communication = Section(section: evaluation.communication)
        self.application = Section(section: evaluation.application)
        self.other = Section(section: evaluation.other)
        self.final = Section(section: evaluation.final)
        self.overall = evaluation.overall
        self.feedback = evaluation.feedback
    }
    
    func getSection(type: SectionType) -> Section {
        switch type {
        case .knowledge:
            return knowledge
        case .thinking:
            return thinking
        case .communication:
            return communication
        case .application:
            return application
        case .other:
            return other
        case .final:
            return final
        }
    }
    
    func calculateOverall() {
        var percentSum: Double = 0
        var weightSum: Double = 0
        let sections = [knowledge, thinking, communication, application, other, final]
        for section in sections {
            if let percent = section.percent,
               let weight = section.weight,
               weight > 0 {
                percentSum += percent * weight
                weightSum += weight
            }
        }
        if weightSum > 0 {
            overall = percentSum / weightSum
        }
    }
}
