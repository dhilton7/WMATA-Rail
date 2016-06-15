//
//  LinesTableViewController.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/15/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit
import WMATASwift

class LinesTableViewController: UITableViewController {

    private var lines: [Line]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getLines()
    }

    private func getLines() {
        Rail.sharedInstance.wrapper.getTrainLines({ (lines:[Line]) in
            self.lines = lines
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
        return self.lines?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("lineCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.lines![indexPath.row].displayName

        return cell
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? StopsTableViewController {
            controller.lineCode = lines![tableView.indexPathForSelectedRow!.row].lineCode
        }
    }

}