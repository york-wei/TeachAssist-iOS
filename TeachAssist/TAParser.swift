//
//  TAParser.swift
//  TeachAssist
//
//  Created by York Wei on 2021-08-23.
//

import Foundation
import SwiftSoup

class TAParser {
    static func parseCourseList(html: String) throws -> [Course] {
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
    }
}

extension TAParser {
    private static func getCoursesElement(doc: Document) throws -> Element {
        guard let element = (try doc.getElementsByClass("green_border_message box").array().filter({ try $0.text().contains("Course Name") }).first),
              let body = try element.getElementsByTag("tbody").first() else { throw NSError() }
        return body
    }
}
