//
//  StopTableViewCell.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/20/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit
import WMATASwift

class StopTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var linesView: UIView!
    
    private var subviewLines: UIView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        subviewLines?.removeFromSuperview()
        subviewLines = nil
    }
    
    func setupCell(station: Station) {
        nameLabel.text = station.name
        nameLabel.adjustsFontSizeToFitWidth = true
        subviewLines = Helper.getLinesView(station)
        subviewLines!.frame = CGRect(x: 4, y: 0, width: subviewLines!.frame.width, height: subviewLines!.frame.height)
        linesView.addSubview(subviewLines!)
    }
    
}
