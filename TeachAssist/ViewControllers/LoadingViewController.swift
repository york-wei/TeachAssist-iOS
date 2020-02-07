//
//  LoadingViewController.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-07.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit
import WebKit

class LoadingViewController: UIViewController {
     
    let studentID: String? = UserDefaults.standard.string(forKey: "studentID")
    let studentPW: String? = UserDefaults.standard.string(forKey: "studentPW")
    let isLoggedIn: Bool! = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    var courses = [Course]()
    
    override func viewDidAppear(_ animated: Bool) {
                
        if isLoggedIn {

            if Reachability.isConnectedToNetwork() == false {
                            
                self.performSegue(withIdentifier: "LaunchToMain", sender: nil)
                
            }
                
            else if studentID == "demo" {
                
                self.performSegue(withIdentifier: "LaunchToMain", sender: nil)
                
            }
                
            else {
                
                //crash where no saved courses are stored
                if UserDefaults.standard.object(forKey: "SavedCourses") != nil {
                    
                    if !UserDefaults.standard.bool(forKey: "LoginResetForCrash") {
                        
                        UserDefaults.standard.set(true, forKey: "LoginResetForCrash")
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        self.performSegue(withIdentifier: "LaunchToLogin", sender: nil)
                        
                    }
                    
                    if !UserDefaults.standard.bool(forKey: "LoginResetForProgression") {
                        
                        UserDefaults.standard.set(true, forKey: "LoginResetForProgression")
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        self.performSegue(withIdentifier: "LaunchToLogin", sender: nil)
                        
                    }
                        
                    else if let savedCourses = UserDefaults.standard.object(forKey: "SavedCourses") as? Data {
                        
                        self.courses = try! JSONDecoder().decode([Course].self, from: savedCourses)
                        
                    }
                    
                    else {
                        
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        self.performSegue(withIdentifier: "LaunchToLogin", sender: nil)
                        
                    }
                    
                }
                
                //crash where user information was empty
            
                if(studentID == nil || studentPW == nil) {

                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    self.performSegue(withIdentifier: "LaunchToLogin", sender: nil)

                }
                
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
                            
                        UserDefaults.standard.set(true, forKey: "timedOut")
                        semaphoreLogin.signal()
                        return
                            
                    }
                    
                    guard (200 ... 299) ~= response.statusCode else {
                        
                        UserDefaults.standard.set(true, forKey: "timedOut")
                        semaphoreLogin.signal()
                        return
                        
                    }
                    
                    let responseString = String(data: data, encoding: .utf8)
                    listCourseHTML = responseString!
                    do {
                        
                        let teachAssistResponse = try(TeachAssistResponse(listCourseHTML))
                        UserDefaults.standard.set(true, forKey: "sameCourses")
                        
                        if self.courses.count != teachAssistResponse.courses.count {
                            
                            UserDefaults.standard.set(false, forKey: "sameCourses")
                            
                        }
                        else {
                            
                            for(i, course) in teachAssistResponse.courses.enumerated() {
                                
                                if self.courses[i].code != course.code {
                                    
                                    UserDefaults.standard.set(false, forKey: "sameCourses")
                                    
                                }
                                
                                self.courses[i].mark = course.mark
                                self.courses[i].link = course.link
                                
                            }
                            
                        }
                        
                        if !UserDefaults.standard.bool(forKey: "sameCourses") {
                            
                            //self.courses = teachAssistResponse.courses
                            UserDefaults.standard.set("", forKey: "studentID")
                            UserDefaults.standard.set("", forKey: "studentPW")
                            UserDefaults.standard.removeObject(forKey: "SavedCourses")
                            UserDefaults.standard.set(false, forKey: "isLoggedIn") //saves logged out state
                            UserDefaults.standard.synchronize()
                            if let userDefaults = UserDefaults(suiteName: "group.todayTeachAssist") {
                                userDefaults.set("", forKey: "studentID")
                                userDefaults.set("", forKey: "studentPW")
                                userDefaults.set(false, forKey: "isLoggedIn")
                                userDefaults.removeObject(forKey: "SavedCourses")
                            }
                            UserDefaults.standard.set(false, forKey: "sawWidget")
                            //self.performSegue(withIdentifier: "LaunchToLogin", sender: nil)
                            
                        }
                        
                        let cookies = readCookie(forURL: loginURL)
                        
                        if cookies.count == 0 {
                            
                            UserDefaults.standard.set(true, forKey: "timedOut")
                            
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
                
                if UserDefaults.standard.bool(forKey: "timedOut") || !UserDefaults.standard.bool(forKey: "sameCourses") {
                    
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
                                        
                                        UserDefaults.standard.set(true, forKey: "timedOut")
                                        return
                                        
                                    }

                                    guard (200 ... 299) ~= response.statusCode else {
                                        
                                        UserDefaults.standard.set(true, forKey: "timedOut")
                                        return
                                        
                                    }

                                    let responseString = String(data: data, encoding: .utf8)
                                    viewCourseHTML = responseString!
                                
                                    do {
                                        
                                        let courseResponse = try CourseResponse(viewCourseHTML)
                                        //if assignments page is working
                                        if courseResponse.marks.count > 0 {
                                            self.courses[i].marks = courseResponse.marks
                                            self.courses[i].markStruct = courseResponse.markStruct
                                        }
                                        
                                        if self.courses[i].mark != -1.0 {
                                            self.courses[i].markStruct.average = self.courses[i].mark
                                        }
                                        
                                        if self.courses[i].progression.count == 0 {
                                            self.courses[i].progression.append(self.courses[i].markStruct.average)
                                        }
                                        
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
                                            self.courses[i].updated = true
                                            
                                        }
                                        
                                        if self.courses[i].updated {
                                            
                                            self.courses[i].progression.append(self.courses[i].markStruct.average)
                                            
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
                
                if UserDefaults.standard.bool(forKey: "timedOut") {
                    
                    self.performSegue(withIdentifier: "LaunchToMain", sender: nil)
                    
                }
                    
                else if !UserDefaults.standard.bool(forKey: "sameCourses") {
                    
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    self.performSegue(withIdentifier: "LaunchToLogin", sender: nil)
                    
                }
                
                else {
                    
                    UserDefaults.standard.removeObject(forKey: "SavedCourses")
                    let encoded = try? JSONEncoder().encode(self.courses)
                    UserDefaults.standard.set(encoded, forKey: "SavedCourses")
                    if let userDefaults = UserDefaults(suiteName: "group.todayTeachAssist") {
                        userDefaults.set(self.studentID, forKey: "studentID")
                        userDefaults.set(self.studentPW, forKey: "studentPW")
                        userDefaults.set(true, forKey: "isLoggedIn")
                        userDefaults.set(encoded, forKey: "SavedCourses")
                    }
                    self.performSegue(withIdentifier: "LaunchToMain", sender: nil)
                    
                }
                    
            }
            
        }
        
        else {
            
            self.performSegue(withIdentifier: "LaunchToLogin", sender: nil)
            
        }
        
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
