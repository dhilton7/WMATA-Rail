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
    
    private var favorites: [Station]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationItem.leftBarButtonItem = self.editButtonItem()
        tableView.registerNib(UINib(nibName: "StopTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.stopCellReuseId)
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if Rail.sharedInstance.faveStations != nil {
            favorites = [Station]()
            for s in Rail.sharedInstance.faveStations! {
                let ns = Station()
                ns.addAttributesFromManagedObj(s)
                self.favorites!.append(ns)
            }
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.stopCellReuseId, forIndexPath: indexPath) as! StopTableViewCell
        cell.setupCell(favorites![indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Constants.stationSegue, sender: indexPath.row)
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            favorites?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            Helper.deleteFavoriteStation(indexPath.row)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? StationViewController {
            if let index = tableView.indexPathForSelectedRow?.row {
                let station = Station()
                let stop = Rail.sharedInstance.faveStations![index]
                station.addAttributesFromManagedObj(stop)
                controller.station = station
                controller.isFavorite = true
            }
        }
    }

}
