//
//  MetroAnnotation.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/19/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit
import MapKit
import WMATASwift

class MetroAnnotation: MKPointAnnotation {

    var station: Station?
    let imgName = "TrainIcon.png"
}
