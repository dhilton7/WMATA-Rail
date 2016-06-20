//
//  FavoriteTableViewController.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/20/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit
import WMATASwift
import CoreData

class FavoriteTableViewController: UITableViewController {
    
    private var favoriteStations: [NSManagedObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.favoriteStations = Rail.sharedInstance.faveStations
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteStations?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("faveCell", forIndexPath: indexPath)
        if let name = favoriteStations?[indexPath.row].valueForKey("name") as? String {
            cell.textLabel?.text = name
        }
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.deleteFavoriteStation(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    private func deleteFavoriteStation(row: Int) {
        let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        managedContext.deleteObject(favoriteStations![row])
        favoriteStations!.removeAtIndex(row)
        Rail.sharedInstance.saveStations(managedContext)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? StationViewController {
            if let index = tableView.indexPathForSelectedRow?.row {
                let station = Station()
                let stop = Rail.sharedInstance.faveStations![index]
                station.code = stop.valueForKey("code") as? String
                station.latitude = stop.valueForKey("latitude") as? Double
                station.longitude = stop.valueForKey("longitude") as? Double
                station.name = stop.valueForKey("name") as? String
                controller.station = station
                controller.isFavorite = true
            }
        }
    }

}
