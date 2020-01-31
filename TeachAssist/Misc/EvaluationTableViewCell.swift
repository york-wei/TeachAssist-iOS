//
//  EvaluationTableViewCell.swift
//  TeachAssist
//
//  Created by York Wei on 2019-08-21.
//  Copyright © 2019 York Wei. All rights reserved.
//

import UIKit

class EvaluationTableViewCell: UITableViewCell {

    @IBOutlet weak var evaluationCellView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var overallLabel: UILabel!
    @IBOutlet weak var overallProgress: UIProgressView!
    
    @IBOutlet weak var kWeightLabel: UILabel!
    @IBOutlet weak var kScoreLabel: UILabel!
    @IBOutlet weak var kProgress: UIProgressView!
    
    @IBOutlet weak var tWeightLabel: UILabel!
    @IBOutlet weak var tScoreLabel: UILabel!
    @IBOutlet weak var tProgress: UIProgressView!
    
    @IBOutlet weak var cWeightLabel: UILabel!
    @IBOutlet weak var cScoreLabel: UILabel!
    @IBOutlet weak var cProgress: UIProgressView!
    
    @IBOutlet weak var aWeightLabel: UILabel!
    @IBOutlet weak var aScoreLabel: UILabel!
    @IBOutlet weak var aProgress: UIProgressView!
    
    @IBOutlet weak var oWeightLabel: UILabel!
    @IBOutlet weak var oScoreLabel: UILabel!
    @IBOutlet weak var oProgress: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
