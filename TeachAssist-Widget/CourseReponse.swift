//
//  File.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-13.
//  Copyright © 2019 York Wei. All rights reserved.
//

import Foundation
import SwiftSoup 

struct CourseResponse {
    
    let marks: [Marks]
    let markStruct: MarkStruct
    
    init(_ innerHTML: Any?) throws {
        guard let htmlString = innerHTML as? String else {
            throw HTMLError.badInnerHTML
        }
        
        var marks = [Marks]()
        var markStruct: MarkStruct
        
        var evalName: String = ""
        var k: Float = -1
        var kWeight: Float = -1
        var kScore: String = ""
        var t: Float = -1
        var tWeight: Float = -1
        var tScore: String = ""
        var c: Float = -1
        var cWeight: Float = -1
        var cScore: String = ""
        var a: Float = -1
        var aWeight: Float = -1
        var aScore: String = ""
        var o: Float = -1
        var oWeight: Float = -1
        var oScore: String = ""
        var overall: Float = 0
        
        var average: Float = 0
        var kCourse: Float = 0
        var kCourseWeight: Float = -1
        var tCourse: Float = 0
        var tCourseWeight: Float = -1
        var cCourse: Float = 0
        var cCourseWeight: Float = -1
        var aCourse: Float = 0
        var aCourseWeight: Float = -1
        var oCourse: Float = 0
        var oCourseWeight: Float = -1
        
        var kSum: Float = 0
        var kWeightSum: Float = 0
        var tSum: Float = 0
        var tWeightSum: Float = 0
        var cSum: Float = 0
        var cWeightSum: Float = 0
        var aSum: Float = 0
        var aWeightSum: Float = 0
        var oSum: Float = 0
        var oWeightSum: Float = 0
        
        let doc = try SwiftSoup.parse(htmlString)
        
        if let body = try doc.getElementsByAttributeValue("width", "100%").first() {
            let body2 = try body.getElementsByTag("tbody").first()
            for (i, tr) in body2!.children().enumerated() {
                if i % 2 != 0 {
                    var markSum: Float = 0
                    var weightSum: Float = 0
                    for td in tr.children() {
                        if let body3 = try td.getElementsByAttributeValue("rowspan", "2").first() {
                            evalName = try body3.text()
                        }
                        else if let body3 = try td.getElementsByAttributeValue("bgcolor", "ffffaa").last(){
                            var str: String
                            var n1 : Float
                            var n2 : Float
                            let holder = try body3.text()
                            if holder != "" {
                                
                                //print(holder)
                                
                                let indexHolder4 = holder.firstIndex(of: "=")
                                if indexHolder4 == nil {
                                    kScore = "..."
                                }
                                else {
                                    str = String(holder[...indexHolder4!])
                                    kScore = String(str.dropLast(2))
                                }
                                
                                if holder.contains("%") {
                                    let indexHolder = kScore.firstIndex(of: "/")
                                    str = String(kScore[...indexHolder!])
                                    str = String(str.dropLast(2))
                                    n1 = Float(str)!
                                    str = String(kScore[indexHolder!...])
                                    str = String(str.dropFirst(2))
                                    n2 = Float(str)!
                                    k = (n1 / n2) * 100
                                }
                                else if holder.first == "0" {
                                    k = 0
                                }
                                else {
                                    k = -1
                                }

                                if holder.contains("no weight") {
                                    kWeight = 0
                                }
                                else {
                                    let indexHolder3 = holder.lastIndex(of: "=")
                                    if indexHolder3 == nil {
                                        kWeight = -1
                                    }
                                    else {
                                        str = String(holder[indexHolder3!...])
                                        kWeight = Float(String(str.dropFirst()))!
                                    }
                                }
                                
                                if k >= 0 {
                                    markSum += k * kWeight
                                    weightSum += kWeight
                                
                                    kSum += k * kWeight
                                    kWeightSum += kWeight
                                }
                            }
                            else {
                                k = -1
                                kWeight = -1
                                kScore = "..."
                            }
                        }
                        else if let body3 = try td.getElementsByAttributeValue("bgcolor", "c0fea4").last(){
                            var str: String
                            var n1 : Float
                            var n2 : Float
                            let holder = try body3.text()
                            if holder != "" {
                                
                                let indexHolder4 = holder.firstIndex(of: "=")
                                if indexHolder4 == nil {
                                    tScore = "..."
                                }
                                else {
                                    str = String(holder[...indexHolder4!])
                                    tScore = String(str.dropLast(2))
                                }
                                
                                if holder.contains("%") {
                                    let indexHolder = tScore.firstIndex(of: "/")
                                    str = String(tScore[...indexHolder!])
                                    str = String(str.dropLast(2))
                                    n1 = Float(str)!
                                    str = String(tScore[indexHolder!...])
                                    str = String(str.dropFirst(2))
                                    n2 = Float(str)!
                                    t = (n1 / n2) * 100
                                }
                                else if holder.first == "0" {
                                    t = 0
                                }
                                else {
                                    t = -1
                                }
                                
                                if holder.contains("no weight") {
                                    tWeight = 0
                                }
                                else {
                                    let indexHolder3 = holder.lastIndex(of: "=")
                                    if indexHolder3 == nil {
                                        tWeight = -1
                                    }
                                    else {
                                        str = String(holder[indexHolder3!...])
                                        tWeight = Float(String(str.dropFirst()))!
                                    }
                                }
                                if t >= 0 {
                                    markSum += t * tWeight
                                    weightSum += tWeight
                                
                                    tSum += t * tWeight
                                    tWeightSum += tWeight
                                }
                            }
                            else {
                                t = -1
                                tWeight = -1
                                tScore = "..."
                            }
                        }
                        else if let body3 = try td.getElementsByAttributeValue("bgcolor", "afafff").last(){
                            var str: String
                            var n1 : Float
                            var n2 : Float
                            let holder = try body3.text()
                            if holder != "" {
                                
                                let indexHolder4 = holder.firstIndex(of: "=")
                                if indexHolder4 == nil {
                                    cScore = "..."
                                }
                                else {
                                    str = String(holder[...indexHolder4!])
                                    cScore = String(str.dropLast(2))
                                }
                                if holder.contains("%") {
                                    let indexHolder = cScore.firstIndex(of: "/")
                                    str = String(cScore[...indexHolder!])
                                    str = String(str.dropLast(2))
                                    n1 = Float(str)!
                                    str = String(cScore[indexHolder!...])
                                    str = String(str.dropFirst(2))
                                    n2 = Float(str)!
                                    c = (n1 / n2) * 100
                                }
                                else if holder.first == "0" {
                                    c = 0
                                }
                                else {
                                    c = -1
                                }
                                
                                if holder.contains("no weight") {
                                    cWeight = 0
                                }
                                else {
                                    let indexHolder3 = holder.lastIndex(of: "=")
                                    if indexHolder3 == nil {
                                        cWeight = -1
                                    }
                                    else {
                                        str = String(holder[indexHolder3!...])
                                        cWeight = Float(String(str.dropFirst()))!
                                    }
                                }
                                
                                if c >= 0 {
                                    markSum += c * cWeight
                                    weightSum += cWeight
                                
                                    cSum += c * cWeight
                                    cWeightSum += cWeight
                                }
                            }
                            else {
                                c = -1
                                cWeight = -1
                                cScore = "..."
                            }
                        }
                        else if let body3 = try td.getElementsByAttributeValue("bgcolor", "ffd490").last(){
                            var str: String
                            var n1 : Float
                            var n2 : Float
                            let holder = try body3.text()
                            if holder != "" {
                                
                                let indexHolder4 = holder.firstIndex(of: "=")
                                if indexHolder4 == nil {
                                    aScore = "..."
                                }
                                else {
                                    str = String(holder[...indexHolder4!])
                                    aScore = String(str.dropLast(2))
                                }
                                
                                if holder.contains("%") {
                                    let indexHolder = aScore.firstIndex(of: "/")
                                    str = String(aScore[...indexHolder!])
                                    str = String(str.dropLast(2))
                                    n1 = Float(str)!
                                    str = String(aScore[indexHolder!...])
                                    str = String(str.dropFirst(2))
                                    n2 = Float(str)!
                                    a = (n1 / n2) * 100
                                }
                                else if holder.first == "0" {
                                    a = 0
                                }
                                else {
                                    a = -1
                                }
                                
                                if holder.contains("no weight") {
                                    aWeight = 0
                                }
                                else {
                                    let indexHolder3 = holder.lastIndex(of: "=")
                                    if indexHolder3 == nil {
                                        aWeight = -1
                                    }
                                    else {
                                        str = String(holder[indexHolder3!...])
                                        aWeight = Float(String(str.dropFirst()))!
                                    }
                                }
                                
                                if a >= 0 {
                                    markSum += a * aWeight
                                    weightSum += aWeight
                                
                                    aSum += a * aWeight
                                    aWeightSum += aWeight
                                }
                            }
                            else {
                                a = -1
                                aWeight = -1
                                aScore = "..."
                            }
                        }
                        else if let body3 = try td.getElementsByAttributeValue("bgcolor", "#dedede").last(){
                            var str: String
                            var n1 : Float
                            var n2 : Float
                            let holder = try body3.text()
                            if holder != "" {
                                
                                let indexHolder4 = holder.firstIndex(of: "=")
                                if indexHolder4 == nil {
                                    oScore = "..."
                                }
                                else {
                                    str = String(holder[...indexHolder4!])
                                    oScore = String(str.dropLast(2))
                                }
                                if holder.contains("%") {
                                    let indexHolder = oScore.firstIndex(of: "/")
                                    str = String(oScore[...indexHolder!])
                                    str = String(str.dropLast(2))
                                    n1 = Float(str)!
                                    str = String(oScore[indexHolder!...])
                                    str = String(str.dropFirst(2))
                                    n2 = Float(str)!
                                    o = (n1 / n2) * 100
                                }
                                else if holder.first == "0" {
                                    o = 0
                                }
                                else {
                                    o = -1
                                }
                                
                                if holder.contains("no weight") {
                                    oWeight = 0
                                }
                                else {
                                    let indexHolder3 = holder.lastIndex(of: "=")
                                    if indexHolder3 == nil {
                                        oWeight = -1
                                    }
                                    else {
                                        str = String(holder[indexHolder3!...])
                                        oWeight = Float(String(str.dropFirst()))!
                                    }
                                }
                                
                                if o >= 0 {
                                    markSum += o * oWeight
                                    weightSum += oWeight
                                
                                    oSum += o * oWeight
                                    oWeightSum += oWeight
                                }
                            }
                            else {
                                o = -1
                                oWeight = -1
                                oScore = "..."
                            }
                        }
                    }
                    if weightSum > 0 {
                        overall = Float(markSum) / Float(weightSum)
                    }
                    else {
                        overall = -1
                    }
                    let mark = Marks(evalName: evalName, k: k, kWeight: kWeight, kScore: kScore, t: t, tWeight: tWeight, tScore: tScore, c: c, cWeight: cWeight, cScore: cScore, a: a, aWeight: aWeight, aScore: aScore, o: o, oWeight: oWeight, oScore: oScore, overall: overall)
                    marks.append(mark)
                }
            }
        }
        
        if let body4 = try doc.getElementsByAttributeValue("bgcolor", "#ffffaa").last() {
                for (i, td) in body4.children().enumerated() {
                    if i == 2 {
                        let holder = try td.text()
                        kCourseWeight = Float(holder.dropLast(1))!
                    }
                }
        }
        if let body4 = try doc.getElementsByAttributeValue("bgcolor", "#c0fea4").last() {
            for (i, td) in body4.children().enumerated() {
                if i == 2 {
                    let holder = try td.text()
                    tCourseWeight = Float(holder.dropLast(1))!
                }
            }
        }
        if let body4 = try doc.getElementsByAttributeValue("bgcolor", "#afafff").last() {
            for (i, td) in body4.children().enumerated() {
                if i == 2 {
                    let holder = try td.text()
                    cCourseWeight = Float(holder.dropLast(1))!
                }
            }
        }
        if let body4 = try doc.getElementsByAttributeValue("bgcolor", "#ffd490").last() {
            for (i, td) in body4.children().enumerated() {
                if i == 2 {
                    let holder = try td.text()
                    aCourseWeight = Float(holder.dropLast(1))!
                }
            }
        }
        if let body4 = try doc.getElementsByAttributeValue("bgcolor", "#eeeeee").last() {
            for (i, td) in body4.children().enumerated() {
                if i == 2 {
                    let holder = try td.text()
                    oCourseWeight = Float(holder.dropLast(1))!
                }
            }
        }
        if let body4 = try doc.getElementsByAttributeValue("bgcolor", "#cccccc").last() {
            for (i, td) in body4.children().enumerated() {
                if i == 1 {
                    let holder = try td.text()
                    oCourseWeight += Float(holder.dropLast(1))!
                }
            }
        }
        
        if kCourseWeight == -1 || tCourseWeight == -1 || cCourseWeight == -1 || aCourseWeight == -1 || oCourseWeight == -1 {
            print("!!!!!!!!")
            print(kCourseWeight)
            print(tCourseWeight)
            print(cCourseWeight)
            print(aCourseWeight)
            print(oCourseWeight)
            kCourseWeight = 20
            tCourseWeight = 20
            cCourseWeight = 20
            aCourseWeight = 20
            oCourseWeight = 20
            if let body4 = try doc.getElementsByTag("img").last()?.getElementsByAttribute("src").last()?.attr("src") {
                
                if body4.contains("arcs") {
                    
                    var holder = String(body4[body4.firstIndex(of: "k")!...body4.firstIndex(of: "v")!])
                    //print(holder)
                    kCourseWeight = Float(String(holder[holder.firstIndex(of: "=")!...holder.firstIndex(of: "&")!]).dropFirst().dropLast())! * 100
                    //print(kCourseWeight)
                    holder = String(holder[holder.firstIndex(of: "t")!...])
                    //print(holder)
                    tCourseWeight = Float(String(holder[holder.firstIndex(of: "=")!...holder.firstIndex(of: "&")!]).dropFirst().dropLast())! * 100
                    //print(tCourseWeight)
                    holder = String(holder[holder.firstIndex(of: "c")!...])
                    //print(holder)
                    cCourseWeight = Float(String(holder[holder.firstIndex(of: "=")!...holder.firstIndex(of: "&")!]).dropFirst().dropLast())! * 100
                    //print(cCourseWeight)
                    holder = String(holder[holder.firstIndex(of: "a")!...])
                    //print(holder)
                    aCourseWeight = Float(String(holder[holder.firstIndex(of: "=")!...holder.firstIndex(of: "&")!]).dropFirst().dropLast())! * 100
                    //print(aCourseWeight)
                    holder = String(holder[holder.firstIndex(of: "n")!...])
                    //print(holder)
                    oCourseWeight = Float(String(holder[holder.firstIndex(of: "=")!...holder.firstIndex(of: "&")!]).dropFirst().dropLast())! * 100
                    //print(oCourseWeight)
                    holder = String(holder[holder.firstIndex(of: "f")!...])
                    //print(holder)
                    oCourseWeight += Float(String(holder[holder.firstIndex(of: "=")!...holder.firstIndex(of: "&")!]).dropFirst().dropLast())! * 100
                    oCourseWeight = Float(round(10*oCourseWeight)/10)
                //print(oCourseWeight)
                    
                }
            }

        }
        
        var kCourseHolder : Float
        var kCourseWeightHolder : Float
        if kWeightSum <= 0 {
            kCourse = -1
            kCourseHolder = 0
            kCourseWeightHolder = 0
        }
        else {
            kCourse = kSum / kWeightSum
            kCourseHolder = kCourse
            kCourseWeightHolder = kCourseWeight
        }
        
        var tCourseHolder : Float
        var tCourseWeightHolder : Float
        if tWeightSum <= 0 {
            tCourse = -1
            tCourseHolder = 0
            tCourseWeightHolder = 0
        }
        else {
            tCourse = tSum / tWeightSum
            tCourseHolder = tCourse
            tCourseWeightHolder = tCourseWeight
        }
        
        var cCourseHolder : Float
        var cCourseWeightHolder : Float
        if cWeightSum <= 0 {
            cCourse = -1
            cCourseHolder = 0
            cCourseWeightHolder = 0
        }
        else {
            cCourse = cSum / cWeightSum
            cCourseHolder = cCourse
            cCourseWeightHolder = cCourseWeight
        }
        
        var aCourseHolder : Float
        var aCourseWeightHolder : Float
        if aWeightSum <= 0 {
            aCourse = -1
            aCourseHolder = 0
            aCourseWeightHolder = 0
        }
        else {
            aCourse = aSum / aWeightSum
            aCourseHolder = aCourse
            aCourseWeightHolder = aCourseWeight
        }
        
        var oCourseHolder : Float
        var oCourseWeightHolder : Float
        if oWeightSum <= 0 {
            oCourse = -1
            oCourseHolder = 0
            oCourseWeightHolder = 0
        }
        else {
            oCourse = oSum / oWeightSum
            oCourseHolder = oCourse
            oCourseWeightHolder = oCourseWeight
        }
        
        average = (kCourseHolder * kCourseWeight + tCourseHolder * tCourseWeight + cCourseHolder * cCourseWeight + aCourseHolder * aCourseWeight + oCourseHolder * oCourseWeight) / (kCourseWeightHolder + tCourseWeightHolder + cCourseWeightHolder + aCourseWeightHolder + oCourseWeightHolder)
        if average.isNaN {
            average = -1
            print(average)
        }
        let markStructs = MarkStruct(average: average, kCourse: kCourse, kCourseWeight: kCourseWeight, tCourse: tCourse, tCourseWeight: tCourseWeight, cCourse: cCourse, cCourseWeight: cCourseWeight, aCourse: aCourse, aCourseWeight: aCourseWeight, oCourse: oCourse, oCourseWeight: oCourseWeight)
        markStruct = markStructs
        self.marks = marks
        self.markStruct = markStruct
    }
}


