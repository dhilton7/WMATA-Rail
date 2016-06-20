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
    var faveStations: [NSManagedObject]?              //TODO: Might want to move into model extension
    
    class var sharedInstance : Rail {
        struct Static {
            static let instance: Rail = Rail()
        }
        return Static.instance
    }
    
}