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
        self.tableView.tableFooterView = UIView()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("lineCell", forIndexPath: indexPath) as! LineTableViewCell
        cell.setupCell(stringToColor(lines![indexPath.row].displayName), name: lines![indexPath.row].displayName!)
        return cell
    }
    
    private func stringToColor(color: String?) -> UIColor {
        if color == "Blue" {
            return UIColor(red: 40/255.0, green: 99/255.0, blue: 178/255.0, alpha: 1.0)
        }
        else if color == "Green" {
            return UIColor(red: 73/255.0, green: 189/255.0, blue: 59/255.0, alpha: 1.0)
        }
        else if color == "Orange" {
            return UIColor(red: 255/255.0, green: 128/255.0, blue: 0, alpha: 1.0)
        }
        else if color == "Red" {
            return UIColor(red: 220/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0)
        }
        else if color == "Silver" {
            return UIColor.grayColor()
        }
        else if color == "Yellow" {
            return UIColor(red: 247/255.0, green: 247/255.0, blue: 21/255.0, alpha: 1.0)
        }
        else {
            return UIColor.whiteColor()
        }
    }
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? StopsTableViewController {
            controller.lineCode = lines![tableView.indexPathForSelectedRow!.row].lineCode
        }
    }

}
