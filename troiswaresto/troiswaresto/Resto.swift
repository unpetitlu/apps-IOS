//
//  Resto.swift
//  troiswaresto
//
//  Created by etudiant-02 on 25/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import MapKit
import Firebase

class Resto {
    var restoId : String
    var name : String
    var position: CLLocation
    var description : String?
    var reviews = [Review]()
    var image: UIImage?
    var priceRange: PriceRange?
    var address: String?
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
    
    func addReview(rate : Double, comment : String?, author : String?, dateReview: String?, completionHandler: (success:Bool) ->()) {
        
        let nodeCurrentResto = Firebase(url: "\(ROOTFIREBASEURL)/data/restos/\(self.restoId)/reviews")
        let reviewRef = nodeCurrentResto.childByAutoId()

        if author != nil {
            reviewRef.childByAppendingPath("nickname").setValue("\(author!)")
        }
        
        if comment != nil {
            reviewRef.childByAppendingPath("comment").setValue("\(comment!)")
        }
        
        if dateReview != nil {
            reviewRef.childByAppendingPath("dateOfReview").setValue("\(dateReview!)")
        }
        
        reviewRef.childByAppendingPath("rate").setValue(rate) { (error, nodeRef) in
            if error != nil {
                completionHandler(success: false)
            } else {
                completionHandler(success: true)
            }
        }
        
    }
    
    init(restoId: String, name: String, position: CLLocation) {
        self.restoId = restoId
        self.name = name
        self.position = position
    }
}

func addRestoToFireBase(name: String, address: String, position: CLLocation, restoImage: String?, description : String, completionHandler: (success:Bool) ->()) {
    
    // TODO : insérer le nom et si tout marche bien j'insère les autres
    
    let nodeCurrentResto = Firebase(url: "\(ROOTFIREBASEURL)/data/restos")
    let reviewChild = nodeCurrentResto.childByAutoId()
    
    reviewChild.childByAppendingPath("address").setValue(address)
    reviewChild.childByAppendingPath("description").setValue(description)
    reviewChild.childByAppendingPath("image").setValue(restoImage)
    reviewChild.childByAppendingPath("name").setValue(name)
    
    var positionDict = [String: Double]()
    positionDict["lat"] = position.coordinate.latitude
    positionDict["lng"] = position.coordinate.longitude
    
    reviewChild.childByAppendingPath("position").setValue(positionDict) { (error, nodeRed) in
        if error != nil {
            completionHandler(success: false)
        } else {
            completionHandler(success: true)
        }
    }
}

func deleteRestoToFireBase(idResto: String) {
    print(idResto)
    let nodeCurrentResto = Firebase(url: "\(ROOTFIREBASEURL)/data/restos/\(idResto)")

    nodeCurrentResto.observeSingleEventOfType(.Value, withBlock: {
        snapshot in

        if let image = snapshot.value.objectForKey("image") as? String {
            let nodeCurrentRestoImage = Firebase(url: "\(ROOTFIREBASEURL)/data/images/\(image)")
            nodeCurrentRestoImage.removeValue()
            // permet de lancer une closure
            //nodeCurrentRestoImage.removeValueWithCompletionBlock()
        }
        
        nodeCurrentResto.removeValue()
    })
}

enum PriceRange : Int {
    case Low = 0
    case Medium = 1
    case High = 2
}