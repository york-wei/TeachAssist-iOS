//
//  Section.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-23.
//

import Foundation

enum SectionType: Int {
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
    
    // init method for copying a section
    init(section: Section) {
        self.type = section.type
        self.percent = section.percent
        self.weight = section.weight
        self.score = section.score
    }
    
    init(type: SectionType, percent: Double, weight: Double) {
        self.type = type
        self.percent = percent
        self.weight = weight
    }
    
    func getWeightString() -> String {
        if let weight = weight,
           weight > 0 {
            return String(format: "Weight: %.1f", weight)
        }
        return "No Weight"
    }
    
    func getPercentString() -> String {
        if let percent = percent {
            return String(format: "%.1f%%", percent)
        }
        return "No Mark"
    }
}
