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
}