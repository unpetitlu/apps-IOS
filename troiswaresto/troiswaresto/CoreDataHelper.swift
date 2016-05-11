//
//  CoreDataHelper.swift
//  troiswaresto
//
//  Created by etudiant-02 on 10/05/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    
    // Return all users
    static func fetchAllUsers()->[CoreDataUser]? {
        // Récupère le manageObjectContext
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        // Prépare une requête pour récupérer des infos dans CoreDataUser
        let fetchRequest = NSFetchRequest(entityName: "CoreDataUser")
        
        // Spécifie l'entity et le manageObjectContext
        fetchRequest.entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)
        
        
        // Pour ajouter un tri
        let sort = NSSortDescriptor(key: "nickname", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            // Récupère les utilisateurs
            let theUsers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CoreDataUser]
            return theUsers
        } catch let error as NSError {
            print("error to fetch all topics:\(error.description)")
            return nil
        }
    }
    
    // Return one user
    static func fetchUser(uid : String)->CoreDataUser? {

        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "CoreDataUser")
        fetchRequest.entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)
        
        fetchRequest.predicate = NSPredicate(format: "(uid == %@) ", uid)
        
        do {
            let theUsers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CoreDataUser]
            
            if theUsers.count > 1 {
                return nil
            } else {
                return theUsers[0]
            }
            
        } catch let error as NSError {
            print("error to fetch all topics:\(error.description)")
            return nil
        }

    }
    
    static func fetchOneUser()->CoreDataUser? {
        // Récupère le manageObjectContext
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        // Prépare une requête pour récupérer des infos dans CoreDataUser
        let fetchRequest = NSFetchRequest(entityName: "CoreDataUser")
        
        // Spécifie l'entity et le manageObjectContext
        fetchRequest.entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)
        
        
        // Pour ajouter un tri
        let sort = NSSortDescriptor(key: "nickname", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            // Récupère les utilisateurs et retourne le premier
            let theUsers = try managedObjectContext.executeFetchRequest(fetchRequest) as! [CoreDataUser]
            if theUsers.count != 1 {
                return nil
            } else {
                return theUsers[0]
            }

        } catch let error as NSError {
            print("error to fetch all topics:\(error.description)")
            return nil
        }
    }
    
    static func removeUser(user: CoreDataUser) -> Bool {
        // Récupère le manageObjectContext
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let NSManageObjectUser = user as NSManagedObject
        
        //Fait la suppression (persit en Symfo)
        managedObjectContext.deleteObject(NSManageObjectUser)
        
        do {
            //Execute vraiment la suppression (flush en Symfo)
            try managedObjectContext.save()
            return true
        } catch let error as NSError {
            print("error to fetch all topics:\(error.description)")
            return false
        }

    }
    
}