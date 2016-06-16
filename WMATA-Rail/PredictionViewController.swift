//
//  PredictionViewController.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/15/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit
import WMATASwift

class PredictionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var trains: [Train]?
    
    var stationCode: String?
    var stationName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = stationName
        getPrediction()
    }

    private func getPrediction() {
        
        Rail.sharedInstance.wrapper.getNextTrain(stationCode, success: { (trains:[Train]) in
            
            self.trains = trains
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }) { (error:NSError) in
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trains?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("predictionCell")!
        cell.textLabel?.text = trains![indexPath.row].minString()
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
