//
//  ViewController.swift
//  troiswrestos
//
//  Created by Nicolas on 17/02/2016.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    @IBOutlet var connectButton : UIButton!
    @IBOutlet var createAccountButton : UIButton!
    @IBOutlet var messageLabel : UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var ignoreButton: UIButton!
    @IBOutlet weak var testButton: UIButton!
    
    @IBAction func logoutButtonPressed () {
        FirebaseHelper.logoutFromFirebase()
        
        if let coreDataUser = CoreDataHelper.fetchOneUser() {
           CoreDataHelper.deleteUser(coreDataUser)
        }
        
        self.messageLabel.text = "notloggedin".translate
        self.connectButton.hidden = false
        self.createAccountButton.hidden = false
    }
    
    func setConnectedDisplay(user : CoreDataUser) {
        logDebug("authenticated OK")
        messageLabel.text = "loggedin".translate + ": \(user.nickname!)"
        connectButton.hidden = true
        createAccountButton.hidden = true
        logoutButton.hidden = false
        ignoreButton.setTitle("welcome.next".translate, forState: .Normal)
    }
    
    func setNotConnectedDisplay() {
        logDebug("not authenticated")
        self.messageLabel.text = "notloggedin".translate
        self.connectButton.hidden = false
        self.createAccountButton.hidden = false
        logoutButton.hidden = true
        ignoreButton.setTitle("welcome.ignore".translate, forState: .Normal)
    }
    
    // http://stackoverflow.com/questions/24049020/nsnotificationcenter-addobserver-in-swift
    func notificationReceived(notification: NSNotification) {
        logWarning("Notification received from WelcomeViewController")
        
        if notification.userInfo != nil {
            if let myRating = notification.userInfo!["rating"] as? Double {
                logWarning("and the rating was:\(myRating)")
            }
            
            if let message = notification.userInfo!["message"] as? Double {
                logWarning("and the message was:\(message)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.text = ""
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationReceived), name: "reviewsubmitted", object: nil)
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    //    testButton.hidden = true
        
        if let myCoredataUser = CoreDataHelper.fetchOneUser() {//on a un user dans Coredata
            FirebaseHelper.isUserAuthenticated() {(success) in
                
              //  makeToast( self.view, message: "username=\(myCoredataUser.nickname!)")
                
                if !success { //on n'était pas authentifié
                    FirebaseHelper.loginUserInFirebase(myCoredataUser.email!, password: myCoredataUser.password!, completion: {(success, user) in
                        if user != nil {
                            self.setConnectedDisplay(myCoredataUser)
                        }
                    })
                } else {
                    self.setConnectedDisplay(myCoredataUser)
                }
            }
        } else {//on n'a pas de user dans Coredata
            setNotConnectedDisplay()
        }
    
    /*
        if let myReviews = CoreDataHelper.fetchAllReviews() {
            for item in myReviews {
                logDebug("review with description=\(item.avis!)")
            }
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


func isUserAuthenticated (completion:(success : Bool)->Void) {
    let ref = Firebase(url: firebaseUrl)
    if ref.authData != nil {
        // user authenticated
        print("authenticated")
        print(ref.authData)
        completion(success : true)
    } else {
        // No user is signed in
        completion(success: false)
    }
    
    if (OPTIMIZEFIREBASE) { Firebase.goOffline() }
}
