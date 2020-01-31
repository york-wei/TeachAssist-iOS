//
//  EvaluationViewController.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-21.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit
import ViewAnimator

class EvaluationViewController: UIViewController, UITableViewDelegate {

    var evaluation: [Marks]!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        UIView.animate(views: tableView.visibleCells, animations: [AnimationType.zoom(scale: 0.2)], duration: 0.5)
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

}

extension EvaluationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "evaluationCell") as! EvaluationTableViewCell
        
        cell.layer.masksToBounds = false
        cell.selectionStyle = .none
        cell.evaluationCellView.layer.cornerRadius = 20
        cell.evaluationCellView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        
        cell.nameLabel.text? = evaluation[evaluation.count - indexPath.row - 1].evalName
        
        if evaluation[evaluation.count - indexPath.row - 1].kWeight >= 0 {
            cell.kWeightLabel.text? = "K/U (Weight: \(Int(evaluation[evaluation.count - indexPath.row - 1].kWeight)))"
        }
        else {
            cell.kWeightLabel.text? = "K/U (Weight: ...)"
        }
        
        if evaluation[evaluation.count - indexPath.row - 1].tWeight >= 0 {
            cell.tWeightLabel.text? = "T (Weight: \(Int(evaluation[evaluation.count - indexPath.row - 1].tWeight)))"
        }
        else {
            cell.tWeightLabel.text? = "T (Weight: ...)"
        }
        
        if evaluation[evaluation.count - indexPath.row - 1].cWeight >= 0 {
            cell.cWeightLabel.text? = "C (Weight: \(Int(evaluation[evaluation.count - indexPath.row - 1].cWeight)))"
        }
        else {
            cell.cWeightLabel.text? = "C (Weight: ...)"
        }
        
        if evaluation[evaluation.count - indexPath.row - 1].aWeight >= 0 {
            cell.aWeightLabel.text? = "A (Weight: \(Int(evaluation[evaluation.count - indexPath.row - 1].aWeight)))"
        }
        else {
            cell.aWeightLabel.text? = "A (Weight: ...)"
        }
        
        if evaluation[evaluation.count - indexPath.row - 1].oWeight >= 0 {
            cell.oWeightLabel.text? = "O (Weight: \(Int(evaluation[evaluation.count - indexPath.row - 1].oWeight)))"
        }
        else {
            cell.oWeightLabel.text? = "O (Weight: ...)"
        }
        
        if evaluation[evaluation.count - indexPath.row - 1].overall >= 0 {
            let overallFloat = evaluation[evaluation.count - indexPath.row - 1].overall/100
            cell.overallProgress.setProgress(overallFloat, animated: false)
            let roundOverall = Float(round(10*evaluation[evaluation.count - indexPath.row - 1].overall)/10)
            cell.overallLabel.text? = "\(roundOverall)%"
        }
        else {
            cell.overallLabel.text? = "..."
            cell.overallProgress.setProgress(0, animated: false)
        }
        
        if evaluation[evaluation.count - indexPath.row - 1].k >= 0 {
            let kFloat = evaluation[evaluation.count - indexPath.row - 1].k/100
            cell.kProgress.setProgress(kFloat, animated: false)
            let roundK = Float(round(10*evaluation[evaluation.count - indexPath.row - 1].k)/10)
            cell.kScoreLabel.text? = "\(evaluation[evaluation.count - indexPath.row - 1].kScore) - \(roundK)%"
        }
        else {
            cell.kScoreLabel.text? = "..."
            cell.kProgress.setProgress(0, animated: false)
        }
        
        if evaluation[evaluation.count - indexPath.row - 1].t >= 0 {
            let tFloat = evaluation[evaluation.count - indexPath.row - 1].t/100
            cell.tProgress.setProgress(tFloat, animated: false)
            let roundT = Float(round(10*evaluation[evaluation.count - indexPath.row - 1].t)/10)
            cell.tScoreLabel.text? = "\(evaluation[evaluation.count - indexPath.row - 1].tScore) - \(roundT)%"
        }
        else {
            cell.tScoreLabel.text? = "..."
            cell.tProgress.setProgress(0, animated: false)
        }
        
        if evaluation[evaluation.count - indexPath.row - 1].c >= 0 {
            let cFloat = evaluation[evaluation.count - indexPath.row - 1].c/100
            cell.cProgress.setProgress(cFloat, animated: false)
            let roundC = Float(round(10*evaluation[evaluation.count - indexPath.row - 1].c)/10)
            cell.cScoreLabel.text? = "\(evaluation[evaluation.count - indexPath.row - 1].cScore) - \(roundC)%"
        }
        else {
            cell.cScoreLabel.text? = "..."
            cell.cProgress.setProgress(0, animated: false)
        }
        
        if evaluation[evaluation.count - indexPath.row - 1].a >= 0 {
            let aFloat = evaluation[evaluation.count - indexPath.row - 1].a/100
            cell.aProgress.setProgress(aFloat, animated: false)
            let roundA = Float(round(10*evaluation[evaluation.count - indexPath.row - 1].a)/10)
            cell.aScoreLabel.text? = "\(evaluation[evaluation.count - indexPath.row - 1].aScore) - \(roundA)%"
        }
        else {
            cell.aScoreLabel.text? = "..."
            cell.aProgress.setProgress(0, animated: false)
        }
        if evaluation[evaluation.count - indexPath.row - 1].o >= 0 {
            let oFloat = evaluation[evaluation.count - indexPath.row - 1].o/100
            cell.oProgress.setProgress(oFloat, animated: false)
            let roundO = Float(round(10*evaluation[evaluation.count - indexPath.row - 1].o)/10)
            cell.oScoreLabel.text? = "\(evaluation[evaluation.count - indexPath.row - 1].oScore) - \(roundO)%"
        }
        else {
            cell.oScoreLabel.text? = "..."
            cell.oProgress.setProgress(0, animated: false)
        }
        
        cell.overallProgress.layer.cornerRadius = cell.overallProgress.layer.bounds.height / 2
        cell.overallProgress.clipsToBounds = true
        cell.overallProgress.layer.sublayers![1].cornerRadius = cell.overallProgress.layer.bounds.height / 2
        cell.overallProgress.subviews[1].clipsToBounds = true
        
        if evaluation[evaluation.count - indexPath.row - 1].overall < 85 && evaluation[evaluation.count - indexPath.row - 1].overall >= 70 {
            cell.overallProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if evaluation[evaluation.count - indexPath.row - 1].overall < 70 {
            cell.overallProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            cell.overallProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        
        cell.kProgress.layer.cornerRadius = cell.overallProgress.layer.bounds.height / 2
        cell.kProgress.clipsToBounds = true
        cell.kProgress.layer.sublayers![1].cornerRadius = cell.overallProgress.layer.bounds.height / 2
        cell.kProgress.subviews[1].clipsToBounds = true
        
        if evaluation[evaluation.count - indexPath.row - 1].k < 85 && evaluation[evaluation.count - indexPath.row - 1].k >= 70 {
            cell.kProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if evaluation[evaluation.count - indexPath.row - 1].k < 70 {
            cell.kProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            cell.kProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        
        cell.tProgress.layer.cornerRadius = cell.overallProgress.layer.bounds.height / 2
        cell.tProgress.clipsToBounds = true
        cell.tProgress.layer.sublayers![1].cornerRadius = cell.overallProgress.layer.bounds.height / 2
        cell.tProgress.subviews[1].clipsToBounds = true
        
        if evaluation[evaluation.count - indexPath.row - 1].t < 85 && evaluation[evaluation.count - indexPath.row - 1].t >= 70 {
            cell.tProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if evaluation[evaluation.count - indexPath.row - 1].t < 70 {
            cell.tProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            cell.tProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        
        cell.cProgress.layer.cornerRadius = cell.overallProgress.layer.bounds.height / 2
        cell.cProgress.clipsToBounds = true
        cell.cProgress.layer.sublayers![1].cornerRadius = cell.overallProgress.layer.bounds.height / 2
        cell.cProgress.subviews[1].clipsToBounds = true
        
        if evaluation[evaluation.count - indexPath.row - 1].c < 85 && evaluation[evaluation.count - indexPath.row - 1].c >= 70 {
            cell.cProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if evaluation[evaluation.count - indexPath.row - 1].c < 70 {
            cell.cProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            cell.cProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        
        cell.aProgress.layer.cornerRadius = cell.overallProgress.layer.bounds.height / 2
        cell.aProgress.clipsToBounds = true
        cell.aProgress.layer.sublayers![1].cornerRadius = cell.overallProgress.layer.bounds.height / 2
        cell.aProgress.subviews[1].clipsToBounds = true
        
        if evaluation[evaluation.count - indexPath.row - 1].a < 85 && evaluation[evaluation.count - indexPath.row - 1].a >= 70 {
            cell.aProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if evaluation[evaluation.count - indexPath.row - 1].a < 70 {
            cell.aProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            cell.aProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        
        cell.oProgress.layer.cornerRadius = cell.overallProgress.layer.bounds.height / 2
        cell.oProgress.clipsToBounds = true
        cell.oProgress.layer.sublayers![1].cornerRadius = cell.overallProgress.layer.bounds.height / 2
        cell.oProgress.subviews[1].clipsToBounds = true
        
        if evaluation[evaluation.count - indexPath.row - 1].o < 85 && evaluation[evaluation.count - indexPath.row - 1].o >= 70 {
            cell.oProgress.progressTintColor = UIColor(displayP3Red: 232.0/255.0, green: 227.0/255.0, blue: 126.0/255.0, alpha: 1.0) //yellow
        }
        else if evaluation[evaluation.count - indexPath.row - 1].o < 70 {
            cell.oProgress.progressTintColor = UIColor(displayP3Red: 255.0/255.0, green: 126.0/255.0, blue: 126.0/255.0, alpha: 1.0) //red
        }
        else {
            cell.oProgress.progressTintColor = UIColor(displayP3Red: 116.0/255.0, green: 213.0/255.0, blue: 169.0/255.0, alpha: 1.0) //green
        }
        
        return cell
    }
    
    
}
