//
//  TodayTableViewCell.swift
//  TeachAssist Widget
//
//  Created by York Wei on 2019-12-14.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    
    @IBOutlet weak var todayCourse: UILabel!
    @IBOutlet weak var todayNew: UIImageView!
    @IBOutlet weak var todayMark: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
