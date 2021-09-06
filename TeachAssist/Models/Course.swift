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
    
    init() { }
    // init method for copying a course
    init(course: Course) {
        self.code = course.code
        self.name = course.name
        self.period = course.period
        self.room = course.room
        self.link = course.link
        for evaluation in course.evaluations {
            self.evaluations.append(Evaluation(evaluation: evaluation))
        }
        self.average = course.average
        self.knowledge = Section(section: course.knowledge)
        self.thinking = Section(section: course.thinking)
        self.communication = Section(section: course.communication)
        self.application = Section(section: course.application)
        self.other = Section(section: course.other)
        self.final = Section(section: course.final)
    }
    
    init(code: String?, name: String?, period: String?, room: String?, link: String?,
         evaluations: [Evaluation], average: Double?, knowledge: Section, thinking: Section,
         communication: Section, application: Section, other: Section, final: Section) {
        self.code = code
        self.name = name
        self.period = period
        self.room = room
        self.link = link
        self.evaluations = evaluations
        self.average = average
        self.knowledge = knowledge
        self.thinking = thinking
        self.communication = communication
        self.application = application
        self.other = other
        self.final = final
    }
    
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
    
    // NEEDS REFACTORING :(
    func updateAverageForEstimate() {
        var kSum = 0.0
        var kWeightSum = 0.0
        var tSum = 0.0
        var tWeightSum = 0.0
        var cSum = 0.0
        var cWeightSum = 0.0
        var aSum = 0.0
        var aWeightSum = 0.0
        var oSum = 0.0
        var oWeightSum = 0.0
        var fSum = 0.0
        var fWeightSum = 0.0
        var average: Double?
        var kAverage: Double?
        var tAverage: Double?
        var cAverage: Double?
        var aAverage: Double?
        var oAverage: Double?
        var fAverage: Double?
        for evaluation in evaluations {
            if let kPercent = evaluation.knowledge.percent,
               let kWeight = evaluation.knowledge.weight,
               kWeight > 0 {
                kSum += kPercent * kWeight
                kWeightSum += kWeight
            }
            if kWeightSum != 0 {
                kAverage = kSum / kWeightSum
            }
            if let tPercent = evaluation.thinking.percent,
               let tWeight = evaluation.thinking.weight,
               tWeight > 0 {
                tSum += tPercent * tWeight
                tWeightSum += tWeight
            }
            if tWeightSum != 0 {
                tAverage = tSum / tWeightSum
            }
            if let cPercent = evaluation.communication.percent,
               let cWeight = evaluation.communication.weight,
               cWeight > 0 {
                cSum += cPercent * cWeight
                cWeightSum += cWeight
            }
            if cWeightSum != 0 {
                cAverage = cSum / cWeightSum
            }
            if let aPercent = evaluation.application.percent,
               let aWeight = evaluation.application.weight,
               aWeight > 0 {
                aSum += aPercent * aWeight
                aWeightSum += aWeight
            }
            if aWeightSum != 0 {
                aAverage = aSum / aWeightSum
            }
            if let oPercent = evaluation.other.percent,
               let oWeight = evaluation.other.weight,
               oWeight > 0 {
                oSum += oPercent * oWeight
                oWeightSum += oWeight
            }
            if oWeightSum != 0 {
                oAverage = oSum / oWeightSum
            }
            if let fPercent = evaluation.final.percent,
               let fWeight = evaluation.final.weight,
               fWeight > 0 {
                fSum += fPercent * fWeight
                fWeightSum += fWeight
            }
            if fWeightSum != 0 {
                fAverage = fSum / fWeightSum
            }
            var kCourseWeight = knowledge.weight ?? 0
            var tCourseWeight = thinking.weight ?? 0
            var cCourseWeight = communication.weight ?? 0
            var aCourseWeight = application.weight ?? 0
            var oCourseWeight = other.weight ?? 0
            var fCourseWeight = final.weight ?? 0
            if kWeightSum == 0 || kAverage == nil {
                kCourseWeight = 0
            }
            if tWeightSum == 0 || tAverage == nil {
                tCourseWeight = 0
            }
            if cWeightSum == 0 || cAverage == nil {
                cCourseWeight = 0
            }
            if aWeightSum == 0 || aAverage == nil {
                aCourseWeight = 0
            }
            if oWeightSum == 0 || oAverage == nil {
                oCourseWeight = 0
            }
            if fWeightSum == 0 || fAverage == nil {
                fCourseWeight = 0
            }
            if(kCourseWeight + tCourseWeight + cCourseWeight + aCourseWeight + oCourseWeight + fCourseWeight != 0) {
                average = (((kAverage ?? 0) * kCourseWeight) + ((tAverage ?? 0) * tCourseWeight) + ((cAverage ?? 0) * cCourseWeight) + ((aAverage ?? 0) * aCourseWeight) + ((oAverage ?? 0) * oCourseWeight) + ((fAverage ?? 0) * fCourseWeight)) / (kCourseWeight + tCourseWeight + cCourseWeight + aCourseWeight + oCourseWeight + fCourseWeight)
            }
        }
        self.average = average
        self.knowledge.percent = kAverage
        self.thinking.percent = tAverage
        self.communication.percent = cAverage
        self.application.percent = aAverage
        self.other.percent = oAverage
        self.final.percent = fAverage
    }
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        guard let lhsCode = lhs.code,
              let rhsCode = rhs.code else {
            return false
        }
        return lhsCode == rhsCode
    }
}
