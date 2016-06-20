//
//  StopsTableViewController.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/15/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit
import WMATASwift

class StopsTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var lineCode: String?
    private var stops: [Station]?
    private var filteredStops: [Station]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        getStops()
    }

    private func getStops() {
        Rail.sharedInstance.wrapper.getStopsForLine(self.lineCode, success: { (stations:[Station]) in
            self.stops = stations
            self.filteredStops = stations
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }) { (error:NSError) in
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredStops?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("stopCell", forIndexPath: indexPath)
        cell.textLabel?.text = filteredStops![indexPath.row].name
        return cell
    }
    
    // MARK: - Search Bar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterResults(searchText)
    }
    
    private func filterResults(searchText: String) {
        if stops != nil && !searchText.isEmpty {
            filteredStops = self.stops!.filter({ (station:Station) -> Bool in
                return station.name!.lowercaseString.containsString(searchText.lowercaseString)
            })
        }
        else {
            filteredStops = self.stops
        }
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? StationViewController {
            if let row = tableView.indexPathForSelectedRow?.row {
                controller.station = stops![row]
            }
        }
    }

}
