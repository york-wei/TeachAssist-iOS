//
//  MenuViewController.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-09.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit
import ViewAnimator

class MenuViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var bugView: UIView!
    @IBOutlet weak var bugButton: UIButton!
    @IBOutlet weak var calculatorView: UIView!
    @IBOutlet weak var calculatorButton: UIButton!
    @IBOutlet weak var creditView: UIView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    var animate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bugView.alpha = 0.0
        calculatorView.alpha = 0.0
        creditView.alpha = 0.0
        rateView.alpha = 0.0
        buttonView.alpha = 0.0
        bugView.layer.cornerRadius = 20
        bugView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        calculatorView.layer.cornerRadius = 20
        calculatorView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        creditView.layer.cornerRadius = 20
        creditView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        rateView.layer.cornerRadius = 20
        rateView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        logOutButton.clipsToBounds = false
        logOutButton.layer.cornerRadius = 20
        logOutButton.layer.applyShadow(color: UIColor(named: "ThemeColor")!, alpha: 1.0, x: 0.0, y: 2.0, blur: 10.0, spread: 0.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if animate == true {
            UIView.animate(views: [bugView], animations: [AnimationType.zoom(scale: 0.2)], duration: 0.1)
            UIView.animate(views: [calculatorView], animations: [AnimationType.zoom(scale: 0.2)], duration: 0.2)
            UIView.animate(views: [creditView], animations: [AnimationType.zoom(scale: 0.2)], duration: 0.2)
            UIView.animate(views: [rateView], animations: [AnimationType.zoom(scale: 0.2)], duration: 0.3)
            UIView.animate(views: [buttonView], animations: [AnimationType.zoom(scale: 0.2)], duration: 0.3)
            animate = false
        }
    }
    
    @IBAction func onDismissMenuTapped() {
        UIView.animate(views: [buttonView], animations: [AnimationType.zoom(scale: 0.9)], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, duration: 0.4)
        UIView.animate(views: [rateView], animations: [AnimationType.zoom(scale: 0.9)], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, duration: 0.5)
        UIView.animate(views: [creditView], animations: [AnimationType.zoom(scale: 0.9)], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, duration: 0.6)
        UIView.animate(views: [calculatorView], animations: [AnimationType.zoom(scale: 0.9)], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, duration: 0.7)
        UIView.animate(views: [bugView], animations: [AnimationType.zoom(scale: 0.9)], reversed: true, initialAlpha: 1.0, finalAlpha: 0.0, duration: 0.8)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onBugTapped() {
        if let url = URL(string: "https://forms.gle/Dfw5Q5H5DPjxQefY9") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func onCalculatorTapped() {
        self.performSegue(withIdentifier: "MenuToCalculator", sender: nil)
    }
    
    @IBAction func onCreditTapped(){
        self.performSegue(withIdentifier: "MenuToCredit", sender: nil)
    }
    
    @IBAction func onRateTapped(){
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1479482556") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func onLogOutTapped() {
        let alert = UIAlertController(title: "Are you sure?", message: "Your cached marks will be deleted once you log out.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .default, handler: { _ in
            NSLog("Cancel")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("User logged out")
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
            self.performSegue(withIdentifier: "MenuToLaunch", sender: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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
