//
//  TodayViewController.swift
//  TeachAssist Widget
//
//  Created by York Wei on 2019-12-13.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit
import NotificationCenter
import WebKit

class TodayViewController: UIViewController, NCWidgetProviding {
        
    let studentID: String! = UserDefaults(suiteName: "group.todayTeachAssist")?.string(forKey: "studentID")
    let studentPW: String! = UserDefaults(suiteName: "group.todayTeachAssist")?.string(forKey: "studentPW")
    let isLoggedIn: Bool! = UserDefaults(suiteName: "group.todayTeachAssist")?.bool(forKey: "isLoggedIn")
    var courses = [Course]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if UserDefaults.standard.object(forKey: "widgetSavedCourses") != nil {
            
            let savedCourses = UserDefaults.standard.object(forKey: "widgetSavedCourses") as! Data
            self.courses = try! JSONDecoder().decode([Course].self, from: savedCourses)
            
        }
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
     
    @IBAction func openHostApp() {
        if let url = URL(string: "TodayTeachAssist://")
        {
            self.extensionContext?.open(url, completionHandler: {success in print("called url complete handler: \(success)")})
        }
    }

    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
      let expanded = activeDisplayMode == .expanded
      preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        textLabel.text = ""
        
        if isLoggedIn {
            
            if studentID != "demo" {

                let loginURL = URL(string: "https://ta.yrdsb.ca/live/m/index.php?error_message=0")!
                let loginParameters = ["subject_id": "0", "username": studentID!, "password": studentPW!, "submit": "Login"]
                var request = URLRequest(url: loginURL)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpBody = loginParameters.percentEscaped().data(using: .utf8)
                var listCourseHTML = ""
                var viewCourseHTML = ""
                var sessionToken = ""
                var sessionID = ""
                var totalLinks = 0
                var linksLoaded = 0
                let semaphoreLogin = DispatchSemaphore(value: 0)
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data,
                        let response = response as? HTTPURLResponse,
                        error == nil else {
                            
                        UserDefaults.standard.set(true, forKey: "widgetTimedOut")
                        semaphoreLogin.signal()
                        return
                            
                    }
                    
                    guard (200 ... 299) ~= response.statusCode else {
                        
                        UserDefaults.standard.set(true, forKey: "widgetTimedOut")
                        semaphoreLogin.signal()
                        return
                        
                    }
                    
                    let responseString = String(data: data, encoding: .utf8)
                    listCourseHTML = responseString!
                    do {
                        
                        let teachAssistResponse = try(TeachAssistResponse(listCourseHTML))
                        var sameCourses = true
                        
                        if self.courses.count != teachAssistResponse.courses.count {
                            
                            sameCourses = false
                            
                        }
                        else {
                            
                            for(i, course) in teachAssistResponse.courses.enumerated() {
                                
                                if self.courses[i].code != course.code {
                                    
                                    sameCourses = false
                                    
                                }
                                
                                self.courses[i].link = course.link
                                
                            }
                            
                        }
                        
                        if sameCourses == false {
                            
                            self.courses = teachAssistResponse.courses
                            
                        }
                        
                        let cookies = readCookie(forURL: loginURL)
                        
                        if cookies.count == 0 {
                            
                            UserDefaults.standard.set(true, forKey: "widgetTimedOut")
                            
                        }
                            
                        else {
                            
                            sessionToken = cookies.first!.value
                            sessionID = cookies.dropFirst().first!.value
                            print("session Token: " + sessionToken)
                            print("session ID: " + sessionID)
                            
                        }
                        
                        semaphoreLogin.signal()
                        
                    } catch {}
                    
                }
                
                task.resume()
                _ = semaphoreLogin.wait(timeout: DispatchTime.distantFuture)
                
                let semaphoreCourse = DispatchSemaphore(value: 0)
                
                if UserDefaults.standard.bool(forKey: "widgetTimedOut") {
                    
                    semaphoreCourse.signal()
                    
                }
                
                else {
                    
                    for(i, course) in self.courses.enumerated() {
                        
                        
                        if course.link == "..." && i == self.courses.count - 1 {
                            semaphoreCourse.signal()
                        }
                        
                        if course.link != "..." {
                            
                            totalLinks += 1
                            let courseURL = URL(string: "https://ta.yrdsb.ca/live/students/" + course.link)!
                            request = URLRequest(url: courseURL)
                            request.httpMethod = "GET"
                            request.setValue("session_token=\(sessionToken); student_id=\(sessionID)", forHTTPHeaderField: "Cookie")
                            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            guard let data = data,
                                let response = response as? HTTPURLResponse,
                                    error == nil else {
                                        
                                        UserDefaults.standard.set(true, forKey: "widgetTimedOut")
                                        return
                                        
                                    }

                                    guard (200 ... 299) ~= response.statusCode else {
                                        
                                        UserDefaults.standard.set(true, forKey: "widgetTimedOut")
                                        return
                                        
                                    }

                                    let responseString = String(data: data, encoding: .utf8)
                                    viewCourseHTML = responseString!
                                
                                    do {
                                        
                                        let courseResponse = try CourseResponse(viewCourseHTML)
                                        self.courses[i].marks = courseResponse.marks
                                        self.courses[i].markStruct = courseResponse.markStruct
                                        
                                        if self.courses[i].prevAverage == self.courses[i].markStruct.average {
                                            
                                            self.courses[i].updated = false
                                            
                                        }
                                            
                                        else if self.courses[i].prevAverage == -1 && self.courses[i].markStruct.average > -1 {
                                            
                                            self.courses[i].prevAverage = self.courses[i].markStruct.average
                                            self.courses[i].updated = true
                                            
                                        }
                                            
                                        else if self.courses[i].prevAverage >= 0 && self.courses[i].prevAverage != self.courses[i].markStruct.average {
                                            
                                            self.courses[i].prevAverage = self.courses[i].markStruct.average
                                            self.courses[i].updated = true
                                            
                                        }
                                            
                                        else if self.courses[i].prevAverage == -2 {
                                            
                                            self.courses[i].prevAverage = self.courses[i].markStruct.average
                                            self.courses[i].updated = false
                                            
                                        }
                                        
                                    } catch {}
                                
                                linksLoaded += 1
                                
                                if linksLoaded == totalLinks {
                                    
                                    semaphoreCourse.signal()
                                    
                                }
                                
                            }
                            
                            task.resume()
                            
                        }
                        
                    }
                    
                }
                
                _ = semaphoreCourse.wait(timeout: DispatchTime.distantFuture)
                
                if UserDefaults.standard.bool(forKey: "widgetTimedOut") {
                    
    //                self.textLabel.text = "Marks could not be updated"
                    tableView.isHidden = false
                    tableView.alpha = 1
                    UserDefaults.standard.set(false, forKey: "widgetTimedOut")
                    completionHandler(NCUpdateResult.noData)
                    
                }
                
                else {
                    
                    print(self.courses)
                    UserDefaults.standard.removeObject(forKey: "widgetSavedCourses")
                    let encoded = try? JSONEncoder().encode(self.courses)
                    UserDefaults.standard.set(encoded, forKey: "widgetSavedCourses")
                    self.tableView.reloadData()
                    tableView.isHidden = false
                    tableView.alpha = 1
                    UserDefaults.standard.set(Date(), forKey: "updatedTime")
                    completionHandler(NCUpdateResult.newData)
                    
                }
            }
            
            else {
                
                print(self.courses)
                self.courses.removeAll()
                var arr = [Marks]()
                let holderMarks = Marks(evalName: "demo", k: 80, kWeight: 5, kScore: "4 / 5", t: 80, tWeight: 5, tScore: "4 / 5", c: 80, cWeight: 5, cScore: "4 / 5", a: 80, aWeight: 5, aScore: "4 / 5", o: -1, oWeight: -1, oScore: "", overall: 80)
                arr.append(holderMarks)
                let holderMarkStruct = MarkStruct(average: 80, kCourse: 80, kCourseWeight: 20, tCourse: 80, tCourseWeight: 20, cCourse: 80, cCourseWeight: 20, aCourse: 80, aCourseWeight: 20, oCourse: -1, oCourseWeight: 20)
                let course = Course(code: "DEMO-01", name: "demo", period: "1", room: "101", mark: 80, link: "", marks: arr, markStruct: holderMarkStruct, prevAverage: -2, updated: false)
                self.courses.append(course)
                
                UserDefaults.standard.removeObject(forKey: "widgetSavedCourses")
                let encoded = try? JSONEncoder().encode(self.courses)
                UserDefaults.standard.set(encoded, forKey: "widgetSavedCourses")
                self.tableView.reloadData()
                tableView.isHidden = false
                tableView.alpha = 1
                UserDefaults.standard.set(Date(), forKey: "updatedTime")
                completionHandler(NCUpdateResult.newData)
                
            }
        }
        
        else {
            
            tableView.alpha = 0
            tableView.isHidden = true
            self.textLabel.text = "You are not logged in"
            completionHandler(NCUpdateResult.failed)
            
        }
        

            // Perform any setup necessary in order to update the view.
            
            // If an error is encountered, use NCUpdateResult.Failed
            // If there's no update required, use NCUpdateResult.NoData
            // If there's an update, use NCUpdateResult.NewData
        
    }
    
}

func readCookie(forURL url: URL) -> [HTTPCookie] {
    
    let cookieStorage = HTTPCookieStorage.shared
    let cookies = cookieStorage.cookies(for: url) ?? []
    return cookies
    
}

extension Dictionary {
    
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
    
}

extension CharacterSet {
    
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
    
}

extension TodayViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell") as! TodayTableViewCell
        
        cell.selectionStyle = .none
        
        if indexPath.row == 0 {
            cell.todayCourse.alpha = 0.7
            cell.todayCourse.text? = "LAST UPDATED:"
            cell.todayMark.alpha = 0.7
            if UserDefaults.standard.object(forKey: "updatedTime") == nil {
                cell.todayMark.text? = ""
            }
            else {
                let currentTime = UserDefaults.standard.object(forKey: "updatedTime") as! Date
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                formatter.dateStyle = .none
                cell.todayMark.text? = formatter.string(from: currentTime)
            }
        }
        else {
            cell.todayCourse.text? = courses[indexPath.row-1].code
            
            if courses[indexPath.row-1].markStruct.average >= 0 {
                let roundAverage = Float(round(10*courses[indexPath.row-1].markStruct.average)/10)
                cell.todayMark.text? = "\(roundAverage)%"
            }
            else {
                cell.todayMark.text? = "---"
            }
            
            if courses[indexPath.row-1].updated{
                cell.todayNew.alpha = 1
            }
        }
        return cell
    }
    
}
