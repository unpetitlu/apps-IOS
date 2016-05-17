//
//  Review.swift
//  troiswresto
//
//  Created by nicolas on 25/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Review {
    var nickName : String?
    var description : String?
    var rating : Double
    var date : NSDate?
    
    init( rating : Double, date: NSDate?) {
        self.rating = rating
        self.date = date
    }
    
    // prend un CoreDataUser en paramètre pour pouvoir l'affecter
    func persistReviewInCoreData(coreUser : CoreDataUser)->Bool {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName("CoreDataReview", inManagedObjectContext: managedObjectContext)!
        let oneCoreDataReview = CoreDataReview(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        
      oneCoreDataReview.avis = self.description
      oneCoreDataReview.rating = self.rating
      oneCoreDataReview.nickname = self.description
      oneCoreDataReview.date = self.date
        
        oneCoreDataReview.user = coreUser
        
        do {
            try managedObjectContext.save()
            return true
            
        } catch let error as NSError {
            logError("Error to save:\(error.description)")
            return false
        }
    }
}