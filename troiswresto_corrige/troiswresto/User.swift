//
//  User.swift
//  troiswrestos
//
//  Created by nicolas on 18/02/2016.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import Foundation
import Firebase
import CoreData

class User {
    var email : String
    var password : String
    var uid : String //user id de Firebase
    var nickname : String
    var playerId : String? //id de OneSignal
    
    init(uid : String, email : String, password : String, nickname: String) {
        self.uid = uid
        self.email = email
        self.password = password
        self.nickname = nickname
    }
    

    
    func persistUser () {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(self.uid, forKey: "user_uid")
        userDefaults.setObject(self.email, forKey: "user_email")
        //TODO: à coder
        userDefaults.setObject(self.password, forKey: "user_password")
        userDefaults.setObject(self.nickname, forKey: "user_nickname")
        
        userDefaults.synchronize()
    }
    
    func persistUserInCoreData()->Bool {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        if let existingCoreUser = CoreDataHelper.fetchUser(self.uid) {//il y a déja un User
            existingCoreUser.email = self.email
            existingCoreUser.nickname = self.nickname
            existingCoreUser.password = self.password
            logWarning("user already exists")
        } else {
            let entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)!
            let oneCoreDataUser = CoreDataUser(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
            oneCoreDataUser.email = self.email
            oneCoreDataUser.nickname = self.nickname
            oneCoreDataUser.password = self.password
            oneCoreDataUser.uid = self.uid
        }
        
        do {
            try managedObjectContext.save()
            return true
            
        } catch let error as NSError {
            logError("Error to save:\(error.description)")
            return false
        }
    }
    
    
    
    /*
    //ajoute une revue à un User
    func addReview(rating : Double, description : String) {
        if let myCoreDataUser = CoreDataHelper.fetchUser() {
            
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            let entity = NSEntityDescription.entityForName("CoredataReview", inManagedObjectContext: managedObjectContext)!
            let oneReview = CoredataReview(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
            
            oneReview.avis = description
            oneReview.rating = rating
            oneReview.user = myCoreDataUser
            
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("💔 Error to save:\(error)")
            }
            
        }
    }
 */
}


class Contact {
    var email : String
    var name : String?
    var invited = false
    var registered = false
    var thumbnail : UIImage?
    
    init (email : String) {
        self.email = email
    }
}