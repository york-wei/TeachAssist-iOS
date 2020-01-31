//
//  MainViewController.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-07.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit
import ViewAnimator
import BLTNBoard

class MainViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate {

    var courses: [Course]!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var studentIDLabel: UILabel!
    @IBOutlet weak var termAverageLabel: UILabel!
    @IBOutlet weak var termAverageProgress: UIProgressView!
    
    let retrievedStudentID: String? = UserDefaults.standard.string(forKey: "studentID")
    var termAverage: Float = -1.0
    var averageCount: Int = 0
    let transition = Transition()
    
    lazy var bulletinManager: BLTNItemManager = {
        let widget = BLTNPageItem(title: "New Feature!") // ... create your item here
        widget.image = UIImage(named: "WidgetDemo")
        widget.descriptionText = "You can now add a widget to your phone's Today screen to take a glance at your marks and see if they have been updated."
        widget.actionButtonTitle = "Got it!"
        widget.appearance.actionButtonColor = UIColor(named: "ThemeColor")!
        widget.requiresCloseButton = false
        widget.alternativeButtonTitle = nil
        widget.manager?.backgroundViewStyle = .blurredDark
        widget.actionHandler = { (item: BLTNActionItem) in
            UserDefaults.standard.set(true, forKey: "sawWidget")
            widget.manager?.dismissBulletin()
        }
        return BLTNItemManager(rootItem: widget)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        if let savedCourses = UserDefaults.standard.object(forKey: "SavedCourses") as? Data {
            let decoder = JSONDecoder()
            if let loadedCourse = try? decoder.decode([Course].self, from: savedCourses) {
                //print(loadedCourse)
                self.courses = loadedCourse
            }
        }
        if courses == nil {
            termAverage = -1
        }
        else {
            for course in courses {
                if course.markStruct.average >= 0 {
                    if termAverage == -1.0 {
                        termAverage = 0.0
                    }
                    termAverage += course.markStruct.average
                    averageCount += 1
                }
            }
            termAverage = termAverage / Float(averageCount)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToMenu" {
            let menuViewController = segue.destination as! MenuViewController
            menuViewController.transitioningDelegate = self
            menuViewController.modalPresentationStyle = .custom
        }
        else {
            guard let course = sender as AnyObject as? Course,
                let courseViewController = segue.destination as? CourseViewController
                else {
                    return
            }
            courseViewController.course = course
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = menuButton.center
        transition.circleColor = menuButton.backgroundColor!
        
        return transition
        }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = menuButton.center
        transition.circleColor = menuButton.backgroundColor!
        
        return transition
    }
    
    override func viewDidLayoutSubviews() {
        self.studentIDLabel.text = "Student ID: \(self.retrievedStudentID!)"
        if termAverage < 0 {
            self.termAverageLabel.text = "N/A%"
        }
        else {
            let roundTermAverage = Float(round(10*termAverage)/10)
            self.termAverageLabel.text = "\(roundTermAverage)%"
        }
        let termAverageProgressSize: CGRect = termAverageProgress.layer.bounds
        let termAverageProgressHeight = termAverageProgressSize.height
        termAverageProgress.layer.cornerRadius = termAverageProgressHeight / 2
        termAverageProgress.clipsToBounds = true
        termAverageProgress.layer.sublayers![1].cornerRadius = termAverageProgressHeight / 2
        
        
        //termAverageProgress.subviews[1].layer.applyShadow(color: UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0), alpha: 0.4, x: 0.0, y: 0.0, blur: 10.0, spread: 0)
        termAverageProgress.subviews[1].clipsToBounds = true
        let termAverageProgressFloat = termAverage / 100 //put float here for how much bar you want filled
        self.termAverageProgress.setProgress(termAverageProgressFloat, animated: false)
        if termAverage < 85 && termAverage >= 70 {
            termAverageProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if termAverage < 70 {
            termAverageProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            termAverageProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        UIView.animate(views: tableView.visibleCells, animations: [AnimationType.zoom(scale: 0.2)], duration: 0.5)
        if Reachability.isConnectedToNetwork() == false {
            let alert = UIAlertController(title: "Error", message: "You are not connected to a network. TeachAssist could not be updated.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        if UserDefaults.standard.bool(forKey: "timedOut") {
            let alert = UIAlertController(title: "Error", message: "Connection timed out. TeachAssist could not be updated.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            UserDefaults.standard.set(false, forKey: "timedOut")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "sawWidget") {
            bulletinManager.showBulletin(above: self)
        }
//        if #available(iOS 13.0, *) {
//            if self.traitCollection.userInterfaceStyle == .dark {
//                if UIApplication.shared.alternateIconName != "AppIcon-Dark" {
//                    let tempVC = UIViewController()
//                     self.present(tempVC, animated: false, completion: {
//                         tempVC.dismiss(animated: false, completion: nil)
//                     })
//                    UIApplication.shared.setAlternateIconName("AppIcon-Dark", completionHandler: { (error) in})
//                }
//            }
//            else {
//                if UIApplication.shared.alternateIconName == "AppIcon-Dark" {
//                    UIApplication.shared.setAlternateIconName(nil, completionHandler: { (error) in})
//                    let tempVC = UIViewController()
//                    self.present(tempVC, animated: false, completion: {
//                        tempVC.dismiss(animated: false, completion: nil)
//                    })
//                }
//            }
//        }
    }
    
    //@IBAction func onMenuTapped() {
    //    self.performSegue(withIdentifier: "MainToMenu", sender: nil)
    //}
    
    @IBAction func onRefreshTapped() {
        self.performSegue(withIdentifier: "MainToLaunch", sender: nil)
    }
    
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if courses == nil {
            return 0
        }
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell") as! CourseTableViewCell
        
        cell.layer.masksToBounds = false
        cell.selectionStyle = .none
        cell.courseCellView.layer.cornerRadius = 20
        cell.courseCellView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        cell.courseCodeLabel.text? = courses[indexPath.row].code
        
        if courses[indexPath.row].markStruct.average >= 0 {
            let roundAverage = Float(round(10*courses[indexPath.row].markStruct.average)/10)
            cell.courseMarkLabel.text? = "\(roundAverage)%"
            let courseMarkFloat = courses[indexPath.row].markStruct.average/100
            cell.courseMarkProgress.setProgress(courseMarkFloat, animated: false)
            if courses[indexPath.row].markStruct.average < 85 && courses[indexPath.row].markStruct.average >= 70 {
                cell.courseMarkProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
            }
            else if courses[indexPath.row].markStruct.average < 70 {
                cell.courseMarkProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
            }
            else {
                cell.courseMarkProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
            }
        }
        else {
            cell.courseMarkLabel.text? = "..."
            cell.courseMarkProgress.setProgress(0, animated: false)
        }
        
        if courses[indexPath.row].updated{
            cell.updatedMark.alpha = 1
        }
        
        cell.courseMarkProgress.layer.cornerRadius = cell.courseMarkProgress.layer.bounds.height / 2
        cell.courseMarkProgress.clipsToBounds = true
        cell.courseMarkProgress.layer.sublayers![1].cornerRadius = cell.courseMarkProgress.layer.bounds.height / 2
        cell.courseMarkProgress.subviews[1].clipsToBounds = true
        //cell.detailTextLabel?.numberOfLines = 4
       // cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        //cell.detailTextLabel?.text = "Course: " + courses[indexPath.row].name + "\n" + "Period: " + courses[indexPath.row].period + "\n" + "Room: " + courses[indexPath.row].room + "\n" + "Mark: " + courses[indexPath.row].mark
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MainToCourse", sender: courses[indexPath.row])
        let cell = tableView.cellForRow(at: indexPath) as! CourseTableViewCell
        cell.updatedMark.alpha = 0
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
