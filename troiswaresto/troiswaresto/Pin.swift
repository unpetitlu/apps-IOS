//
//  Pin.swift
//  troiswaresto
//
//  Created by etudiant-02 on 26/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import MapKit

class Pin: NSObject, MKAnnotation {
    var title: String?
    let location: CLLocation
    var type: pinType
    let resto: Resto
    
    init(title: String?, location: CLLocation, resto: Resto, type : pinType) {
        self.title = title
        self.location = location
        self.resto = resto
        self.type = type
        
        super.init()
    }
    
    var image : UIImage
    {
        var name = "cursor_gris"
        switch self.type {
        case .FavoriteResto:
            name = "cursor_orange"
        case .StandardResto:
            name = "cursor_gris"
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

enum pinType
{
    case FavoriteResto
    case StandardResto
}