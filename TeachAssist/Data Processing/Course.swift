//
//  Course.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-07.
//  Copyright © 2019 York Wei. All rights reserved.
//

import Foundation

struct Course: Codable, Equatable {
    var code: String
    var name: String
    var period: String
    var room: String
    var mark: Float
    var link: String
    var marks: [Marks]
    var markStruct: MarkStruct
    var prevAverage : Float
    var updated : Bool
    var progression : [Float]
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.code == rhs.code  
    }
}

