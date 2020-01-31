//
//  CourseViewController.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-18.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit
import ViewAnimator

class CourseViewController: UIViewController {

    var course: Course!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var averageProgress: UIProgressView!
    
    @IBOutlet weak var evaluationView: UIView!
    @IBOutlet weak var trendView: UIView!
    @IBOutlet weak var breakdownView: UIView!
    
    @IBOutlet weak var evaluationButton: UIButton!
    @IBOutlet weak var trendButton: UIButton!
    @IBOutlet weak var breakdownButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        codeLabel.text = course.code
        nameLabel.text = course.name
        infoLabel.text = "Period \(course.period) - Room \(course.room)"
        if course.markStruct.average >= 0 {
            let roundAverage = Float(round(10*course.markStruct.average)/10)
            averageLabel.text = "\(roundAverage)%"
        }
        else {
            averageLabel.text = "N/A%"
        }
        let averageProgressSize: CGRect = averageProgress.layer.bounds
        let averageProgressHeight = averageProgressSize.height
        averageProgress.layer.cornerRadius = averageProgressHeight / 2
        averageProgress.clipsToBounds = true
        averageProgress.layer.sublayers![1].cornerRadius = averageProgressHeight / 2
        averageProgress.subviews[1].clipsToBounds = true
        averageProgress.setProgress(course.markStruct.average/100, animated: false)
        if course.markStruct.average < 85 && course.markStruct.average >= 70 {
            averageProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if course.markStruct.average < 70 {
            averageProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            averageProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        evaluationView.layer.cornerRadius = 20
        evaluationView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        trendView.layer.cornerRadius = 20
        trendView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        breakdownView.layer.cornerRadius = 20
        breakdownView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        UIView.animate(views: [evaluationView], animations: [AnimationType.zoom(scale: 0.2)], duration: 0.4)
        UIView.animate(views: [trendView], animations: [AnimationType.zoom(scale: 0.2)], duration: 0.6)
        UIView.animate(views: [breakdownView], animations: [AnimationType.zoom(scale: 0.2)], duration: 0.8)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CourseToEvaluation" {
            guard let evaluation = sender as AnyObject as? [Marks],
                let evaluationViewController = segue.destination as? EvaluationViewController
                else {
                    return
            }
            evaluationViewController.evaluation = evaluation
        }
        else if segue.identifier == "CourseToTrend" {
            guard let trends = sender as AnyObject as? ([Marks], [Float]),
                let trendViewController = segue.destination as? TrendViewController
                else {
                    return
            }
            trendViewController.trends = trends
        }
        else if segue.identifier == "CourseToBreakdown" {
            guard let markStruct = sender as AnyObject as? MarkStruct,
                let breakdownViewController = segue.destination as? BreakdownViewController
                else {
                    return
            }
            breakdownViewController.markStruct = markStruct
        }
    }
    
    @IBAction func onBackTapped() {
        let transition: CATransition = CATransition()
        transition.duration = 0.1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.fade;
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onEvaluationTapped() {
        if course.marks[0].evalName != "" && course.marks.count > 0 {
            performSegue(withIdentifier: "CourseToEvaluation", sender: course.marks)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "No evaluations available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onTrendTapped() {
        if course.marks[0].evalName != "" && course.marks.count > 0 {
            var trends = (course.marks, course.progression)
            performSegue(withIdentifier: "CourseToTrend", sender: trends)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "No trends available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func onBreakdownTapped() {
        if course.marks[0].evalName != "" && course.marks.count > 0 {
            performSegue(withIdentifier: "CourseToBreakdown", sender: course.markStruct)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "No breakdown available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
