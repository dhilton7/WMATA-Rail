//
//  BaseViewController.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/21/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    private static var loadingView = UIView()
    
    func showLoading() {
        BaseViewController.showLoading(self.view)
    }
    
    class func showLoading(view:UIView) {
        loadingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        loadingView.addSubview(indicator)
        view.addSubview(loadingView)
        indicator.startAnimating()
    }

    func hideLoading() {
        BaseViewController.hideLoading()
    }
    
    class func hideLoading() {
        loadingView.removeFromSuperview()
    }
    
    func showErrorAlert(message:String) {
        BaseViewController.showErrorAlert(message, vc: self)
    }
    
    class func showErrorAlert(message:String, vc: UIViewController) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    

}
