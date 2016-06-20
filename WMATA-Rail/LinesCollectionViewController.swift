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
        cell.setupCell(Rail.sharedInstance.stringToColor(lines![indexPath.row].displayName))
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
