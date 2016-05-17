//
//  Resto.swift
//  troiswresto
//
//  Created by nicolas on 25/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Firebase

class Resto {
    let restoId : String
    var name : String
    var position : CLLocation
    var image : UIImage?
    var priceRange : PriceRange?
    var description : String?
    var reviews = [Review]()
    var address : String?
    
    var distance : CLLocationDistance?
    
    var rating : Double? {
        var output = 0.0
        let count = Double(reviews.count)
        
        // si le tableau des reviews est non vide on calcule la moyenne des ratings
        if count > 0 {
            for review in reviews {
                output += review.rating
            }
            return output / count
            
            //sinon on renvoit nil
        } else {
            return nil
        }
    }
    
    init(restoId : String, name : String, position : CLLocation) {
        self.restoId = restoId
        self.name = name
        self.position = position
    }
    
    func sendReviewToCloud(review : Review, completionHandler:(error : NSError!)->()) {
        
        logDebug("sending review for rating =\(review.rating)")
        let rootRef = Firebase(url:firebaseUrl).childByAppendingPath("data/resto").childByAppendingPath(self.restoId).childByAppendingPath("reviews")
        
        let reviewRef = rootRef.childByAutoId()
        
        // ajout du rating : obligatoire
       // reviewRef.setValue(["rating" : review.rating])
        
        // version plus élaborée avec completion block
        reviewRef.setValue(["rating" : review.rating], withCompletionBlock: {(error, ref) in
            completionHandler(error: error)
        })

        // ajout de la description et du nickname si on en a
        var myDict = [String : String]()
        
        if review.date != nil {
            myDict["date"] = review.date!.absoluteDateToString
        }
        
        if review.description != nil {
            myDict["description"] = review.description
        }
        
        if review.nickName != nil {
            myDict["nickName"] = review.nickName
        }
        
        reviewRef.updateChildValues(myDict)

    }
}

enum PriceRange : Int {
    case Cheap = 0
    case Normal = 1
    case Expensive = 2
}

func createRestoInCloud(name : String, address : String, location: CLLocation, image : UIImage?, priceRange : PriceRange, description: String?,
                        completionHandler : ()->() ) {
    let rootRef = Firebase(url:firebaseUrl).childByAppendingPath("data/resto")
    let restoRef = rootRef.childByAutoId()
    
    var myDict = ["name" : name, "address" : address]
    
    if description != nil {
        myDict["description"] = description
    }
    
    restoRef.updateChildValues(myDict, withCompletionBlock: {(error, firebase) in
        let locationDict = ["lat" : location.coordinate.latitude, "long" : location.coordinate.longitude]
        restoRef.childByAppendingPath("position").updateChildValues(locationDict)
        
        restoRef.updateChildValues(["priceRange" : priceRange.rawValue])
        
        if image != nil {
            FirebaseHelper.uploadImageToFirebase(image!, completion: {(imageId) in
                if imageId != nil {
                    restoRef.updateChildValues(["imageId" : imageId!])
                }
            })
        }
        
        if let myCoreUser = CoreDataHelper.fetchOneUser() {
            restoRef.updateChildValues(["author" : myCoreUser.uid! ])
        }
        
        completionHandler()
    })
}

