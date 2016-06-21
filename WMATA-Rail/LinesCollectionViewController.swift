//
//  LinesCollectionViewController.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/15/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit
import WMATASwift

class LinesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var lines: [Line]?
    private let reuseIdentifier = "lineCell"

    var selectedCellRow: Int?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if lines == nil {
            getLines()
        }
    }

    private func getLines() {
        BaseViewController.showLoading(self.view)
        Rail.sharedInstance.wrapper.getTrainLines({ (lines:[Line]) in
            self.lines = lines
            dispatch_async(dispatch_get_main_queue(), {
                BaseViewController.hideLoading()
                self.collectionView?.reloadData()
            })
        }) { (error:NSError) in
            dispatch_async(dispatch_get_main_queue(), {
                BaseViewController.hideLoading()
                BaseViewController.showErrorAlert("Sorry could not get upcoming arrivals.", vc: self)
            })
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? StopsTableViewController {
            controller.lineCode = lines![selectedCellRow!].lineCode
            controller.startCode = lines![selectedCellRow!].startStationCode
            controller.endCode = lines![selectedCellRow!].endStationCode
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! LineCollectionViewCell
        cell.setupCell(Helper.stringToColor(lines![indexPath.row].displayName))
        return cell
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
