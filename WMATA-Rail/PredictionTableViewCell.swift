//
//  PredictionTableViewCell.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/20/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit
import WMATASwift

class PredictionTableViewCell: UITableViewCell {

    @IBOutlet weak var lineColor: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(prediction:Train) {
        lineColor.layer.cornerRadius = lineColor.frame.width / 2
        lineColor.layer.masksToBounds = true
        lineColor.backgroundColor = Helper.stringToColor(prediction.line)
        nameLabel.text = prediction.destinationName
        arrivalLabel.text = prediction.minString()
    }
}
