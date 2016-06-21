//
//  Helper.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/20/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit
import WMATASwift
import CoreData

public class Helper {
    
    static func isFavorite(stationCode: String) -> Bool {
        return Rail.sharedInstance.faveStations?.contains({ $0.valueForKey("code") as! String == stationCode }) ?? false
    }
    
    static func stringToColor(color: String?) -> UIColor {
        if color == "Blue" || color == "BL" {
            return UIColor(red: 40/255.0, green: 99/255.0, blue: 178/255.0, alpha: 1.0)
        }
        else if color == "Green" || color == "GR"{
            return UIColor(red: 17/255.0, green: 219/255.0, blue: 111/255.0, alpha: 1.0)
        }
        else if color == "Orange" || color == "OR" {
            return UIColor(red: 255/255.0, green: 128/255.0, blue: 0, alpha: 1.0)
        }
        else if color == "Red" || color == "RD" {
            return UIColor(red: 220/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0)
        }
        else if color == "Silver" || color == "SV" {
            return UIColor.grayColor()
        }
        else if color == "Yellow" || color == "YL" {
            return UIColor(red: 247/255.0, green: 247/255.0, blue: 21/255.0, alpha: 1.0)
        }
        else {
            return UIColor.whiteColor()
        }
    }
    
    // TOOD: Consolidate this code down
    
    static func getLinesView(station: Station) -> UIView {
        let linesView = UIView()
        var buffer: CGFloat = 4
        for line in station.lineCodes! {
            linesView.addSubview(getlineSubview(buffer, line: line))
            buffer += Constants.lineCircleDiameter + 4
        }
        if let st1 = station.stationTogether1 {
            if let s = findStation(st1) {
                for line in s.lineCodes! {
                    linesView.addSubview(getlineSubview(buffer, line: line))
                    buffer += Constants.lineCircleDiameter + 4
                }
            }
        }
        if let st2 = station.stationTogether2 {
            if let s = findStation(st2) {
                for line in s.lineCodes! {
                    linesView.addSubview(getlineSubview(buffer, line: line))
                    buffer += Constants.lineCircleDiameter + 4
                }
            }
        }
        linesView.frame = CGRect(x: 0, y: 0, width: buffer, height: Constants.lineCircleDiameter + 16)
        return linesView
    }
    
    private static func getlineSubview(buffer:CGFloat, line:String) -> UIView {
        let lineView = UIView(frame: CGRect(x: buffer, y: 8, width: Constants.lineCircleDiameter, height: Constants.lineCircleDiameter))
        lineView.layer.cornerRadius = Constants.lineCircleDiameter / 2
        lineView.backgroundColor = stringToColor(line)
        return lineView
    }
    
    static func loadAllStops() {
        Rail.sharedInstance.wrapper.getStopsForLine(nil, success: { (stations:[Station]) in
            Rail.sharedInstance.railStops = stations
        }) { (error:NSError) in
            // TODO: Handle Error
        }
    }
    
    static func deleteFavoriteStationWithStation(station: Station) {
        let result = Rail.sharedInstance.faveStations?.filter({ (obj:NSManagedObject) -> Bool in
            obj.valueForKey("code") as! String == station.code!
        })
        if result?.first != nil {
            deleteFavorite(result!.first!)
        }
    }
    
    static func deleteFavoriteStation(row: Int) {
        deleteFavorite(Rail.sharedInstance.faveStations![row])
    }
    
    static private func deleteFavorite(obj: NSManagedObject) {
        let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        managedContext.deleteObject(obj)
        saveStations(managedContext)
    }
    
    static func getFavoriteStations() {
        let fetchStation = NSFetchRequest(entityName: Constants.stationEntity)
        do {
            let results = try (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext.executeFetchRequest(fetchStation)
            Rail.sharedInstance.faveStations = results as? [NSManagedObject]
        } catch let error {
            debugPrint(error)
        }
    }
    
    static func saveStations(context: NSManagedObjectContext) {
        do {
            try context.save()
            Helper.getFavoriteStations()
        } catch let error {
            debugPrint(error)
        }
    }
    
    static func findStation(code: String) -> Station? {
        if let i = Rail.sharedInstance.railStops?.indexOf({ $0.code == code}) {
            return Rail.sharedInstance.railStops![i]
        }
        return nil
    }
    
    static func getPaletteViewForStationCode(code: String) -> UIView? {
        
        return nil
    }

}

public extension Station {
    
    public func addAttributesFromManagedObj(stop: NSManagedObject) {
        code = stop.valueForKey("code") as? String
        latitude = stop.valueForKey("latitude") as? Double
        longitude = stop.valueForKey("longitude") as? Double
        name = stop.valueForKey("name") as? String
        streetAddress = stop.valueForKey("streetAddress") as? String
        city = stop.valueForKey("city") as? String
        state = stop.valueForKey("state") as? String
        zip = stop.valueForKey("zip") as? String
        lineCodes = [String]()
        for i in 1...4 {
            if let lc = stop.valueForKey("lineCode\(i)") as? String {
                lineCodes?.append(lc)
            }
        }

    }
    
}