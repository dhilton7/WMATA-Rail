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
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    private var stations: [Station]?
    private var stationAnnotations: [MetroAnnotation]?
    private var latestLocation: CLLocation?
    private var manager: CLLocationManager?
    
    private let lineCircleDiameter: CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CLLocationManager()
        manager?.delegate = self
        manager?.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        mapView.showsUserLocation = true

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
        if latestLocation != nil {
            mapView.setRegion(MKCoordinateRegion(center: latestLocation!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)), animated: false)
        }
        if stations != nil && stationAnnotations == nil {
            stationAnnotations = [MetroAnnotation]()
            for s in stations! {
                let annotation = MetroAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: s.latitude!, longitude: s.longitude!)
                annotation.title = s.name
                annotation.station = s
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
                let linesView = UIView()
                var buffer: CGFloat = 4
                for line in metroPoint.station!.lineCodes! {
                    let lineView = UIView(frame: CGRect(x: buffer, y: 8, width: lineCircleDiameter, height: lineCircleDiameter))
                    lineView.layer.cornerRadius = lineCircleDiameter / 2
                    lineView.backgroundColor = Rail.sharedInstance.stringToColor(line)
                    linesView.addSubview(lineView)
                    buffer += lineCircleDiameter + 4
                }
                linesView.frame = CGRect(x: 0, y: 0, width: buffer, height: lineCircleDiameter + 16)
                annotationView?.leftCalloutAccessoryView = linesView
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
            if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StationViewController") as? StationViewController {
                controller.station = metroPoint.station
                controller.isFavorite = Rail.sharedInstance.isFavorite(metroPoint.station!.code!)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    // MARK: Location Manager Delegate
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        manager.stopUpdatingLocation()
        self.latestLocation = newLocation
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
        else if status == .Denied {
            mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Constants.LatDC, longitude: Constants.LonDC), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
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
