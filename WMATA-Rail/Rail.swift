//
//  Rail.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/15/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import Foundation
import WMATASwift

class Rail {
    
    let wrapper = WMATASwift(apiKey: Constants.apiKey)
    
    class var sharedInstance : Rail {
        struct Static {
            static let instance: Rail = Rail()
        }
        return Static.instance
    }
    
}