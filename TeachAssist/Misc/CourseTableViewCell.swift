//
//  CourseTableViewCell.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-16.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseCellView: UIView!
    @IBOutlet weak var courseCodeLabel: UILabel!
    @IBOutlet weak var courseMarkLabel: UILabel!
    @IBOutlet weak var courseMarkProgress: UIProgressView!
    @IBOutlet weak var updatedMark: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
