//
//  LoginViewController.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-07.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit
import WebKit

class LoginViewCondtroller: UIViewController, WKNavigationDelegate, UITextFieldDelegate {

    @IBOutlet weak var studentID: UITextField!
    @IBOutlet weak var studentPW: UITextField!
    @IBOutlet weak var logInButton: LoadingButton!
    @IBOutlet weak var studentIDView: UIView!
    @IBOutlet weak var studentPWView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var courseIndex = 0
    var otherIndex = 0
    var courses = [Course]()
    var hasLinks: Bool!
    var pageLoaded = true
    var indexArr = [Int]()
    
    var linkIndex = 0
    
    let webView = WKWebView()
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://ta.yrdsb.ca/live/m/index.php?error_message=0")!
        let request = URLRequest(url: url)
        webView.load(request)
        view.addSubview(webView)
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
    
    //Character limit on text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 20
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    //Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == studentID{
            textField.resignFirstResponder()
            studentPW.becomeFirstResponder()
        }
        else if textField == studentPW{
            textField.resignFirstResponder()
        }
        return true
    }

    //Send data through segue
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let courses = sender as AnyObject as? [Course],
//            let mainViewController = segue.destination as? MainViewController
//        else {
//            return
//        }
//        mainViewController.courses = courses
//    }
    
    @IBAction func onSignInTapped() {
        //When button is pressed form is filled out and submitted
        if Reachability.isConnectedToNetwork() == false {
            let alert = UIAlertController(title: "Error", message: "You are not connected to a network.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            studentID.isUserInteractionEnabled = false
            studentPW.isUserInteractionEnabled = false
            errorLabel.text = ""
            logInButton.isEnabled = false
            logInButton.showLoading()
            webView.evaluateJavaScript("document.getElementsByName('username')[0].value='\(studentID.text!)'", completionHandler: nil)
            webView.evaluateJavaScript("document.getElementsByName('password')[0].value='\(studentPW.text!)'", completionHandler: nil)
            webView.evaluateJavaScript("document.getElementsByName('submit')[0].click();", completionHandler: nil)
            webView.navigationDelegate = self
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        //if webView.url! == URL(string: "https://ta.yrdsb.ca/live/m/index.php?error_message=0") || webView.url! == URL(string: "https://ta.yrdsb.ca/live/m/index.php") {
        pageLoaded = true
        if self.studentID.text == "" || self.studentPW.text == "" {
            self.logInButton.isEnabled = true
            self.logInButton.hideLoading()
            self.errorLabel.text = "Missing Fields"
            studentID.isUserInteractionEnabled = true
            studentPW.isUserInteractionEnabled = true
        }
        else if webView.url! == URL(string: "https://ta.yrdsb.ca/live/m/index.php?error_message=0") || webView.url! == URL(string: "https://ta.yrdsb.ca/live/m/index.php") || webView.url! == URL(string: "https://ta.yrdsb.ca/live/m/index.php?error_message=3"){
            self.logInButton.isEnabled = true
            self.logInButton.hideLoading()
            self.errorLabel.text = "Invalid Login"
            studentID.isUserInteractionEnabled = true
            studentPW.isUserInteractionEnabled = true
        }
        else if webView.url?.absoluteString.range(of: "listReports") != nil {
            UserDefaults.standard.set(self.studentID.text!, forKey: "studentID")
            UserDefaults.standard.set(self.studentPW.text!, forKey: "studentPW")
            UserDefaults.standard.set(true, forKey: "isLoggedIn") //saves logged in state
            UserDefaults.standard.synchronize()
            self.webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: { (innerHTML, error) in
                do {
                    let teachAssistResponse = try TeachAssistResponse(innerHTML)
                    self.courses = teachAssistResponse.courses
                    for (i, course) in self.courses.enumerated() {
                        self.otherIndex = i
                        if course.link != "..."{
                            print(course.link)
                            self.courseIndex = i
                            self.hasLinks = true
                            print(self.courseIndex)
                            self.indexArr.append(self.courseIndex)
                        }
                    }
                    if self.hasLinks == true {
                        let courseURL = URL(string: "https://ta.yrdsb.ca/live/students/" + self.courses[self.indexArr[self.linkIndex]].link)!
                        let courseRequest = URLRequest(url: courseURL)
                        self.webView.load(courseRequest)
                        self.view.addSubview(self.webView)
                        self.webView.navigationDelegate = self
                    }
                    if self.otherIndex == self.courses.endIndex - 1 && self.courseIndex == 0 && self.hasLinks != true{
                        self.hasLinks = false
                        print("no links BOI")
                    }
                    if self.hasLinks == false{
                        let encoder = JSONEncoder()
                        //if let encoded = try? encoder.encode(self.courses) {
                        let encoded = try! encoder.encode(self.courses)
                        UserDefaults.standard.set(encoded, forKey: "SavedCourses")
                        UserDefaults.standard.synchronize()
                        self.performSegue(withIdentifier: "LoginToMain", sender: nil)
                    }
                    //if let savedCourses = UserDefaults.standard.object(forKey: "SavedCourses") as? Data {
                    //    let decoder = JSONDecoder()
                    //    if let loadedCourse = try? decoder.decode([Course].self, from: savedCourses) {
                    //print(loadedCourse)
                    //self.courses = loadedCourse
                    //        print(loadedCourse[0].code == teachAssistResponse.courses[0].code)
                    //    }
                    //}
                } catch {}
            })
        }
        else if webView.url?.absoluteString.range(of: "viewReport") != nil{
            self.webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: { (innerHTML, error) in //Get HTML content
                do {
                    print("loaded")
                    let courseResponse = try CourseResponse(innerHTML)
                    print(courseResponse.marks)
                    print(courseResponse.markStruct)
                    print(self.courseIndex)
                    self.courses[self.indexArr[self.linkIndex]].marks = courseResponse.marks
                    self.courses[self.indexArr[self.linkIndex]].markStruct = courseResponse.markStruct
                    if self.courses[self.indexArr[self.linkIndex]].prevAverage == -2 && self.courses[self.indexArr[self.linkIndex]].markStruct.average > -1{
                        self.courses[self.indexArr[self.linkIndex]].prevAverage = self.courses[self.indexArr[self.linkIndex]].markStruct.average
                        self.courses[self.indexArr[self.linkIndex]].updated = true
                    }
                    if self.linkIndex < self.indexArr.count - 1{
                        self.linkIndex += 1
                        let courseURL = URL(string: "https://ta.yrdsb.ca/live/students/" + self.courses[self.indexArr[self.linkIndex]].link)!
                        let courseRequest = URLRequest(url: courseURL)
                        self.webView.load(courseRequest)
                        self.view.addSubview(self.webView)
                        self.webView.navigationDelegate = self
                    }
                    else{
                        let encoder = JSONEncoder()
                        print(self.courses)
                        let encoded = try! encoder.encode(self.courses)
                        UserDefaults.standard.set(encoded, forKey: "SavedCourses")
                        UserDefaults.standard.synchronize()
                        self.performSegue(withIdentifier: "LoginToMain", sender: nil)
                    }
                } catch{}
            })
        }
    }
}
