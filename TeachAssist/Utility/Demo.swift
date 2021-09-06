//
//  Demo.swift
//  TeachAssist
//
//  Created by York Wei on 2021-09-06.
//

import Foundation

class Demo {
    static let username = "demo"
    static let password = "demo"
    static let demoCourses = getDemoCourses()
}

extension Demo {
    static private func getDemoCourses() -> [Course] {
        let course1 = Course(code: "MCV4U1-05", name: "Calculus and Vectors", period: "1", room: "335", link: "demo", evaluations: getDemoEvaluations([84.5, 100, 89, 98]), average: 95.2, knowledge: demoKnowledge, thinking: demoThinking, communication: demoCommunication, application: demoApplication, other: demoOther, final: demoFinal)
        let course2 = Course(code: "ENG4U1-03", name: "English", period: "2", room: "303", link: "demo", evaluations: getDemoEvaluations([80.4, 83.3, 89.3, 98]), average: 94.5, knowledge: demoKnowledge, thinking: demoThinking, communication: demoCommunication, application: demoApplication, other: demoOther, final: demoFinal)
        let course3 = Course(code: "ICS4U1-02", name: "Computer Science", period: "3", room: "233", link: "demo", evaluations: getDemoEvaluations([99.4, 100, 89, 95.3]), average: 99.3, knowledge: demoKnowledge, thinking: demoThinking, communication: demoCommunication, application: demoApplication, other: demoOther, final: demoFinal)
        let course4 = Course(code: "AMS4M1-01", name: "Music - Repertoire", period: "4", room: "102", link: nil, evaluations: getDemoEvaluations([]), average: nil, knowledge: demoKnowledge, thinking: demoThinking, communication: demoCommunication, application: demoApplication, other: demoOther, final: demoFinal)
        return [course1, course2, course3, course4]
    }
    
    static private func getDemoEvaluations(_ marks : [Double]) -> [Evaluation] {
        var evaluations = [Evaluation]()
        for mark in marks {
            evaluations.append(Evaluation(name: "Demo Evaluation",
                                          knowledge: Section(type: .knowledge, percent: mark, weight: 10),
                                          thinking: Section(type: .thinking, percent: mark, weight: 10),
                                          communication: Section(type: .communication, percent: mark, weight: 10),
                                          application: Section(type: .application, percent: mark, weight: 10),
                                          other: Section(type: .other, percent: mark, weight: 10),
                                          final: Section(type: .final, percent: mark, weight: 10),
                                          overall: mark,
                                          feedback: "Feedback: demo feedback."))
        }
        return evaluations
    }
    
    static private let demoKnowledge = Section(type: .knowledge, percent: 90, weight: 20)
    static private let demoThinking = Section(type: .thinking, percent: 90, weight: 20)
    static private let demoCommunication = Section(type: .communication, percent: 90, weight: 20)
    static private let demoApplication = Section(type: .application, percent: 90, weight: 20)
    static private let demoOther = Section(type: .other, percent: 90, weight: 20)
    static private let demoFinal = Section(type: .final, percent: 90, weight: 20)
}
