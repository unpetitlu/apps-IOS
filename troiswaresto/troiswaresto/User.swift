//
//  User.swift
//  troiswaresto
//
//  Created by etudiant-02 on 25/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class User {
    var nickname: String
    var email: String
    var password: String
    var userId: String
    
    init(nickname: String, email: String, password: String, userId: String) {
        self.nickname = nickname
        self.email = email
        self.password = password
        self.userId = userId
    }
    
    func persistUser() {
        // TODO : changer le nom des clefs pour éviter que les gens devinent
        NSUserDefaults.standardUserDefaults().setObject(self.password, forKey: "pwd")
        NSUserDefaults.standardUserDefaults().setObject(self.nickname, forKey: "nickname")
        NSUserDefaults.standardUserDefaults().setObject(self.email, forKey: "email")
        NSUserDefaults.standardUserDefaults().setObject(self.userId, forKey: "userid")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func persistUserWithCoreData() -> Bool {
        // Récupère le controller appDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Récupère la variable managedObjectContext
        let managedObjectContext = appDelegate.managedObjectContext
        
        // Récupère l'entité CoreDataUser
        let entity = NSEntityDescription.entityForName("CoreDataUser", inManagedObjectContext: managedObjectContext)!
        
        // Créer un objet de CoreDataUser
        let oneCoreDataUser = CoreDataUser(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        
        oneCoreDataUser.email = self.email
        oneCoreDataUser.nickname = self.nickname
        oneCoreDataUser.password = self.password
        oneCoreDataUser.uid = self.userId
        
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
