//
//  LineCollectionViewCell.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/15/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit

class LineCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var paletteView: UIView!
    
    func setupCell(color: UIColor) {
        paletteView.backgroundColor = color
        paletteView.layer.cornerRadius = paletteView.frame.height / 2
        paletteView.layer.masksToBounds = true
    }
    
}
