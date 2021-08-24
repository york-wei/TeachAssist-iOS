//
//  Section.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-23.
//

import Foundation

enum SectionType {
    case knowledge
    case thinking
    case communication
    case application
    case other
    case final
}

class Section {
    var type: SectionType
    var percent: Double?
    var weight: Double?
    var score: String?
    init(type: SectionType) {
        self.type = type
    }
}
