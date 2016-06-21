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
    
    private var filteredStops: [RailPath]?
    private var stops: [RailPath]?
    
    var lineCode: String?
    var startCode: String?
    var endCode: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.registerNib(UINib(nibName: "StopTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.stopCellReuseId)
        getStops()
    }

    private func getStops() {
        BaseViewController.showLoading(self.view)
        Rail.sharedInstance.wrapper.getPathBetweenStations(startCode!, toStationCode: endCode!, success: { (path:[RailPath]) in
            self.stops = path
            self.filteredStops = self.stops
            dispatch_async(dispatch_get_main_queue(), {
                BaseViewController.hideLoading()
                self.tableView.reloadData()
            })
        }) { (error:NSError) in
            dispatch_async(dispatch_get_main_queue(), {
                BaseViewController.hideLoading()
                BaseViewController.showErrorAlert("Sorry could not get upcoming arrivals.", vc: self)
            })
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.stopCellReuseId, forIndexPath: indexPath) as! StopTableViewCell
        cell.setupCell(Helper.findStation(filteredStops![indexPath.row].stationCode!)!)
        return cell
    }
    
    // MARK: - Search Bar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterResults(searchText)
    }
    
    private func filterResults(searchText: String) {
        if stops != nil && !searchText.isEmpty {
            filteredStops = self.stops!.filter({ (path:RailPath) -> Bool in
                return path.stationName!.lowercaseString.containsString(searchText.lowercaseString)
            })
        }
        else {
            filteredStops = self.stops
        }
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Constants.stationSegue, sender: nil)
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
                controller.station = Helper.findStation(filteredStops![row].stationCode!)
                controller.isFavorite = Helper.isFavorite(stops![row].stationCode!)
            }
        }
    }

}
