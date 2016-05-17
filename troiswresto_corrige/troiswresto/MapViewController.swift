//
//  MapViewController.swift
//  troiswresto
//
//  Created by nicolas on 26/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
   
    @IBOutlet var mapView : MKMapView!
    @IBOutlet var nameLabel : UILabel?
    
    @IBOutlet var positionLabel : UILabel?
    @IBOutlet var addressLabel : UILabel?
    
    let regionRadius: CLLocationDistance = 600
    
    var screenIndex = ScreenType.AllRestos

    var allRestos = [Resto]() // tous les restos
    var selectedResto : Resto? // Resto selectionné eventuellementreçu de l'écran précédent
    
    let locationManager = CLLocationManager()
    
    var selectedRestoInPin : Resto? //stocke le resto éventuellement selectionné dans un Pin
    
    @IBAction func centerUserButtonPressed() {
        mapView.setCenterCoordinate(mapView.userLocation.coordinate, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        logDebug("region did change")
        addPins()
        updateAddressLabel()
    }
    
    // MARK: - LocationManager
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
        
        if manager.location != nil {
            locationManager.stopUpdatingLocation()
            
            // lancer la requete pour obtenir les stations et afficher les stations les plus proches
            // en utilisant getClosestStations
        }
    }
    
    func updateAddressLabel() {
        logDebug("update position label")
        let centerCoordinates = mapView.centerCoordinate
        positionLabel?.text = "lat:\(centerCoordinates.latitude)\nlong:\(centerCoordinates.longitude)"
        
        let location = CLLocation(latitude: centerCoordinates.latitude, longitude: centerCoordinates.longitude)
        getAdressFromLocation(location) {(address) in
            self.addressLabel?.text = address

        }
    }
    
    // MARK: -
    
    func addPins() {
        let mapCenterPosition = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        mapView.removeAnnotations(mapView.annotations)
    
        let pinImage = UIImage(named: "resto_orange")!
        for resto in allRestos {
            if (mapCenterPosition.distanceFromLocation(resto.position) < regionRadius * 10) {
                
                let myPin = Pin(pinImage: pinImage, pinType: .Resto, position : resto.position, resto: resto)
                mapView.addAnnotation(myPin)
                
            }
        }
        
        let troiswaPin = Pin(pinImage: UIImage(named: "3wa")!, pinType: .Troiswa, position : CLLocation(latitude:48.893915 , longitude:2.354364), resto: nil)
        mapView.addAnnotation(troiswaPin)

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "maptodetail")
        {
            // on obtient une référence vers le ViewController de destination qui se trouve être un RestoDetailViewController
            let mydestination: RestoDetailViewController =  segue.destinationViewController as! RestoDetailViewController
        
            
            // si on a bien une variable, on la passe à la destionation
            if selectedRestoInPin != nil {
                mydestination.resto = selectedRestoInPin!
            }
            
            mydestination.restos = allRestos
        }
        
        if (segue.identifier == "maptoaddresto")
        {
            // on obtient une référence vers le ViewController de destination qui se trouve être un RestoDetailViewController
            let mydestination: AddRestoViewController =  segue.destinationViewController as! AddRestoViewController
            
            mydestination.restoAddress = addressLabel?.text
            mydestination.restoLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addressLabel?.text = " "
        
        updateAddressLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Centrage au départ sur la 3WA
        centerMapOnLocation(CLLocation(latitude: 48.893837, longitude: 2.354370))
        
        if selectedResto != nil && nameLabel != nil {
            nameLabel!.text = selectedResto!.name
        }
        
        showUserLocation()

        addPins()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
                view.centerOffset = CGPoint(x: 0, y: -16)
                view.image = annotation.pinImage
                
                // ajout du label avec le rating uniquement pour les restos
                if annotation.pinType == .Resto && annotation.resto!.rating != nil {
                    let ratingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height * 2 / 3))
                    
                    ratingLabel.textAlignment = NSTextAlignment.Center
                    ratingLabel.textColor = UIColor.whiteColor()
                    ratingLabel.font = UIFont(name: "Arial", size: 12)
                    ratingLabel.text = annotation.resto!.rating!.toFormattedString
                    view.addSubview(ratingLabel)
                }
                
                view.frame.size = CGSize(width: 36, height: 40)
                
                let rightButton = UIButton(type: UIButtonType.DetailDisclosure)
                
                if selectedResto == nil {//on est dans l'écran avec tous les restos
                    view.rightCalloutAccessoryView = rightButton
                }

            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let restoPin = view.annotation as! Pin
        
        logDebug("info for :\(restoPin.title)")
        
        if selectedResto == nil {//on est dans l'écran avec tous les restos
            if restoPin.resto != nil {
                self.selectedRestoInPin = restoPin.resto
                self.performSegueWithIdentifier("maptodetail", sender: self)
            }
        }
        
        
        // mapView.deselectAnnotation(view.annotation, animated: true)
    }
    
}
