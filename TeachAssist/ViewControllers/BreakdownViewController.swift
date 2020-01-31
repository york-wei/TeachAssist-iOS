//
//  BreakdownViewController.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-24.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit
import ViewAnimator

class BreakdownViewController: UIViewController {

    var markStruct: MarkStruct!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var averageProgress: UIProgressView!
    @IBOutlet weak var breakdownView: UIView!
    
    @IBOutlet weak var kWeightLabel: UILabel!
    @IBOutlet weak var kLabel: UILabel!
    @IBOutlet weak var kProgress: UIProgressView!
    @IBOutlet weak var tWeightLabel: UILabel!
    @IBOutlet weak var tLabel: UILabel!
    @IBOutlet weak var tProgress: UIProgressView!
    @IBOutlet weak var cWeightLabel: UILabel!
    @IBOutlet weak var cLabel: UILabel!
    @IBOutlet weak var cProgress: UIProgressView!
    @IBOutlet weak var aWeightLabel: UILabel!
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var aProgress: UIProgressView!
    @IBOutlet weak var oWeightLabel: UILabel!
    @IBOutlet weak var oLabel: UILabel!
    @IBOutlet weak var oProgress: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        kProgress.layer.cornerRadius = kProgress.layer.bounds.height / 2
        kProgress.clipsToBounds = true
        kProgress.layer.sublayers![1].cornerRadius = kProgress.layer.bounds.height / 2
        kProgress.subviews[1].clipsToBounds = true
        tProgress.layer.cornerRadius = kProgress.layer.bounds.height / 2
        tProgress.clipsToBounds = true
        tProgress.layer.sublayers![1].cornerRadius = kProgress.layer.bounds.height / 2
        tProgress.subviews[1].clipsToBounds = true
        cProgress.layer.cornerRadius = kProgress.layer.bounds.height / 2
        cProgress.clipsToBounds = true
        cProgress.layer.sublayers![1].cornerRadius = kProgress.layer.bounds.height / 2
        cProgress.subviews[1].clipsToBounds = true
        aProgress.layer.cornerRadius = kProgress.layer.bounds.height / 2
        aProgress.clipsToBounds = true
        aProgress.layer.sublayers![1].cornerRadius = kProgress.layer.bounds.height / 2
        aProgress.subviews[1].clipsToBounds = true
        oProgress.layer.cornerRadius = kProgress.layer.bounds.height / 2
        oProgress.clipsToBounds = true
        oProgress.layer.sublayers![1].cornerRadius = kProgress.layer.bounds.height / 2
        oProgress.subviews[1].clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        if markStruct.average >= 0 {
            let roundAverage = Float(round(10*markStruct.average)/10)
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
        averageProgress.setProgress(markStruct.average/100, animated: false)
        if markStruct.average < 85 && markStruct.average >= 70 {
            averageProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if markStruct.average < 70 {
            averageProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            averageProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        breakdownView.layer.cornerRadius = 20
        breakdownView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        UIView.animate(views: [breakdownView], animations: [AnimationType.zoom(scale: 0.2)], duration: 0.4)
        
        if markStruct.kCourseWeight >= 0 {
            kWeightLabel.text? = "K/U (Weight: \(Float(markStruct.kCourseWeight)))"
        }
        else {
            kWeightLabel.text? = "K/U (Weight: ...)"
        }
        if markStruct.tCourseWeight >= 0 {
            tWeightLabel.text? = "T (Weight: \(Float(markStruct.tCourseWeight)))"
        }
        else {
            tWeightLabel.text? = "T (Weight: ...)"
        }
        if markStruct.cCourseWeight >= 0 {
            cWeightLabel.text? = "C (Weight: \(Float(markStruct.cCourseWeight)))"
        }
        else {
            cWeightLabel.text? = "C (Weight: ...)"
        }
        if markStruct.aCourseWeight >= 0 {
            aWeightLabel.text? = "A (Weight: \(Float(markStruct.aCourseWeight)))"
        }
        else {
            aWeightLabel.text? = "A (Weight: ...)"
        }
        if markStruct.oCourseWeight >= 0 {
            oWeightLabel.text? = "O (Weight: \(Float(markStruct.oCourseWeight)))"
        }
        else {
            oWeightLabel.text? = "O (Weight: ...)"
        }
        
        if markStruct.kCourse >= 0 {
            let kFloat = markStruct.kCourse/100
            kProgress.setProgress(kFloat, animated: false)
            let roundK = Float(round(10*markStruct.kCourse)/10)
            kLabel.text? = "\(roundK)%"
        }
        else {
            kLabel.text? = "..."
            kProgress.setProgress(0, animated: false)
        }
        if markStruct.tCourse >= 0 {
            let tFloat = markStruct.tCourse/100
            tProgress.setProgress(tFloat, animated: false)
            let roundT = Float(round(10*markStruct.tCourse)/10)
            tLabel.text? = "\(roundT)%"
        }
        else {
            tLabel.text? = "..."
            tProgress.setProgress(0, animated: false)
        }
        if markStruct.cCourse >= 0 {
            let cFloat = markStruct.cCourse/100
            cProgress.setProgress(cFloat, animated: false)
            let roundC = Float(round(10*markStruct.cCourse)/10)
            cLabel.text? = "\(roundC)%"
        }
        else {
            cLabel.text? = "..."
            cProgress.setProgress(0, animated: false)
        }
        if markStruct.aCourse >= 0 {
            let aFloat = markStruct.aCourse/100
            aProgress.setProgress(aFloat, animated: false)
            let roundA = Float(round(10*markStruct.aCourse)/10)
            aLabel.text? = "\(roundA)%"
        }
        else {
            aLabel.text? = "..."
            aProgress.setProgress(0, animated: false)
        }
        if markStruct.oCourse >= 0 {
            let oFloat = markStruct.oCourse/100
            oProgress.setProgress(oFloat, animated: false)
            let roundO = Float(round(10*markStruct.oCourse)/10)
            oLabel.text? = "\(roundO)%"
        }
        else {
            oLabel.text? = "..."
            oProgress.setProgress(0, animated: false)
        }
        
        if markStruct.kCourse < 85 && markStruct.kCourse >= 70 {
            kProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if markStruct.kCourse < 70 {
            kProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            kProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        if markStruct.tCourse < 85 && markStruct.tCourse >= 70 {
            tProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if markStruct.tCourse < 70 {
            tProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            tProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        if markStruct.cCourse < 85 && markStruct.cCourse >= 70 {
            cProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if markStruct.cCourse < 70 {
            cProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            cProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        if markStruct.aCourse < 85 && markStruct.aCourse >= 70 {
            aProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if markStruct.aCourse < 70 {
            aProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            aProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        if markStruct.oCourse < 85 && markStruct.oCourse >= 70 {
            oProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if markStruct.oCourse < 70 {
            oProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            oProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
    }
    
    @IBAction func onBackTapped() {
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
