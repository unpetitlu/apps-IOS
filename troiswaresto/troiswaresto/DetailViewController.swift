//
//  DetailViewController.swift
//  troiswaresto
//
//  Created by etudiant-02 on 25/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var restoTitleLabel : UILabel!
    @IBOutlet var restoImageView : UIImageView!
    @IBOutlet var restoRateLabel : UILabel!
    @IBOutlet var restoPriceLabel : UILabel!
    @IBOutlet var restoPositionLabel : UILabel!
    @IBOutlet var restoDescriptionText : UITextView!
    @IBOutlet var restoDetailTableView : UITableView!
    
    var resto : Resto!
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateDisplay() {
        restoTitleLabel.text = resto.name
        
        if resto.image != nil {
            restoImageView.image = resto.image
        } else {
            restoImageView.image = UIImage(named: "default-resto")
        }
        
        if let price = resto.priceRange {
            var priceText = "€"
            switch price {
                case .Low:
                    priceText = "€"
                case .Medium:
                    priceText = "€€"
                case .High:
                    priceText = "€€€"
            }
            restoPriceLabel.text = priceText
        } else {
            restoPriceLabel.text = ""
        }
        
        restoRateLabel.text = "\(resto.rating.roundToPlaces(2))"
        restoPositionLabel.text = ""
        restoDescriptionText.text = "Bonjour"
        
        restoDetailTableView.reloadData()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tomapfromrestodetail")
        {
            // on obtient une référence vers le ViewController de destination qui se trouve être un MapViewController
            let mydestination: MapViewController =  segue.destinationViewController as! MapViewController
            
            // J'envoi dans le tableau de tous les restos uniquement le resto sur lequel je me trouve
            mydestination.allRestos.append(resto)
            mydestination.screenType = ScreenType.OneResto
            
        } else if segue.identifier == "addreview" {
            let mydestination: ReviewViewController =  segue.destinationViewController as! ReviewViewController
            mydestination.resto = resto
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Placement de l'écouteur. Dès qu'on lance "reviewsubmitted" il execute le code du "#selector"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationReceived), name: "reviewsubmitted", object: nil)
    }
    
    // http://stackoverflow.com/questions/24049020/nsnotificationcenter-addobserver-in-swift
    func notificationReceived(notification: NSNotification) {
        logWarning("Notification received from WelcomeViewController")
        
        if notification.userInfo != nil {
            if let myRating = notification.userInfo!["rate"] as? Double {
                logWarning("and the rating was:\(myRating)")
            }
            
            if let message = notification.userInfo!["message"] as? Double {
                logWarning("and the message was:\(message)")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - TableView

extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    // Permet de placer un titre pour la table view
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Avis"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // A modifier, retourner le nombre de ligne dans la section
        
        // avant : return resto.reviews.count
        
        // après. Le + 1 permet d'ajouter une ligne en plus afin d'ajouter la ligne avec le +
        return resto.reviews.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == resto.reviews.count {
            return tableView.dequeueReusableCellWithIdentifier("restoDetailAddReview", forIndexPath: indexPath) as! AddReviewCell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("restoDetailCustomCell", forIndexPath: indexPath) as! ReviewCustomCell
        // Ajouter la logique d'affichage du texte dans la cellule de la TableView
        
        cell.rateLabel.text = "\(resto.reviews[indexPath.row].rate)"
        if let author = resto.reviews[indexPath.row].nickname {
            cell.authorLabel.text = author
        } else {
            cell.authorLabel.text = ""
        }
        
        if let comment = resto.reviews[indexPath.row].comment {
            cell.contentText.text = comment
        } else {
            cell.contentText.text = ""
        }
        
        if let date = resto.reviews[indexPath.row].dateOfReview {
            cell.dateText.text = date.absoluteDateToString
        } else {
            cell.dateText.text = "no date"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Si je clique sur le + : c'est le dernier index du tableau
        if indexPath.row == resto.reviews.count {
            if CoreDataHelper.fetchOneUser() != nil {
                performSegueWithIdentifier("addreview", sender: self)
            } else {
                simpleAlert("Oups !", message: "Vous devez vous connecter pour écrire un commentaire", view: self)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}