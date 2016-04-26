//
//  MapViewController.swift
//  troiswaresto
//
//  Created by etudiant-02 on 26/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView : MKMapView!
    
    var allRestos = [Resto]()
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 450
    
    
    func addPin(name: String, location: CLLocation, resto : Resto, type: pinType) {
        let myPin = Pin(title: name, location: location, resto: resto, type: type )
        mapView.addAnnotation(myPin)
    }
    
    func loadAllPin() {
        mapView.removeAnnotations(mapView.annotations)
        
        for index in allRestos
        {
            addPin(index.name, location: index.position, resto: index, type: pinType.StandardResto)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAllPin()
        
        showUserLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - LocationManager
    
    // permet de localiser l'utilisateur en lui posant la question que l'on retrouve dans le Info.plist
    func showUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    // cette fonction écoute le changement de position du user
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        logDebug("did update location")

        if let locationUser = manager.location {
            centerMapOnLocation(locationUser)
            
            locationManager.stopUpdatingLocation()
            
            // lancer la requete pour obtenir les restos
        }
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    // MARK: -
}


extension MapViewController : MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Pin {
            
            // On ne sait pas à quoi ça sert. Ainsi que le code dans le if
            // Le code dans le else est par contre utilisable afin de custom la Pin
            
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: -20) //position du popup par rapport à l'image
                
                //pour bien placer le pin
                view.centerOffset = CGPoint(x: 0, y: -22)
                view.image = annotation.image
                
                let rightButton = UIButton(type: UIButtonType.InfoLight)
                
                // Si on souhaite mettre une image, il faut utiliser UIButtonType.Custom à la ligne du dessus et écrire cette ligne en dessous
                /*
                rightButton.setBackgroundImage(UIImage(named: favorisStations.indexOf(annotation.station.number) != nil ? "fleche_pleine" : "fleche_creuse"), forState: .Normal)
                */
                
                rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                
                view.rightCalloutAccessoryView = rightButton
                //view.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "icon_parking"))
                
                
                // decommenter le code ci-dessous si l'on veut insérer du texte dans la pin (icone)
                /*
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 36, height: 30))
                label.textAlignment = NSTextAlignment.Center
                label.textColor = UIColor.whiteColor()
                label.text = "Ecrire du texte à mettre dans la pin"
                view.addSubview(label)
                */
                
                view.frame.size = CGSize(width: 36, height: 45)
            }
            return view
        }
        return nil
    }
    
    // When i click on tooltip
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        /*
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
        */
    }
}