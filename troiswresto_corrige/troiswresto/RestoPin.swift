//
//  RestoPin.swift
//  troiswresto
//
//  Created by nicolas on 26/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import Foundation
import MapKit

class Pin: NSObject, MKAnnotation {
    
    var title: String? {
        switch pinType {
        case .Resto:
            return resto!.name
        case .Troiswa:
            return "3WA"
        case .User:
            return "you"
        }
    }
    
    var position : CLLocation
    let pinType: PinType
    let pinImage: UIImage
    let resto : Resto?
    
    init(pinImage : UIImage, pinType : PinType, position : CLLocation, resto: Resto?) {
        self.pinType = pinType
        self.pinImage = pinImage
        self.resto = resto
        self.position = position
        
        super.init()
    }
    
    var coordinate : CLLocationCoordinate2D {
        return self.position.coordinate
    }
    
    //nécessaire si on ne veut pas de subtitle
    var subtitle: String? {
        return ""
    }
}

enum PinType {
    case Resto
    case User
    case Troiswa
}