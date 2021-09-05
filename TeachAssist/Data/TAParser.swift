//
//  TAParser.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-23.
//

import Foundation
import SwiftSoup

class TAParser {
    
    static let shared = TAParser()
    
    func parseCourseList(html: String) throws -> [Course] {
        do {
            var courses = [Course]()
            let doc = try SwiftSoup.parse(html)
            let coursesElement = try getCoursesElement(doc: doc)
            for courseElement in coursesElement.children().filter({ $0.hasAttr("bgcolor") }) {
                let course = Course()
                // Parse link
                if let hasLink = try courseElement.getElementsByAttribute("bgcolor").first()?.getElementsByTag("a").hasAttr("href"), hasLink {
                    course.link = try courseElement.getElementsByAttribute("bgcolor").first()?.select("a[href]").first()?.attr("href")
                }
                // Parse course info
                if let infoString = try courseElement.getElementsByAttribute("bgcolor").first()?.getElementsByTag("td").first()?.text(),
                   let markString = try courseElement.getElementsByAttribute("bgcolor").first()?.getElementsByTag("td").last()?.text() {
                    
                    // Course code
                    if infoString.contains(":"),
                       let code = infoString.substring(0, infoString.indexOf(":") - 1) {
                        course.code = code
                    } else {
                        course.code = infoString
                    }
                    
                    // Course name
                    if infoString.contains(":"),
                       infoString.contains("Block:"),
                       let name = infoString.substring(infoString.indexOf(":") + 2, infoString.lastIndexOf(":") - 6) {
                        course.name = name
                    }
                    
                    // Course period
                    if infoString.contains("Block: "),
                       let period = infoString.substring(infoString.lastIndexOf(":") + 2, infoString.lastIndexOf("-") - 1) {
                        course.period = period
                    }
                    
                    // Course room
                    if infoString.contains("rm."),
                       let room = infoString.substring(infoString.lastIndexOf(".") + 2) {
                        course.room = room
                    }
                    
                    // Trim course code if needed
                    if let splitArr = course.code?.split(" "),
                       splitArr[splitArr.count - 1].contains("-"),
                       !(course.room == nil && course.name == nil && course.period == nil && course.link == nil) {
                        course.code = splitArr[splitArr.count - 1];
                    }
                             
                    // Course average
                    if markString.contains("current mark"),
                       let average = markString.substring(markString.indexOf("=") + 2, markString.count - 1)?.trim() {
                        course.average = Double(average)
                    }
                }
                courses.append(course)
            }
            return courses
        } catch {
            throw TAError.parsingError
        }
    }
    
    func parseCourse(course: Course, html: String) throws {
        do {
            let doc = try SwiftSoup.parse(html)
        
            let evaluationsElement = try getEvaluationsElement(doc: doc)
            let evaluationsArray = evaluationsElement.children().array()
            for i in 0..<evaluationsArray.count where i % 2 != 0 {
                let evaluation = Evaluation()
                
                // Evaluation feedback
                if let feedbackCell = try evaluationsArray[i+1].children().filter({ try !$0.getElementsByAttribute("colspan").isEmpty()}).first,
                   let feedback = try feedbackCell.getElementsByAttribute("colspan").first()?.text(),
                   !feedback.isEmpty {
                    evaluation.feedback = feedback
                }
                
                for cell in evaluationsArray[i].children() {
                    // Evaluation name
                    if !(try cell.getElementsByAttributeValue("rowspan", "2")).isEmpty(),
                       let name = try cell.getElementsByAttributeValue("rowspan", "2").first()?.text() {
                        evaluation.name = name
                    } else { // Evaluation sections
                        var currentEvaluationSectionType: SectionType?
                        var currentEvaluationString: String?
                        if !(try cell.getElementsByAttributeValue("bgcolor", "ffffaa")).isEmpty(),
                           let string = try cell.getElementsByAttributeValue("bgcolor", "ffffaa").last()?.getElementsByAttribute("bgcolor").last()?.text() {
                            currentEvaluationSectionType = .knowledge
                            currentEvaluationString = string
                        } else if !(try cell.getElementsByAttributeValue("bgcolor", "c0fea4")).isEmpty(),
                                  let string = try cell.getElementsByAttributeValue("bgcolor", "c0fea4").last()?.getElementsByAttribute("bgcolor").last()?.text() {
                            currentEvaluationSectionType = .thinking
                            currentEvaluationString = string
                        } else if !(try cell.getElementsByAttributeValue("bgcolor", "afafff")).isEmpty(),
                                  let string = try cell.getElementsByAttributeValue("bgcolor", "afafff").last()?.getElementsByAttribute("bgcolor").last()?.text() {
                            currentEvaluationSectionType = .communication
                            currentEvaluationString = string
                        } else if !(try cell.getElementsByAttributeValue("bgcolor", "ffd490")).isEmpty(),
                                  let string = try cell.getElementsByAttributeValue("bgcolor", "ffd490").last()?.getElementsByAttribute("bgcolor").last()?.text() {
                            currentEvaluationSectionType = .application
                            currentEvaluationString = string
                        } else if !(try cell.getElementsByAttributeValue("bgcolor", "#dedede")).isEmpty(),
                                  let string = try cell.getElementsByAttributeValue("bgcolor", "#dedede").last()?.getElementsByAttribute("bgcolor").last()?.text() {
                            currentEvaluationSectionType = .final
                            currentEvaluationString = string
                        }
                        
                        if let currentEvaluationSectionType = currentEvaluationSectionType,
                           let currentEvaluationString = currentEvaluationString,
                           !currentEvaluationString.isEmpty {
                            let section = evaluation.getSection(type: currentEvaluationSectionType)
                            
                            // Current section score
                            if currentEvaluationString.contains("="),
                               let score = currentEvaluationString.substring(0, currentEvaluationString.indexOf("=") - 1) {
                                section.score = score
                            }
                            
                            // Current section percentage
                            if currentEvaluationString.contains("%"),
                               let score = section.score,
                               let numeratorString = score.substring(0, score.indexOf("/") - 1),
                               let denominatorString = score.substring(score.indexOf("/") + 2),
                               let numerator = Double(numeratorString),
                               let denominator = Double(denominatorString),
                               denominator != 0 {
                                section.percent = (numerator / denominator) * 100
                            } else if (currentEvaluationString.indexOf("0") == 0) {
                                section.percent = 0
                            }
                            
                            // Current section weight
                            if currentEvaluationString.contains("no weight") {
                                section.weight = 0
                            } else if currentEvaluationString.contains("="),
                                      let weightString = currentEvaluationString.substring(currentEvaluationString.lastIndexOf("=") + 1),
                                      let weight = Double(weightString) {
                                section.weight = weight
                            }
                        }
                    }
                }
                evaluation.calculateOverall()
                course.evaluations.append(evaluation)
            }
            // Parse course section weights and percentages from the table
            let courseSections = [(course.knowledge, "#ffffaa", "k", "kv"),
                                  (course.thinking, "#c0fea4", "t", "tv"),
                                  (course.communication, "#afafff", "c", "cv"),
                                  (course.application, "#ffd490", "a", "av"),
                                  (course.other, "#eeeeee", "n", "nv"),
                                  (course.final, "#cccccc", "f", "fv")]
            for courseSection in courseSections {
                let section = courseSection.0
                let color = courseSection.1
                let index = section.type == .final ? 1 : 2
                if !(try doc.getElementsByAttributeValue("bgcolor", color)).isEmpty() {
                    // Course section weight
                    if let string = try doc.getElementsByAttributeValue("bgcolor", color).last()?.children().get(index).text(),
                       let weightString = string.substring(0, string.count - 1),
                       let weight = Double(weightString){
                        section.weight = weight
                    }
                    // Course section percent
                    if let string = try doc.getElementsByAttributeValue("bgcolor", color).last()?.children().get(index + 1).text(),
                       string.contains("%"),
                       let percentString = string.substring(0, string.count - 1),
                       let percent = Double(percentString),
                       percent != 0 {
                        section.percent = percent
                    }
                }
            }
            // Parse course section weights and percentages from the table if the weight table is unavailable
            if !courseSections.filter({ $0.0.weight == nil }).isEmpty {
                // Set a default weight in case it can't be parsed from URL
                for courseSection in courseSections {
                    courseSection.0.weight = 100 / 6
                }
                // Course section weights from URL
                if let urlElement = (try doc.getElementsByTag("img").last()?.getElementsByAttribute("src").last()?.attr("src")),
                   urlElement.contains("arcs"),
                   var urlString = urlElement.substring(urlElement.indexOf("k"), urlElement.indexOf("v") + 1) {
                    for courseSection in courseSections {
                        guard let urlStringSubstring = urlString.substring(urlString.indexOf(courseSection.2)) else { break }
                        if let weightString = urlStringSubstring.substring(urlStringSubstring.indexOf("=") + 1, urlStringSubstring.indexOf("&")),
                           let weight = Double(weightString) {
                            courseSection.0.weight = weight
                        }
                        urlString = urlStringSubstring
                    }
                }
                // Course section percentages from URL
                if let urlElement = (try doc.getElementsByTag("img").last()?.getElementsByAttribute("src").last()?.attr("src")),
                   urlElement.contains("arcs"),
                   var urlString = urlElement.substring(urlElement.indexOf("kv")) {
                    for courseSection in courseSections {
                        guard let urlStringSubstring = urlString.substring(urlString.indexOf(courseSection.3)) else { break }
                        if courseSection.0.type == .final {
                            if let percentString = urlStringSubstring.substring(urlStringSubstring.indexOf("=") + 1),
                               let percent = Double(percentString),
                               percent > 0 {
                                courseSection.0.percent = percent * 100
                            }
                        } else {
                            if let percentString = urlStringSubstring.substring(urlStringSubstring.indexOf("=") + 1, urlStringSubstring.indexOf("&")),
                               let percent = Double(percentString),
                               percent > 0 {
                                courseSection.0.percent = percent * 100
                            }
                        }
                        urlString = urlStringSubstring
                    }
                }
            }
            // Calculate the course average based on if prediction is needed
            course.calculateAverage(needsPrediction: !courseSections.filter({ $0.0.percent == nil }).isEmpty )
        } catch {
            throw TAError.parsingError
        }
    }
}

extension TAParser {
    private func getCoursesElement(doc: Document) throws -> Element {
        guard let element = (try doc.getElementsByClass("green_border_message box").array().filter({ try $0.text().contains("Course Name") }).first),
              let body = try element.getElementsByTag("tbody").first() else { throw TAError.parsingError }
        return body
    }
    
    private func getEvaluationsElement(doc: Document) throws -> Element {
        guard let element = (try doc.getElementsByAttributeValue("width", "100%").first()?.getElementsByTag("tbody").first()) else { throw TAError.parsingError }
        return element
    }
}
