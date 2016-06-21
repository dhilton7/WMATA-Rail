//
//  Rail.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/15/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import Foundation
import WMATASwift
import CoreData

class Rail {
    
    let wrapper = WMATASwift(apiKey: Constants.apiKey)
    var faveStations: [NSManagedObject]?
    var railStops: [Station]?
    
    static let sharedInstance = Rail()
    private init() {}  //This prevents others from using the default '()' initializer for this class.
    
    
}