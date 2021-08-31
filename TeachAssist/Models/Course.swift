//
//  Course.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-23.
//

import Foundation

class Course: ObservableObject, Identifiable, Equatable {
    
    let id = UUID()
    
    var code: String?
    var name: String?
    var period: String?
    var room: String?
    var link: String?
    var evaluations: [Evaluation] = [Evaluation]()
    var average: Double?
    var knowledge: Section = Section(type: .knowledge)
    var thinking: Section = Section(type: .thinking)
    var communication: Section = Section(type: .communication)
    var application: Section = Section(type: .application)
    var other: Section = Section(type: .other)
    var final: Section = Section(type: .final)
    
    func calculateAverage(needsPrediction: Bool) {
        // If an average is already parsed from the course list page then no calculation is needed
        if average != nil { return }
        var coursePercentSum: Double = 0
        var courseWeightSum: Double = 0
        let courseSections = [knowledge, thinking, communication, application, other, final]
        for section in courseSections {
            if needsPrediction {
                var sectionPercentSum: Double = 0
                var sectionWeightSum: Double = 0
                for evaluation in evaluations {
                    let evaluationSection = evaluation.getSection(type: section.type)
                    if let percent = evaluationSection.percent,
                       let weight = evaluationSection.weight,
                       weight > 0 {
                        sectionPercentSum += percent * weight
                        sectionWeightSum += weight
                    }
                }
                if sectionWeightSum > 0 {
                    section.percent = sectionPercentSum / sectionWeightSum
                }
            }
            if let percent = section.percent,
               let weight = section.weight,
               weight > 0 {
                coursePercentSum += percent * weight
                courseWeightSum += weight
            }
        }
        if courseWeightSum > 0 {
            average = coursePercentSum / courseWeightSum
        }
    }
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        guard let lhsCode = lhs.code,
              let rhsCode = rhs.code else {
            return false
        }
        return lhsCode == rhsCode
    }
}
