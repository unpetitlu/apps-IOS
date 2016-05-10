//
//  FirebaseHelper.swift
//  troiswaresto
//
//  Created by etudiant-02 on 09/05/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import Foundation
import Firebase


class FirebaseHelper {
    
    static func createFirebaseUser(login: String, nickName: String, password: String) {
        let ref = Firebase(url: "\(ROOTFIREBASEURL)")
        ref.createUser(login, password: password, withValueCompletionBlock: { (error, result) in
            
            if error != nil {
                logError("error create user")
            } else {
                if let uid = result["uid"] as? String {
                    let userChild = ref.childByAppendingPath("user").childByAppendingPath(uid)
                    
                    userChild.childByAppendingPath("nickname").setValue(nickName)
                    userChild.childByAppendingPath("login").setValue(login)
                }
            }
        
        })
    }
    
    
    static func logginFirebaseUser(login: String, password: String, completionHandler:(success : Bool)->Void) {
        let ref = Firebase(url: "\(ROOTFIREBASEURL)/user")

        ref.authUser(login, password: password) { (error, authData) in
            
            if error != nil {
                logError("error login")
            } else {
                let uid = authData.uid
                let refUser = Firebase(url: "\(ROOTFIREBASEURL)/user/\(uid)/nickname")
                
                refUser.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    if let nickname = snapshot.value as? String {
                        let user = User(nickname: nickname, email: login, password: password, userId: uid)
                        
                        // Enregistrement dans NSDefault et dans coreData
                        user.persistUser()
                        user.persistUserWithCoreData()
                        
                        completionHandler(success: true)
                    } else {
                        logError("pas de user avec cet id")
                    }
                    
                })
                
            }
        }
    }
    
    static func loggoutFirebaseUser() {
        let ref = Firebase(url: "\(ROOTFIREBASEURL)/user")
        ref.unauth();
    }
}