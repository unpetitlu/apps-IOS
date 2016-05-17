//
//  CoredataHelper.swift
//  troiswresto
//
//  Created by nicolas on 09/05/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    
    static func addReview(coreDataUser : CoreDataUser, rating : Double, description : String) {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName("CoreDataReview", inManagedObjectContext: managedObjectContext)!
        let oneReview = CoreDataReview(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        
        oneReview.avis = description
        oneReview.rating = rating
        oneReview.user = coreDataUser
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("💔 Error to save:\(error)")
        }
    }
    
    static func fetchAllReviews()->[CoreDataReview]? {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "CoreDataReview")
        fetchRequest.entity = NSEntityDescription.entityForName("CoreDataReview", inManagedObjectContext: managedObjectContext)
        
        do {
            let theItems = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CoreDataReview]
            return theItems
        } catch let error as NSError {
            print("error to fetch all reviews:\(error.description)")
            return nil
        }
    }
    
    static func fetchAllUsers()->[CoreDataUser]? {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "CoreDataUser")
        fetchRequest.entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)
        
        let sort = NSSortDescriptor(key: "nickname", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let theUsers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CoreDataUser]
            return theUsers
        } catch let error as NSError {
            print("error to fetch all users:\(error.description)")
            return nil
        }
    }
        
    static func fetchUser(uid : String)->CoreDataUser? {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "CoreDataUser")
        fetchRequest.entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)
        
       fetchRequest.predicate = NSPredicate(format: "(uid == %@) ", uid)
    
        
        do {
            let theUsers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CoreDataUser]
            
            if theUsers.count == 1 {
                return theUsers[0]
            } else {
                return nil
            }
            
        } catch let error as NSError {
            logError("error to fetch User:\(error)")
            return nil
        }
    }
    
    static func deleteUser(coreDataUser : CoreDataUser) {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        managedObjectContext.deleteObject(coreDataUser)
        
        do {
            try managedObjectContext.save()
        } catch {
            let saveError = error as NSError
            logDebug("error=\(saveError)")
        }
    }
    
    static func fetchOneUser()->CoreDataUser? {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "CoreDataUser")
        fetchRequest.entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)
        
        do {
            let theUsers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CoreDataUser]
            
            if theUsers.count == 1 {
                return theUsers[0]
            } else {
                return nil
            }
            
        } catch let error as NSError {
            logError("error to fetch User:\(error)")
            return nil
        }
    }
    
    
}
