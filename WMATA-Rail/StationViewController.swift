//
//  PredictionViewController.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/15/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit
import WMATASwift
import CoreData

class StationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var linesView: UIView!
    
    private var trains: [Train]?
    private var addFaveButton: UIBarButtonItem!
    private var removeFaveButton: UIBarButtonItem!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshTable:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    var station: Station?
    var isFavorite: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = station?.name
        self.tableView.tableFooterView = UIView()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.addFaveButton = UIBarButtonItem(image: UIImage(named: "FavoriteEmpty.png"), style: .Plain, target: self, action: "toggleFavorite:")
        self.removeFaveButton = UIBarButtonItem(image: UIImage(named: "FavoriteFilled.png"), style: .Plain, target: self, action: "toggleFavorite:")
        
        let btn = isFavorite! == true ? removeFaveButton : addFaveButton
        navigationItem.setRightBarButtonItem(btn, animated: false)
        
        self.tableView.addSubview(refreshControl)
        
        getPrediction()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let linesSubView = Helper.getLinesView(station!)
        linesSubView.center.x = self.linesView.frame.width / 2
        self.linesView.addSubview(linesSubView)
    }

    private func getPrediction() {
        var codes = "\(station!.code!)"
        if !(station?.stationTogether1 ?? "").isEmpty {
            codes = codes.stringByAppendingString(",\(station!.stationTogether1!)")
        }
        if !(station?.stationTogether2 ?? "").isEmpty {
            codes = codes.stringByAppendingString(",\(station!.stationTogether2!)")
        }
        Rail.sharedInstance.wrapper.getNextTrain(codes, success: { (trains:[Train]) in
            self.trains = trains
            self.filterUnknownTrains()
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            })
        }) { (error:NSError) in
            dispatch_async(dispatch_get_main_queue(), {
                self.showErrorAlert("Sorry could not get upcoming arrivals.")
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    private func filterUnknownTrains() {
        self.trains = trains?.filter({ (train:Train) -> Bool in
            return !(train.min?.lowercaseString == "unknown" || (train.min?.lowercaseString.isEmpty ?? true) || train.destinationName?.lowercaseString == "train" || train.destinationName?.lowercaseString == "no passenger" )
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trains?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("predictionCell") as! PredictionTableViewCell
        cell.setupCell(self.trains![indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
        let label = UILabel(frame: CGRect(x: 16, y: 4, width: 0, height: 0))
        label.text = "Upcoming Arrivals"
        label.font = UIFont(name: "AvenirNext-Medium", size: 18.0)!
        label.sizeToFit()
        headerView.addSubview(label)
        headerView.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 232/255.0, alpha: 1.0)
        return headerView
    }
    
    func refreshTable(sender: AnyObject) {
        getPrediction()
    }
    
    @IBAction func toggleFavorite(sender: AnyObject) {
        let fave = isFavorite ?? false
        if fave == false {
            Helper.addfavoriteStation(self.station!)
        }
        else {
            Helper.deleteFavoriteStationWithStation(self.station!)
        }
        isFavorite = !fave
        let btn = isFavorite! == true ? removeFaveButton : addFaveButton
        navigationItem.setRightBarButtonItem(btn, animated: false)
    }

}
