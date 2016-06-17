//
//  LinesCollectionViewController.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/15/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit
import WMATASwift

private let reuseIdentifier = "Cell"

class LinesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var lines: [Line]?
    
    var selectedCellRow: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        getLines()
    }

    private func getLines() {
        Rail.sharedInstance.wrapper.getTrainLines({ (lines:[Line]) in
            self.lines = lines
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView?.reloadData()
            })
        }) { (error:NSError) in
            
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? StopsTableViewController {
            controller.lineCode = lines![selectedCellRow!].lineCode
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lines?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("lineCell", forIndexPath: indexPath) as! LineCollectionViewCell
        cell.setupCell(stringToColor(lines![indexPath.row].displayName))
        return cell
    }
    
    private func stringToColor(color: String?) -> UIColor {
        if color == "Blue" {
            return UIColor(red: 40/255.0, green: 99/255.0, blue: 178/255.0, alpha: 1.0)
        }
        else if color == "Green" {
            return UIColor(red: 17/255.0, green: 219/255.0, blue: 111/255.0, alpha: 1.0)
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        selectedCellRow = indexPath.row
        return true
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let side = (self.view.frame.width - 16) / 2
        return CGSize(width: side, height: side)
    }
}
