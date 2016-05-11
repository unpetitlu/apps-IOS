//
//  WelcomeViewController.swift
//  troiswaresto
//
//  Created by etudiant-02 on 06/05/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    @IBOutlet var connectUserButton: UIButton!
    @IBOutlet var createUserButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var userLabel: UILabel!
    
    @IBAction func logoutButtonPressed(sender: UIButton) {
        //TODO: Refaire l'affichage lors de la connexion/deconnexion
        
        FirebaseHelper.loggoutFirebaseUser()
        if let user = CoreDataHelper.fetchOneUser() {
            if CoreDataHelper.removeUser(user) {
                simpleAlert("Bravo", message: "Vous êtes déconnecté", view: self)
            } else {
                simpleAlert("Oups", message: "Problème de connexion", view: self)
            }
        }
    }
    
    // Fonction permettant de revenir en arrière sur plusieurs pages en même temps
    // Cette fonction est à placer sur le controller d'arrivé
    @IBAction func unwindBublingBackToHome(sender : UIStoryboardSegue) {
        print("Welcome back to home");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test de coreData : insert and select
        /*
        // Insert un utilisateur
        let user = User(nickname: "test", email: "test@gmail.com", password: "azerty", userId: "1")
        user.persistUserWithCoreData()

        // Récupère tous les utilisateurs
        if let users = CoreDataHelper.fetchAllUsers() {
            for user in users {
                print(user.nickname!)
            }
        }
        
        // Récupère un utilisateur
        if let user = CoreDataHelper.fetchUser("1") {
            print(user.nickname!)
        }

        if let users = CoreDataHelper.fetchAllUsers() {
            for user in users {
                print(user.nickname!)
                
                // as? Set<CoreDataReview> sur user.reviews car c'est un NSSET
                if let reviews = user.reviews as? Set<CoreDataReview> {
                    for review in reviews {
                        print(review.rate!)
                        print(review.user!.nickname!)
                    }
                }
            }
        }
 
        if let user = CoreDataHelper.fetchOneUser() {
            if let reviews = user.reviews as? Set<CoreDataReview> {
                for review in reviews {
                    print(review.rate!)
                    print(review.user!.nickname!)
                    print(review.dateOfReview)
                }
            }
        }
        */
        
        
        // Test sur les date
        /*
        let now = NSDate()
        print(now)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let mydateString = dateFormatter.stringFromDate(now)
        print(mydateString)
        
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter2.timeStyle = NSDateFormatterStyle.ShortStyle
        let date = dateFormatter2.dateFromString(mydateString)!
        print(date)
        */
        
        // Permet de récupérer le User dans le NSUserDefault
        //getUserFromUserDefault()
 

        // Do any additional setup after loading the view.
        //logUserDefaultsWithFilter(nil)
        logoutButton.hidden = true
        userLabel.hidden = true
        if let user = CoreDataHelper.fetchOneUser() {
            connectUserButton.hidden = true
            createUserButton.hidden = true
            userLabel.text = user.nickname
            userLabel.hidden = false
            logoutButton.hidden = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
