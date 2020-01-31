//
//  TrendViewController.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-26.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit
import Charts
import ViewAnimator

class TrendViewController: UIViewController {

    var trends: ([Marks], [Float])!
    
    @IBOutlet weak var tableView: UITableView!
    
    var progressionChartEntry = [ChartDataEntry]()
    var evaluationChartEntry = [ChartDataEntry]()
    var kChartEntry = [ChartDataEntry]()
    var tChartEntry = [ChartDataEntry]()
    var cChartEntry = [ChartDataEntry]()
    var aChartEntry = [ChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (i, mark) in trends.0.enumerated() {
            if mark.overall >= 0 {//|| mark.kWeight > 0 || mark.tWeight > 0 || mark.cWeight > 0 || mark.aWeight > 0 || mark.oWeight > 0{
                let value = ChartDataEntry(x: Double(i), y: Double(mark.overall))
                evaluationChartEntry.append(value)
            }
            if mark.k >= 0 && mark.kWeight > 0 {
                let value = ChartDataEntry(x: Double(i), y: Double(mark.k))
                kChartEntry.append(value)
            }
            if mark.t >= 0 && mark.tWeight > 0 {
                let value = ChartDataEntry(x: Double(i), y: Double(mark.t))
                tChartEntry.append(value)
            }
            if mark.c >= 0 && mark.cWeight > 0 {
                let value = ChartDataEntry(x: Double(i), y: Double(mark.c))
                cChartEntry.append(value)
            }
            if mark.a >= 0 && mark.aWeight > 0 {
                let value = ChartDataEntry(x: Double(i), y: Double(mark.a))
                aChartEntry.append(value)
            }
        }
        
        for(i, mark) in trends.1.enumerated() {
            let value = ChartDataEntry(x: Double(i), y: Double(mark))
            progressionChartEntry.append(value)
        }
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

extension TrendViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if trends.1.count > 1 {
            return 6
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trendCell") as! TrendTableViewCell
        
        cell.selectionStyle = .none
        cell.trendView.layer.cornerRadius = 20
        cell.trendView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        
        if trends.1.count > 1 {
            
            if indexPath.row == 0 {
                cell.trendLabel.text? = "Course Average"
                let line = LineChartDataSet(entries: self.progressionChartEntry, label: "")
                let data = LineChartData()
                line.colors = [UIColor(named: "ThemeColor")!]
                line.circleColors = [UIColor(named: "ThemeColor")!]
                line.circleRadius = 5
                line.drawCircleHoleEnabled = false
                data.addDataSet(line)
                cell.trendChart.data = data
            }
            else if indexPath.row == 1 {
                cell.trendLabel.text? = "Evaluations"
                let line = LineChartDataSet(entries: self.evaluationChartEntry, label: "")
                let data = LineChartData()
                line.colors = [UIColor(named: "ThemeColor")!]
                line.circleColors = [UIColor(named: "ThemeColor")!]
                line.circleRadius = 5
                line.drawCircleHoleEnabled = false
                data.addDataSet(line)
                cell.trendChart.data = data
            }
            else if indexPath.row == 2 {
                cell.trendLabel.text? = "Knowledge/Understanding"
                let line = LineChartDataSet(entries: self.kChartEntry, label: "")
                let data = LineChartData()
                line.colors = [UIColor(named: "ThemeColor")!]
                line.circleColors = [UIColor(named: "ThemeColor")!]
                line.circleRadius = 5
                line.drawCircleHoleEnabled = false
                data.addDataSet(line)
                cell.trendChart.data = data
            }
            else if indexPath.row == 3 {
                cell.trendLabel.text? = "Thinking"
                let line = LineChartDataSet(entries: self.tChartEntry, label: "")
                let data = LineChartData()
                line.colors = [UIColor(named: "ThemeColor")!]
                line.circleColors = [UIColor(named: "ThemeColor")!]
                line.circleRadius = 5
                line.drawCircleHoleEnabled = false
                data.addDataSet(line)
                cell.trendChart.data = data
            }
            else if indexPath.row == 4 {
                cell.trendLabel.text? = "Communication"
                let line = LineChartDataSet(entries: self.cChartEntry, label: "")
                let data = LineChartData()
                line.colors = [UIColor(named: "ThemeColor")!]
                line.circleColors = [UIColor(named: "ThemeColor")!]
                line.circleRadius = 5
                line.drawCircleHoleEnabled = false
                data.addDataSet(line)
                cell.trendChart.data = data
            }
            else if indexPath.row == 5 {
                cell.trendLabel.text? = "Application"
                let line = LineChartDataSet(entries: self.aChartEntry, label: "")
                let data = LineChartData()
                line.colors = [UIColor(named: "ThemeColor")!]
                line.circleColors = [UIColor(named: "ThemeColor")!]
                line.circleRadius = 5
                line.drawCircleHoleEnabled = false
                data.addDataSet(line)
                cell.trendChart.data = data
            }
            
        }
        else {
            if indexPath.row == 0 {
                cell.trendLabel.text? = "Evaluations"
                let line = LineChartDataSet(entries: self.evaluationChartEntry, label: "")
                let data = LineChartData()
                line.colors = [UIColor(named: "ThemeColor")!]
                line.circleColors = [UIColor(named: "ThemeColor")!]
                line.circleRadius = 5
                line.drawCircleHoleEnabled = false
                data.addDataSet(line)
                cell.trendChart.data = data
            }
            else if indexPath.row == 1 {
                cell.trendLabel.text? = "Knowledge/Understanding"
                let line = LineChartDataSet(entries: self.kChartEntry, label: "")
                let data = LineChartData()
                line.colors = [UIColor(named: "ThemeColor")!]
                line.circleColors = [UIColor(named: "ThemeColor")!]
                line.circleRadius = 5
                line.drawCircleHoleEnabled = false
                data.addDataSet(line)
                cell.trendChart.data = data
            }
            else if indexPath.row == 2 {
                cell.trendLabel.text? = "Thinking"
                let line = LineChartDataSet(entries: self.tChartEntry, label: "")
                let data = LineChartData()
                line.colors = [UIColor(named: "ThemeColor")!]
                line.circleColors = [UIColor(named: "ThemeColor")!]
                line.circleRadius = 5
                line.drawCircleHoleEnabled = false
                data.addDataSet(line)
                cell.trendChart.data = data
            }
            else if indexPath.row == 3 {
                cell.trendLabel.text? = "Communication"
                let line = LineChartDataSet(entries: self.cChartEntry, label: "")
                let data = LineChartData()
                line.colors = [UIColor(named: "ThemeColor")!]
                line.circleColors = [UIColor(named: "ThemeColor")!]
                line.circleRadius = 5
                line.drawCircleHoleEnabled = false
                data.addDataSet(line)
                cell.trendChart.data = data
            }
            else if indexPath.row == 4 {
                cell.trendLabel.text? = "Application"
                let line = LineChartDataSet(entries: self.aChartEntry, label: "")
                let data = LineChartData()
                line.colors = [UIColor(named: "ThemeColor")!]
                line.circleColors = [UIColor(named: "ThemeColor")!]
                line.circleRadius = 5
                line.drawCircleHoleEnabled = false
                data.addDataSet(line)
                cell.trendChart.data = data
            }
        }
        
        cell.trendChart.xAxis.enabled = false
        cell.trendChart.rightAxis.enabled = false
        cell.trendChart.legend.enabled = false
        cell.trendChart.lineData?.setValueFont(UIFont(name: "Sofia Pro", size: 8)!)
        cell.trendChart.lineData?.setValueTextColor(UIColor(named: "SecondaryTextColor")!)
        cell.trendChart.leftAxis.labelFont = UIFont(name: "Sofia Pro", size: 8)!
        cell.trendChart.leftAxis.labelTextColor = (UIColor(named: "SecondaryTextColor")!)
        
        return cell
    }
    
    
}
