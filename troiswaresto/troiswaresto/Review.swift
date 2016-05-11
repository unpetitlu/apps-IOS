//
//  Review.swift
//  troiswaresto
//
//  Created by etudiant-02 on 25/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//
import UIKit
import CoreData
import Foundation

class Review {
    var rate : Double
    var comment : String?
    var nickname: String?
    var dateOfReview: NSDate?
    
    init(rate : Double) {
        self.rate = rate
    }
    
    func persistReviewWithCoreData(userReceived: CoreDataUser) -> Bool {
        // Récupère le controller appDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Récupère la variable managedObjectContext
        let managedObjectContext = appDelegate.managedObjectContext

        // Récupère l'entité CoreDataReview
        let entity = NSEntityDescription.entityForName("CoreDataReview", inManagedObjectContext: managedObjectContext)!
        
        // Créer un objet de CoreDataReview
        let oneCoreDataReview = CoreDataReview(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        
        oneCoreDataReview.rate = self.rate
        oneCoreDataReview.comment = self.comment
        
        /* DATE - AVANT UTILISATION DE L'EXTENSION
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let date = dateFormatter.dateFromString(self.dateOfReview!)
        */
        // DATE - APRES UTILISATION DE L'EXTENSION
        //let date = self.dateOfReview!.toAbsoluteDate
        
        oneCoreDataReview.dateOfReview = self.dateOfReview
        
        oneCoreDataReview.user = userReceived
        
        do {
            // Sauvegarde de l'objet
            try managedObjectContext.save()
            return true
            
        } catch let error as NSError {
            logError("Error to save:\(error.description)")
            return false
        }
    }
}
