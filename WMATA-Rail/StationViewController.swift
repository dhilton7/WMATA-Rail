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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("predictionCell")!
        cell.textLabel?.text = "\(trains![indexPath.row].destinationName!)- \(trains![indexPath.row].minString())"
        return cell
    }
    
    private func addfavoriteStation() {
        let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName("Station", inManagedObjectContext: managedContext)
        let station = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        station.setValue(self.station?.code, forKey: "code")
        station.setValue(self.station?.name, forKey: "name")
        station.setValue(self.station?.longitude, forKey: "longitude")
        station.setValue(self.station?.latitude, forKey: "latitude")
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
            // Delete from favorite
            
        }
        isFavorite = !fave
        let btn = isFavorite! == true ? removeFaveButton : addFaveButton
        navigationItem.setRightBarButtonItem(btn, animated: false)
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
