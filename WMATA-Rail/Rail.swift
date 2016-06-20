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
    
    static let sharedInstance = Rail()
    private init() {}  //This prevents others from using the default '()' initializer for this class.
    
    func getFavoriteStations() {
        let fetchStation = NSFetchRequest(entityName: Constants.stationEntity)
        do {
            let results = try (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext.executeFetchRequest(fetchStation)
            Rail.sharedInstance.faveStations = results as? [NSManagedObject]
        } catch let error {
            debugPrint(error)
        }
    }
    
    func saveStations(context: NSManagedObjectContext) {
        do {
            try context.save()
            getFavoriteStations()
        } catch let error {
            debugPrint(error)
        }
    }
    
    func isFavorite(stationCode: String) -> Bool {
        return self.faveStations?.contains({ $0.valueForKey("code") as! String == stationCode }) ?? false
    }
    
    func stringToColor(color: String?) -> UIColor {
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
    
}