//
//  WMATARail.swift
//  WMATASwift
//
//  Created by Dan Hilton on 6/15/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import Foundation
import SwiftyJSON

public extension WMATASwift {
    
    public func getNextTrain(stationCode: String?, success: (JSON)->Void, failure:(NSError)->Void) {
        self.jsonGetRequestWithPath("StationPrediction.svc/json/GetPrediction/\(stationCode ?? "All")", success: success, failure: failure)
    }
    
    public func getTrainLines(success: (JSON)->Void, failure:(NSError)->Void) {
        self.jsonGetRequestWithPath("Rail.svc/json/jLines", success: success, failure: failure)
    }
    
    public func getStopsForLine(lineCode: String?, success: (JSON)->Void, failure:(NSError)->Void) {
        let path = lineCode == nil ? "Rail.svc/json/jStations" : "Rail.svc/json/jStations?\(lineCode!)"
        self.jsonGetRequestWithPath(path, success: success, failure: failure)
    }
    
}