//
//  CreditViewController.swift
//  TeachAssist
//
//  Created by York Wei on 2019-10-02.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit
import ViewAnimator

class CreditViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var devView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var gitButton: UIButton!
    @IBOutlet weak var gitView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        devView.layer.cornerRadius = 20
        devView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        iconView.layer.cornerRadius = 20
        iconView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        gitView.layer.cornerRadius = 20
        gitView.layer.applyShadow(color: .black, alpha: 0.1, x: 0.0, y: 2.0, blur: 10.0, spread: 0)
        UIView.animate(views: [devView], animations: [AnimationType.zoom(scale: 0.2)], duration: 0.4)
        UIView.animate(views: [iconView], animations: [AnimationType.zoom(scale: 0.2)], duration: 0.4)
        UIView.animate(views: [gitView], animations: [AnimationType.zoom(scale: 0.2)], duration: 0.4)
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
    
    @IBAction func onGitTapped() {
        if let url = URL(string: "https://github.com/york-wei/TeachAssist-iOS") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
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
