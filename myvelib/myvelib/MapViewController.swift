//
//  MapViewController.swift
//  myvelib
//
//  Created by etudiant-02 on 14/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit
import MapKit
import Flurry_iOS_SDK

class MapViewController: UIViewController {
    
    var centerStation : VelibStation!
    var allVelibStations = [VelibStation]()
    var favorisStations = [Int]()
    @IBOutlet var segmentedControl : UISegmentedControl!
    var selectedSegment: Int!
    
    var indexPage : ScreenType!
    
    @IBOutlet var mapView : MKMapView!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 450
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func indexChanged(sender:UISegmentedControl)  {
        sendAnalyticsEvent("switch-velo-place-segment-control", parameters: ["page" : "\(indexPage)"])
        selectedSegment = segmentedControl.selectedSegmentIndex
        NSUserDefaults.standardUserDefaults().setInteger(selectedSegment, forKey: "selectedSegment")
        loadAllPin()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func addPin(name: String, location: CLLocation, station : VelibStation, type: pinType) {
        let myPin = Pin(title: name,  location: location, station: station, type: type )
        mapView.addAnnotation(myPin)
    }
    // MARK: -
    
    func loadAllPin()
    {
        mapView.removeAnnotations(mapView.annotations)
        
        for index in allVelibStations
        {
            addPin(index.nameStation, location: index.position, station: index, type: favorisStations.indexOf(index.number) != nil ? pinType.FavoriteStation : pinType.StandardStation)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if NSUserDefaults.standardUserDefaults().objectForKey("selectedSegment") != nil
        {
            selectedSegment = NSUserDefaults.standardUserDefaults().integerForKey("selectedSegment")
            segmentedControl.selectedSegmentIndex = selectedSegment
        } else {
            selectedSegment = 0
        }
        
        if centerStation != nil {
            centerMapOnLocation(centerStation.position)
        } else {
            centerMapOnLocation(CLLocation(latitude: 48.8534100, longitude: 2.3488000))
        }
        //mapView.selectAnnotation(mapView.annotations[0], animated: true)

        loadAllPin()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension MapViewController : MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Pin {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: -20)//position du popup par rapport à l'image
                
                //pour bien placer le pin
                view.centerOffset = CGPoint(x: 0, y: -22)
                
                view.image = annotation.image
                
                let rightButton = UIButton(type: UIButtonType.Custom)
                rightButton.setBackgroundImage(UIImage(named: favorisStations.indexOf(annotation.station.number) != nil ? "fleche_pleine" : "fleche_creuse"), forState: .Normal)
                
                rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                
                view.rightCalloutAccessoryView = rightButton
                //view.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "icon_parking"))
                
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 36, height: 30))
                label.textAlignment = NSTextAlignment.Center
                label.textColor = UIColor.whiteColor()
                label.text = "\(selectedSegment == 0 ? annotation.station.bikeAvailable : annotation.station.bikeStandAvailable)"
                view.addSubview(label)
                
                view.frame.size = CGSize(width: 36, height: 45)
            }
            return view
        }
        return nil
    }
    	
    // When i click on tooltip
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let myStationPin = view.annotation as! Pin
        
        if let index = favorisStations.indexOf(myStationPin.station.number) {
            favorisStations.removeAtIndex(index)
            Flurry.logEvent("remove-velib-station", withParameters: ["page" : "\(indexPage)"]);
        }
        else {
            
            favorisStations.append(myStationPin.station.number)
            Flurry.logEvent("add-velib-station", withParameters: ["page" : "\(indexPage)"]);
        }
        
        saveNSUserDefaultsVelib()
        
        loadAllPin()
    }
    
    func saveNSUserDefaultsVelib()
    {
        switch indexPage! {
            case .Home:
                NSUserDefaults.standardUserDefaults().setObject(favorisStations, forKey: "velibHome")
            case .Work:
                NSUserDefaults.standardUserDefaults().setObject(favorisStations, forKey: "velibWork")
            case .Geoloc:
                NSUserDefaults.standardUserDefaults().setObject(favorisStations, forKey: "velibGeoloc")
        }
    }
}