//
//  VelibStation.swift
//  myvelib
//
//  Created by etudiant-02 on 12/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import CoreLocation

class VelibStation {
    var number : Int
    var nameStation : String
    var bikeAvailable : Int
    var bikeStandAvailable : Int
    var position = CLLocation()
    var distanceToUser : CLLocationDistance?
    
    init (number : Int, nameStation : String, bikeAvailable : Int, bikeStandAvailable : Int, position: CLLocation)
    {
        self.number = number
        self.nameStation = nameStation
        self.bikeAvailable = bikeAvailable
        self.bikeStandAvailable = bikeStandAvailable
        self.position = position
    }
    
    // Calcul la distance entre une station velib et la position de l'utilisateur
    func setDistanceToUser(userPosition: CLLocation)
    {
        self.distanceToUser = userPosition.distanceFromLocation(self.position)
    }
}