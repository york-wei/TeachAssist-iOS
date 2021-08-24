//
//  Course.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-23.
//

import Foundation

class Course {
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
}
