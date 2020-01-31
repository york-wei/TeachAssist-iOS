//
//  CalculatorViewController.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-12.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var termMarkView: UIView!
    @IBOutlet weak var termWeightView: UIView!
    @IBOutlet weak var finalMarkView: UIView!
    @IBOutlet weak var finalWeightView: UIView!
    @IBOutlet weak var customMarkView: UIView!
    @IBOutlet weak var examWeightView: UIView!
    
    @IBOutlet weak var termMarkField: UITextField!
    @IBOutlet weak var termWeightField: UITextField!
    @IBOutlet weak var finalMarkField: UITextField!
    @IBOutlet weak var finalWeightField: UITextField!
    @IBOutlet weak var customMarkField: UITextField!
    @IBOutlet weak var examWeightField: UITextField!
    
    @IBOutlet weak var finalLabel: UILabel!
    @IBOutlet weak var finalWeightLabel: UILabel!
    
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var finalSwitch: UISwitch!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var modeButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var mode = "course"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        termMarkField.delegate = self
        termWeightField.delegate = self
        finalMarkField.delegate = self
        finalWeightField.delegate = self
        customMarkField.delegate = self
        examWeightField.delegate = self
        termMarkView.layer.cornerRadius = 20
        termMarkView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        termWeightView.layer.cornerRadius = 20
        termWeightView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        finalMarkView.layer.cornerRadius = 20
        finalMarkView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        finalWeightView.layer.cornerRadius = 20
        finalWeightView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        customMarkView.layer.cornerRadius = 20
        customMarkView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        examWeightView.layer.cornerRadius = 20
        examWeightView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        calculateButton.clipsToBounds = false
        calculateButton.layer.cornerRadius = 20
        calculateButton.layer.applyShadow(color: UIColor(named: "ThemeColor")!, alpha: 1.0, x: 0.0, y: 2.0, blur: 10.0, spread: 0.0)
        // Do any additional setup after loading the view.
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        if finalSwitch.isOn {
            finalMarkField.isUserInteractionEnabled = true
            finalWeightField.isUserInteractionEnabled = true
            finalLabel.alpha = 1.0
            finalWeightLabel.alpha = 1.0
        }
        else {
            finalMarkField.isUserInteractionEnabled = false
            finalWeightField.isUserInteractionEnabled = false
            finalMarkField.text = ""
            finalWeightField.text = ""
            finalLabel.alpha = 0.4
            finalWeightLabel.alpha = 0.4
        }
    }
    
    @IBAction func onModeTapped() {
        if mode == "course" {
            mode = "exam"
            modeLabel.text = "Predicted Exam Mark"
            answerLabel.text = "If you achieve a mark of _% on the exam, you will finish the course with a mark of _%."
            customMarkField.text = ""
        }
        else if mode == "exam" {
            mode = "course"
            modeLabel.text = "Desired Course Mark"
            answerLabel.text = "To finish the course with _%, you must achieve a mark of atleast %_ on the exam."
            customMarkField.text = ""
        }
    }
    
    func isNumber(str: String) -> Bool {
        if Float(str) != nil {
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func onCalculateTapped() {
        errorLabel.text = ""
        self.view.endEditing(true)
        if mode == "course" {
            answerLabel.text = "To finish the course with _%, you must achieve a mark of atleast %_ on the exam."
        }
        else {
            answerLabel.text = "If you achieve a mark of _% on the exam, you will finish the course with a mark of _%."
        }
        if finalSwitch.isOn {
            if termMarkField.text != "" && termWeightField.text != "" && finalMarkField.text != "" && finalWeightField.text != "" && customMarkField.text != "" && examWeightField.text != "" {
                if isNumber(str: termMarkField.text!) && isNumber(str: termWeightField.text!) && isNumber(str: finalMarkField.text!) && isNumber(str: finalWeightField.text!) && isNumber(str: customMarkField.text!) && isNumber(str: examWeightField.text!){
                    let sum = termWeightField.text!.floatValue + finalWeightField.text!.floatValue + examWeightField.text!.floatValue
                    if sum == 100 {
                        if mode == "course" {
                            var examMark = (customMarkField.text!.floatValue * 100) - (termMarkField.text!.floatValue * termWeightField.text!.floatValue + finalMarkField.text!.floatValue * finalWeightField.text!.floatValue)
                            examMark = examMark / examWeightField.text!.floatValue
                            answerLabel.text = "To finish the course with \(customMarkField.text!)%, you must achieve a mark of atleast \(examMark)% on the exam."
                        }
                        else {
                            var courseMark = (termMarkField.text!.floatValue * termWeightField.text!.floatValue + finalMarkField.text!.floatValue * finalWeightField.text!.floatValue + customMarkField.text!.floatValue * examWeightField.text!.floatValue)
                            courseMark = courseMark / 100
                            answerLabel.text = "If you achieve a mark of \(customMarkField.text!)% on the exam, you will finish the course with a mark of \(courseMark)%."
                        }
                    }
                    else{
                        errorLabel.text = "ERROR: Invalid Weights"
                    }
                }
                else {
                    errorLabel.text = "ERROR: Invalid Input"
                }
            }
            else {
                errorLabel.text = "ERROR: Missing Fields"
            }
        }
        else {
            if termMarkField.text != "" && termWeightField.text != "" && customMarkField.text != "" && examWeightField.text != "" {
                if isNumber(str: termMarkField.text!) && isNumber(str: termWeightField.text!) && isNumber(str: customMarkField.text!) && isNumber(str: examWeightField.text!) {
                    let sum2 = termWeightField.text!.floatValue + examWeightField.text!.floatValue
                    if sum2 == 100 {
                        if mode == "course" {
                            var examMark = (customMarkField.text!.floatValue * 100) - (termMarkField.text!.floatValue * termWeightField.text!.floatValue)
                            examMark = examMark / examWeightField.text!.floatValue
                            answerLabel.text = "To finish the course with \(customMarkField.text!)%, you must achieve a mark of atleast \(examMark)% on the exam."
                        }
                        else {
                            var courseMark = (termMarkField.text!.floatValue * termWeightField.text!.floatValue + customMarkField.text!.floatValue * examWeightField.text!.floatValue)
                            courseMark = courseMark / 100
                            answerLabel.text = "If you achieve a mark of \(customMarkField.text!)% on the exam, you will finish the course with a mark of \(courseMark)%."
                        }
                    }
                    else{
                        errorLabel.text = "ERROR: Invalid Weights"
                    }
                }
                else {
                    errorLabel.text = "ERROR: Invalid Input"
                }
            }
            else {
                errorLabel.text = "ERROR: Missing Fields"
            }
        }
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

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
