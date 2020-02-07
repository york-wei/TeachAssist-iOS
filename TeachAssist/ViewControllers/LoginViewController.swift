//
//  LoginViewController.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-07.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate {

    @IBOutlet weak var studentID: UITextField!
    @IBOutlet weak var studentPW: UITextField!
    @IBOutlet weak var logInButton: LoadingButton!
    @IBOutlet weak var studentIDView: UIView!
    @IBOutlet weak var studentPWView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var courses = [Course]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        studentID.delegate = self
        studentPW.delegate = self
        studentIDView.layer.cornerRadius = 15
        studentIDView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        studentPWView.layer.cornerRadius = 15
        studentPWView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        logInButton.clipsToBounds = false
        logInButton.layer.cornerRadius = 20
        logInButton.layer.applyShadow(color: UIColor(named: "ThemeColor")!, alpha: 1.0, x: 0.0, y: 2.0, blur: 10.0, spread: 0.0)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 20
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == studentID {
            
            textField.resignFirstResponder()
            studentPW.becomeFirstResponder()
            
        }
            
        else if textField == studentPW {
            
            textField.resignFirstResponder()
            
        }
        
        return true
        
    }
    
    @IBAction func onSignInTapped() {
        
        studentID.isUserInteractionEnabled = false
        studentPW.isUserInteractionEnabled = false
        errorLabel.text = ""
        logInButton.isEnabled = false
        logInButton.showLoading()
        
        if Reachability.isConnectedToNetwork() == false {
            
            studentID.isUserInteractionEnabled = true
            studentPW.isUserInteractionEnabled = true
            errorLabel.text = "No Connection"
            logInButton.isEnabled = true
            logInButton.hideLoading()
            
        }
            
        else {
            
            if studentID.text == "" || studentPW.text == "" {
                
                logInButton.isEnabled = true
                logInButton.hideLoading()
                errorLabel.text = "Missing Fields"
                studentID.isUserInteractionEnabled = true
                studentPW.isUserInteractionEnabled = true
                
            }
                
            else if studentID.text == "demo" && studentPW.text == "demo" {
                
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                
                var arr = [Marks]()
                let holderMarks = Marks(evalName: "demo", k: 80, kWeight: 5, kScore: "4 / 5", t: 80, tWeight: 5, tScore: "4 / 5", c: 80, cWeight: 5, cScore: "4 / 5", a: 80, aWeight: 5, aScore: "4 / 5", o: -1, oWeight: -1, oScore: "", overall: 80)
                arr.append(holderMarks)
                let holderMarkStruct = MarkStruct(average: 80, kCourse: 80, kCourseWeight: 20, tCourse: 80, tCourseWeight: 20, cCourse: 80, cCourseWeight: 20, aCourse: 80, aCourseWeight: 20, oCourse: -1, oCourseWeight: 20)
                let course = Course(code: "DEMO-01", name: "demo", period: "1", room: "101", mark: 80, link: "", marks: arr, markStruct: holderMarkStruct, prevAverage: -2, updated: false, progression: [Float]())
                self.courses.append(course)
                
                UserDefaults.standard.set(self.studentID.text!, forKey: "studentID")
                UserDefaults.standard.set(self.studentPW.text!, forKey: "studentPW")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                let encoded = try? JSONEncoder().encode(self.courses)
                UserDefaults.standard.set(encoded, forKey: "SavedCourses")
                self.performSegue(withIdentifier: "LoginToMain", sender: nil)
                
            }
            
            else {
                
                let loginURL = URL(string: "https://ta.yrdsb.ca/live/m/index.php?error_message=0")!
                let loginParameters = ["subject_id": "0", "username": studentID.text!, "password": studentPW.text!, "submit": "Login"]
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
                                        
                    if listCourseHTML.contains("Please log in with your <b>YRDSB</b> provided user name and password.") {
                        
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        semaphoreLogin.signal()
                        return
                        
                    }
                    
                    else {
                    
                        do {
                            
                            let cookies = readCookie(forURL: loginURL)
                            
                            if cookies.count == 0 {
                                
                                UserDefaults.standard.set(true, forKey: "timedOut")
                                semaphoreLogin.signal()
                                
                            }
                            
                            else {
                                
                                sessionToken = cookies.first!.value
                                sessionID = cookies.dropFirst().first!.value
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                let teachAssistResponse = try(TeachAssistResponse(listCourseHTML))
                                self.courses = teachAssistResponse.courses
                                semaphoreLogin.signal()
                                
                            }
                            
                        } catch {}
                        
                    }
                    
                }
                
                task.resume()
                _ = semaphoreLogin.wait(timeout: DispatchTime.distantFuture)
                
                let semaphoreCourse = DispatchSemaphore(value: 0)
                
                if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
                    
                    semaphoreCourse.signal()
                    
                }
                    
                else if UserDefaults.standard.bool(forKey: "timedOut") {
                    
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
                                        
                                        if courseResponse.marks.count > 0 {
                                            self.courses[i].marks = courseResponse.marks
                                            self.courses[i].markStruct = courseResponse.markStruct
                                        }
                                        
                                        if self.courses[i].mark != -1.0 {
                                            self.courses[i].markStruct.average = self.courses[i].mark
                                        }
                                            
                                        if self.courses[i].prevAverage == -2 && self.courses[i].markStruct.average > -1 {
                                                
                                            self.courses[i].prevAverage = self.courses[i].markStruct.average
                                            self.courses[i].updated = true
                                                
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
                    
                    UserDefaults.standard.set(false, forKey: "timedOut")
                    logInButton.isEnabled = true
                    logInButton.hideLoading()
                    errorLabel.text = "Connection Timeout"
                    studentID.isUserInteractionEnabled = true
                    studentPW.isUserInteractionEnabled = true
                    
                }
                
                else if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                    
                    UserDefaults.standard.set(self.studentID.text!, forKey: "studentID")
                    UserDefaults.standard.set(self.studentPW.text!, forKey: "studentPW")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    let encoded = try? JSONEncoder().encode(self.courses)
                    UserDefaults.standard.set(encoded, forKey: "SavedCourses")
                    if let userDefaults = UserDefaults(suiteName: "group.todayTeachAssist") {
                        userDefaults.set(self.studentID.text!, forKey: "studentID")
                        userDefaults.set(self.studentPW.text!, forKey: "studentPW")
                        userDefaults.set(true, forKey: "isLoggedIn")
                        userDefaults.set(encoded, forKey: "SavedCourses")
                    }
                    self.performSegue(withIdentifier: "LoginToMain", sender: nil)
                }
                
                else {
                    
                    self.logInButton.isEnabled = true
                    self.logInButton.hideLoading()
                    self.errorLabel.text = "Invalid Login"
                    self.studentID.isUserInteractionEnabled = true
                    self.studentPW.isUserInteractionEnabled = true
                    
                }
                        
            }
                    
        }
                
    }
        
}
    
extension CALayer {
    func applyShadow( 
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

