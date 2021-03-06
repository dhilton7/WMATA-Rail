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
    
    /*
        Checks is station is a favorite or not
    */
    static func isFavorite(stationCode: String) -> Bool {
        return Rail.sharedInstance.faveStations?.contains({ $0.valueForKey("code") as! String == stationCode }) ?? false
    }
    
    /*
        Convert color string to UIColor
    */
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
    
    /*
        Return view with colors of lines the station services
    */
    static func getLinesView(station: Station) -> UIView {
        let linesView = UIView()
        var buffer: CGFloat = 4
        buffer = iterateLineCodes(station.lineCodes!, linesView: linesView, buffer: buffer)
        if let st1 = station.stationTogether1 {
            if let s = findStation(st1) {
                buffer = iterateLineCodes(s.lineCodes!, linesView: linesView, buffer: buffer)
            }
        }
        if let st2 = station.stationTogether2 {
            if let s = findStation(st2) {
                buffer = iterateLineCodes(s.lineCodes!, linesView: linesView, buffer: buffer)
            }
        }
        linesView.frame = CGRect(x: 0, y: 0, width: buffer, height: Constants.lineCircleDiameter + 16)
        return linesView
    }
    
    /*
        Helper function to iterate through line codes and add appropriate subviews
    */
    static func iterateLineCodes(lineCodes: [String], linesView: UIView, buffer: CGFloat) -> CGFloat {
        var newBuffer = buffer
        for line in lineCodes {
            linesView.addSubview(getlineSubview(newBuffer, line: line))
            newBuffer += Constants.lineCircleDiameter + 4
        }
        return newBuffer
    }
    
    /**
        Helper to return single line color view
    */
    private static func getlineSubview(buffer:CGFloat, line:String) -> UIView {
        let lineView = UIView(frame: CGRect(x: buffer, y: 8, width: Constants.lineCircleDiameter, height: Constants.lineCircleDiameter))
        lineView.layer.cornerRadius = Constants.lineCircleDiameter / 2
        lineView.backgroundColor = stringToColor(line)
        return lineView
    }
    
    /*
        Load all stops to Rail shared instance
    */
    static func loadAllStops() {
        Rail.sharedInstance.wrapper.getStopsForLine(nil, success: { (stations:[Station]) in
            Rail.sharedInstance.railStops = stations
        }) { (error:NSError) in
            // TODO: Handle error
        }
    }
    
    /*
        Delete a favorite given a station object
    */
    static func deleteFavoriteStationWithStation(station: Station) {
        let result = Rail.sharedInstance.faveStations?.filter({ (obj:NSManagedObject) -> Bool in
            obj.valueForKey("code") as! String == station.code!
        })
        if result?.first != nil {
            deleteFavorite(result!.first!)
        }
    }
    
    /*
        Delete a favorite given index of the favorite in the array
    */
    static func deleteFavoriteStation(row: Int) {
        deleteFavorite(Rail.sharedInstance.faveStations![row])
    }
    
    /*
        Helper function to remove NSManagedObject
    */
    static private func deleteFavorite(obj: NSManagedObject) {
        let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        managedContext.deleteObject(obj)
        saveStations(managedContext)
    }
    
    /*
        Fetch favorite stations from Core Data and saved to Rail shared instance
    */
    static func getFavoriteStations() {
        let fetchStation = NSFetchRequest(entityName: Constants.stationEntity)
        do {
            let results = try (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext.executeFetchRequest(fetchStation)
            Rail.sharedInstance.faveStations = results as? [NSManagedObject]
        } catch let error {
            debugPrint(error)
        }
    }
    
    /*
        Add station to favorites list and save in Core Data
    */
    static func addfavoriteStation(station: Station) {
        let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName("Station", inManagedObjectContext: managedContext)
        let stop = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        stop.setValue(station.code, forKey: "code")
        stop.setValue(station.name, forKey: "name")
        stop.setValue(station.longitude, forKey: "longitude")
        stop.setValue(station.latitude, forKey: "latitude")
        stop.setValue(station.streetAddress, forKey: "streetAddress")
        stop.setValue(station.city, forKey: "city")
        stop.setValue(station.state, forKey: "state")
        stop.setValue(station.zip, forKey: "zip")
        stop.setValue(station.stationTogether1, forKey: "stationTogether1")
        stop.setValue(station.stationTogether2, forKey: "stationTogether2")
        for (i, lineCode) in station.lineCodes!.enumerate() {
            stop.setValue(lineCode, forKey:"lineCode\(i+1)")
        }
        
        do {
            try managedContext.save()
            Rail.sharedInstance.faveStations?.append(stop)
        } catch let error {
            debugPrint(error)
        }
    }
    
    /*
        Save context for given NSManagedObjectContext
    */
    static func saveStations(context: NSManagedObjectContext) {
        do {
            try context.save()
            Helper.getFavoriteStations()
        } catch let error {
            debugPrint(error)
        }
    }
    
    /*
        Find and return a Station object based on the station code
    */
    static func findStation(code: String) -> Station? {
        if let i = Rail.sharedInstance.railStops?.indexOf({ $0.code == code}) {
            return Rail.sharedInstance.railStops![i]
        }
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
        stationTogether1 = stop.valueForKey("stationTogether1") as? String
        stationTogether2 = stop.valueForKey("stationTogether2") as? String
        lineCodes = [String]()
        for i in 1...4 {
            if let lc = stop.valueForKey("lineCode\(i)") as? String {
                lineCodes?.append(lc)
            }
        }

    }
    
}