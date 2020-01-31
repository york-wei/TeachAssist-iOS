//
//  TrendTableViewCell.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-26.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit
import Charts

class TrendTableViewCell: UITableViewCell {

    @IBOutlet weak var trendView: UIView!
    @IBOutlet weak var trendLabel: UILabel!
    @IBOutlet weak var trendChart: LineChartView! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
