//
//  WMATASwift.swift
//  WMATASwift
//
//  Created by Dan Hilton on 6/15/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class WMATASwift {
    
    internal(set) var apiUrl: NSURL
    internal(set) var baseUrl: String
    internal(set) var apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
        self.apiUrl = NSURL(string: "https://api.wmata.com/")!
        self.baseUrl = "https://api.wmata.com/"
    }
    
    // JSON Requests
    
    internal func jsonGetRequestWithPath(path: String, success: (JSON)->Void, failure: (NSError)->Void) {
        Alamofire.request(.GET, "\(self.baseUrl)\(path)", parameters: nil, encoding: .JSON, headers: ["api_key": self.apiKey])
            .validate()
            .responseJSON { response in
                if let val = response.result.value {
                    success(JSON(val))
                }
            }
    }
    
}