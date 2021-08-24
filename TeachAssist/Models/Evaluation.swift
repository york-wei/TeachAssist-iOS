//
//  Evaluation.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-23.
//

import Foundation

class Evaluation {
    var name: String?
    var knowledge: Section = Section(type: .knowledge)
    var thinking: Section = Section(type: .thinking)
    var communication: Section = Section(type: .communication)
    var application: Section = Section(type: .application)
    var other: Section = Section(type: .other)
    var final: Section = Section(type: .final)
    var overall: Double?
    var feedback: String?
}
