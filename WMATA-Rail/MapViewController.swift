//
//  MapViewController.swift
//  WMATA-Rail
//
//  Created by Dan Hilton on 6/19/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import UIKit
import WMATASwift
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    
    private var stations: [Station]?
    private var stationAnnotations: [MetroAnnotation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Constants.LatDC, longitude: Constants.LonDC), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
        getStations()
    }
    
    private func getStations() {
        Rail.sharedInstance.wrapper.getStopsForLine(nil, success: { (stations:[Station]) in
            self.stations = stations
            dispatch_async(dispatch_get_main_queue(), { 
                self.updateMapUI()
            })
        }) { (error:NSError) in
                // TODO: Error Alert?
        }
    }
    
    private func updateMapUI() {
        if stations != nil && stationAnnotations == nil {
            stationAnnotations = [MetroAnnotation]()
            for s in stations! {
                let annotation = MetroAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: s.latitude!, longitude: s.longitude!)
                annotation.title = s.name
                annotation.subtitle = s.lineCodes?.joinWithSeparator(", ")
                annotation.stationCode = s.code
                self.stationAnnotations!.append(annotation)
            }
        }
        mapView.addAnnotations(stationAnnotations!)
    }
    
    // MARK: - Map View Delegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let metroPoint = annotation as? MetroAnnotation {
            let reuseId = "StationPin"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            else {
                annotationView?.annotation = annotation
            }
            annotationView?.image = UIImage(named: metroPoint.imgName)
            return annotationView
        }
        else {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let metroPoint = view.annotation as? MetroAnnotation {
            if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PredictionViewController") as? PredictionViewController {
                controller.stationCode = metroPoint.stationCode
                controller.stationName = metroPoint.title
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
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