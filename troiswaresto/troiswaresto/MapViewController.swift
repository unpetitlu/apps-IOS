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
    
    
    // Ajout de IBOutlet optionnel car il existe uniquement sur la map permettant d'ajouter un resto
    @IBOutlet var addressLabel : UILabel?
    @IBOutlet var addRestoButton: UIButton?
    
    
    var allRestos = [Resto]()
    var selectedRestoInMap : Resto!
    
    // Permet de savoir sur quel map on se trouve
    var screenType = ScreenType.AllRestos
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 450
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func buttonCenterGeolocPressed() {
        showUserLocation()
        //Pour centrer la carte sur la position du user
        mapView.setCenterCoordinate(mapView.userLocation.coordinate, animated: true)
    }
    
    
    func addPin(name: String, location: CLLocation, resto : Resto, type: pinType) {
        let myPin = Pin(title: name, location: location, resto: resto, type: type )
        mapView.addAnnotation(myPin)
    }
    
    func loadAllPin() {
        mapView.removeAnnotations(mapView.annotations)
        
        // Récupère la position de la map
        //let mapCenterPosition = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        for index in allRestos
        {
            // Rajouter ce if si l'on souhaite afficher uniquement les restos dans un rayon donné
            /*
            if mapCenterPosition.distanceFromLocation(station.position) <= (regionRadius*2) {
                addPin(pinType, myStation: station)
            }
            */
            
            
            addPin(index.name, location: index.position, resto: index, type: pinType.StandardResto)
        }
        
        showUserLocation()
        
        if screenType == .OneResto {
            // affiche la petite bulle lorsqu'on a qu'un seul resto
            mapView.selectAnnotation(mapView.annotations[0], animated: true)
        }
    }
    
    
    // MARK: - Map pour ajouter un resto
    func getAdressFromLocation (location : CLLocation, completion:(String)->Void ) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            var output = ""
            if (error != nil) {
                logError("Reverse geocoder failed with error" + error!.localizedDescription)
                output = "error"
            } else {
                
                if placemarks!.count > 0 {
                    let pm = placemarks![0] as CLPlacemark
                    if pm.thoroughfare != nil && pm.subThoroughfare != nil {
                        output =  pm.subThoroughfare! + " " + pm.thoroughfare!
                    } else {
                        output = ""
                    }
                } else {
                    output = "error"
                }
            }
            completion(output)
        })
    }
    
    func updateAddressLabel() {
        let centerCoordinates = mapView.centerCoordinate
        
        let location = CLLocation(latitude: centerCoordinates.latitude, longitude: centerCoordinates.longitude)
        
        getAdressFromLocation(location) {(address) in
            self.addressLabel?.text = address
            self.addressLabel?.hidden = false
        }
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        logDebug("region did change")
        //addPins()//à voir
        
        updateAddressLabel()
        
    }
    // MARK: -
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadAllPin()
        
        
        // Uniquement pour la map qui permet d'ajouter un resto
        self.addressLabel?.hidden = false
        updateAddressLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toRestoInfoFromMap")
        {
            let mydestination: DetailViewController = segue.destinationViewController as! DetailViewController
            mydestination.resto = selectedRestoInMap // pour récupérer un resto
            //mydestination.restosViewController = self// JE SUIS TON PERE (dit le RestosVC au RestoDetailVC)
        } else if segue.identifier == "toaddresto" {
            let mydestination: AddRestoViewController = segue.destinationViewController as! AddRestoViewController
            mydestination.newRestoAdress = (addressLabel?.text)!

            let centerCoordinates = mapView.centerCoordinate
            let location = CLLocation(latitude: centerCoordinates.latitude, longitude: centerCoordinates.longitude)
            mydestination.newRestoPosition = location
        }
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
        // manager.location! => permet de récupérer la position du user
        if let locationUser = manager.location {
            
            //Si je viens de la page detail d'un resto alors je me centre sur celui-ci au lieu de me centrer sur l'utilisateur
            if screenType == .OneResto {
                centerMapOnLocation(allRestos[0].position)
            } else {
                centerMapOnLocation(locationUser)
            }
            
            locationManager.stopUpdatingLocation() // Stop l'écoute
            
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
        
        // Récupération du resto sur lequel on clique pour rediriger vers le detail
        // Si on vient déjà du detail on ne le fais pas
        
        if screenType != .OneResto {
            let myPinResto = view.annotation as! Pin
            selectedRestoInMap = myPinResto.resto
            self.performSegueWithIdentifier("toRestoInfoFromMap", sender: self)
        }
        
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