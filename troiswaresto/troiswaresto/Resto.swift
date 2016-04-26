//
//  Resto.swift
//  troiswaresto
//
//  Created by etudiant-02 on 25/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import MapKit

class Resto {
    var restoId : String
    var name : String
    var position: CLLocation
    var description : String?
    var reviews = [Review]()
    var image: UIImage?
    var priceRange: PriceRange?
    var address: String {
        print(position.distanceFromLocation(CLLocation(latitude: 0, longitude: 0)))
        return "\(position.coordinate)"
    }
    var rating: Double {
        var output = 0.0

        if self.reviews.count != 0 {
            for item in self.reviews {
                output += item.rate
            }
            
            output = output / Double(self.reviews.count)
        }
        
        return output
    }
    
    init(restoId: String, name: String, position: CLLocation) {
        self.restoId = restoId
        self.name = name
        self.position = position
    }
}


enum PriceRange {
    case Low
    case Medium
    case High
}