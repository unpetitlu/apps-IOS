//
//  Model.swift
//  myvelib
//
//  Created by etudiant-02 on 13/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import Alamofire
import SwiftyJSON
import MapKit

// Récupère l'intégralité des stations velib
// completionHandler permet de créer une closure. Celle-ci retournera tous les velibs uniquement lorsque la requête asynchrone sera terminée
func getStationsInfo(stationsIds: [Int], completionHandler : (stations : [VelibStation], allStations: [VelibStation]) -> () )
{
    var output = [VelibStation]()
    var allStations = [VelibStation]()
    let urlString = "\(APIURL)/stations?contract=\(APICONTRACT)&apiKey=\(APIKEY)"
    
    Alamofire.request(.GET, urlString, parameters : nil)
        .response { (request, response, data, error) in
            
            if (error == nil) {
                let json = JSON(data: data!)

                for index in 0..<json.count {
                    if let number = json[index]["number"].number {

                            if  let available_bike_stands = json[index]["available_bike_stands"].number,
                                let available_bikes = json[index]["available_bikes"].number,
                                let name = json[index]["name"].string,
                                let positionLat = json[index]["position"]["lat"].double,
                                let positionLng = json[index]["position"]["lng"].double
                            {
                                let velib = VelibStation(number : Int(number), nameStation: name, bikeAvailable: Int(available_bikes), bikeStandAvailable: Int(available_bike_stands), position: CLLocation(latitude: positionLat, longitude: positionLng) )
                                
                                allStations.append(velib)
                                
                                if stationsIds.indexOf(Int(number)) != nil {
                                    output.append(velib)
                                }
                                
                            } else {
                                sendAnalyticsEvent("error-request-api-velib", parameters: ["errorAPI" : "values"])
                        }
                    }
                }
            } else {
                sendAnalyticsEvent("error-request-api-velib", parameters: ["errorAPI" : "request"])
            }
            
            // Retourne la closure lorsque la requête asynchrone se termine
            completionHandler(stations: output, allStations: allStations)
            
    }
    
}

func getStationsIds(pageIndex : ScreenType) -> [Int] {
    var output = [Int]()
    
    switch pageIndex {
        case .Home:
            if NSUserDefaults.standardUserDefaults().objectForKey("velibHome") != nil
            {
                output = NSUserDefaults.standardUserDefaults().objectForKey("velibHome") as! [Int]
            }
        case .Work:
            if NSUserDefaults.standardUserDefaults().objectForKey("velibWork") != nil
            {
                output = NSUserDefaults.standardUserDefaults().objectForKey("velibWork") as! [Int]
            }
        case .Geoloc:
            if NSUserDefaults.standardUserDefaults().objectForKey("velibGeoloc") != nil
            {
                output = NSUserDefaults.standardUserDefaults().objectForKey("velibGeoloc") as! [Int]
            }
    }
    
    return output
}

enum ScreenType
{
    case Home
    case Work
    case Geoloc
}

enum pinType
{
    case FavoriteStation
    case StandardStation
}

class Pin: NSObject, MKAnnotation {
    var title: String?
    let location: CLLocation
    var type: pinType
    let station: VelibStation
    
    init(title: String?, location: CLLocation, station: VelibStation, type : pinType) {
        self.title = title
        self.location = location
        self.station = station
        self.type = type
        
        super.init()
    }
    
    var image : UIImage
    {
        var name = "station_grise"
        switch self.type {
            case .FavoriteStation:
                name = "station_orange"
            case .StandardStation:
                name = "station_grise"
        }
        
        return UIImage(named: name)!;
    }
    
    var coordinate : CLLocationCoordinate2D {
        return self.location.coordinate
    }
    
    //nécessaire si on ne veut pas de subtitle
    var subtitle: String? {
        return ""
    }
}


func getClosestStation(velibStations : [VelibStation], userPosition: CLLocation, number: Int) -> [VelibStation] {
    var output = [VelibStation]()
    
    // Mettre à jour la distance d'une station par rapport à un user
    for station in velibStations {
        station.setDistanceToUser(userPosition)
    }

    // Trier le tableau des velib par rapport à la distance de l'utilisateur
    let sortedStations = velibStations.sort({ $0.distanceToUser < $1.distanceToUser })

    // récupère les "number" premiers éléments
    for index in 0..<number {
        if index < sortedStations.count - 1 {
            output.append(sortedStations[index])
        }
    }
    
    return output
}
