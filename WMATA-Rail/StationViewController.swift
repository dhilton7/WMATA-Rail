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

class StationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var linesView: UIView!
    
    private var trains: [Train]?
    
    private var addFaveButton: UIBarButtonItem!
    private var removeFaveButton: UIBarButtonItem!
    
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
        
        getPrediction()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let linesSubView = Helper.getLinesView(station!)
        linesSubView.center.x = self.linesView.frame.width / 2
        self.linesView.addSubview(linesSubView)
    }

    private func getPrediction() {
        
        Rail.sharedInstance.wrapper.getNextTrain(station?.code, success: { (trains:[Train]) in
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
    
    private func addfavoriteStation() {
        let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName("Station", inManagedObjectContext: managedContext)
        let station = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        station.setValue(self.station?.code, forKey: "code")
        station.setValue(self.station?.name, forKey: "name")
        station.setValue(self.station?.longitude, forKey: "longitude")
        station.setValue(self.station?.latitude, forKey: "latitude")
        station.setValue(self.station?.streetAddress, forKey: "streetAddress")
        station.setValue(self.station?.city, forKey: "city")
        station.setValue(self.station?.state, forKey: "state")
        station.setValue(self.station?.zip, forKey: "zip")
        for (i, lineCode) in self.station!.lineCodes!.enumerate() {
            station.setValue(lineCode, forKey:"lineCode\(i+1)")
        }
        
        do {
            try managedContext.save()
            Rail.sharedInstance.faveStations?.append(station)
        } catch let error {
            debugPrint(error)
        }
    }
    
    @IBAction func toggleFavorite(sender: AnyObject) {
        let fave = isFavorite ?? false
        if fave == false {
            self.addfavoriteStation()
        }
        else {
            Helper.deleteFavoriteStationWithStation(self.station!)
        }
        isFavorite = !fave
        let btn = isFavorite! == true ? removeFaveButton : addFaveButton
        navigationItem.setRightBarButtonItem(btn, animated: false)
    }

}
