//
//  Persistence.swift
//  TeachAssist
//
//  Created by York Wei on 2021-05-17.
//

import CoreData
import Foundation

struct PersistenceController {
    
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "TeachAssist")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func fetchSavedCourses() -> [Course] {
        let fetchRequest: NSFetchRequest<CDCourse> = CDCourse.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"index", ascending: true)]
        do {
            let savedCDCourses = try container.viewContext.fetch(fetchRequest)
            var courses = [Course]()
            for cdCourse in savedCDCourses {
                let course = Course()
                course.code = cdCourse.code
                course.name = cdCourse.name
                course.period = cdCourse.period
                course.room = cdCourse.room
                course.link = cdCourse.link
                course.average = cdCourse.average?.doubleValue
                if let cdEvaluations = cdCourse.evaluations?.sortedArray(using: [NSSortDescriptor(key:"index", ascending: true)]) {
                    for cdEvaluation in cdEvaluations {
                        if let cdEvaluation = cdEvaluation as? CDEvaluation {
                            course.evaluations.append(getEvaluation(cdEvaluation: cdEvaluation))
                        }
                    }
                }
                course.knowledge = getSection(cdSection: cdCourse.knowledge!)
                course.thinking = getSection(cdSection: cdCourse.thinking!)
                course.communication = getSection(cdSection: cdCourse.communication!)
                course.application = getSection(cdSection: cdCourse.application!)
                course.other = getSection(cdSection: cdCourse.other!)
                course.final = getSection(cdSection: cdCourse.final!)
                courses.append(course)
            }
            return courses
        } catch {
            print("failed to fetch saved courses: \(error)")
            return []
        }
    }
    
    func saveCourses(courses: [Course]) {
        wipeCourses()
        for (i, course) in courses.enumerated() {
            let cdCourse = CDCourse(context: container.viewContext)
            cdCourse.index = Int64(i)
            cdCourse.code = course.code
            cdCourse.name = course.name
            cdCourse.period = course.period
            cdCourse.room = course.room
            cdCourse.link = course.link
            cdCourse.average = course.average as NSNumber?
            for (j, evaluation) in course.evaluations.enumerated() {
                cdCourse.addToEvaluations(getCDEvaluation(evaluation: evaluation, index: j))
            }
            cdCourse.knowledge = getCDSection(section: course.knowledge)
            cdCourse.thinking = getCDSection(section: course.thinking)
            cdCourse.communication = getCDSection(section: course.communication)
            cdCourse.application = getCDSection(section: course.application)
            cdCourse.other = getCDSection(section: course.other)
            cdCourse.final = getCDSection(section: course.final)
        }
        do {
            try container.viewContext.save()
        } catch {
            print("failed to save: \(error)")
        }
    }
    
    func wipeCourses() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDCourse")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container.viewContext.execute(deleteRequest)
        } catch {
            print("failed to wipe: \(error)")
        }
    }
}

extension PersistenceController {
    private func getCDEvaluation(evaluation: Evaluation, index: Int) -> CDEvaluation {
        let cdEvaluation = CDEvaluation(context: container.viewContext)
        cdEvaluation.index = Int64(index)
        cdEvaluation.name = evaluation.name
        cdEvaluation.overall = evaluation.overall as NSNumber?
        cdEvaluation.feedback = evaluation.feedback
        cdEvaluation.knowledge = getCDSection(section: evaluation.knowledge)
        cdEvaluation.thinking = getCDSection(section: evaluation.thinking)
        cdEvaluation.communication = getCDSection(section: evaluation.communication)
        cdEvaluation.application = getCDSection(section: evaluation.application)
        cdEvaluation.other = getCDSection(section: evaluation.other)
        cdEvaluation.final = getCDSection(section: evaluation.final)
        return cdEvaluation
    }
    
    private func getEvaluation(cdEvaluation: CDEvaluation) -> Evaluation {
        let evaluation = Evaluation()
        evaluation.name = cdEvaluation.name
        evaluation.overall = cdEvaluation.overall?.doubleValue
        evaluation.feedback = cdEvaluation.feedback
        evaluation.knowledge = getSection(cdSection: cdEvaluation.knowledge!)
        evaluation.thinking = getSection(cdSection: cdEvaluation.thinking!)
        evaluation.communication = getSection(cdSection: cdEvaluation.communication!)
        evaluation.application = getSection(cdSection: cdEvaluation.application!)
        evaluation.other = getSection(cdSection: cdEvaluation.other!)
        evaluation.final = getSection(cdSection: cdEvaluation.final!)
        return evaluation
    }
    
    private func getCDSection(section: Section) -> CDSection {
        let cdSection = CDSection(context: container.viewContext)
        cdSection.percent = section.percent as NSNumber?
        cdSection.weight = section.weight as NSNumber?
        cdSection.score = section.score
        cdSection.type = Int64(section.type.rawValue)
        return cdSection
    }
    
    private func getSection(cdSection: CDSection) -> Section {
        let section = Section(type: SectionType(rawValue: Int(cdSection.type))!)
        section.percent = cdSection.percent?.doubleValue
        section.weight = cdSection.weight?.doubleValue
        section.score = cdSection.score
        return section
    }
}
