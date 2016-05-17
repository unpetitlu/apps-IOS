//
//  RestoDetailViewController.swift
//  troiswresto
//
//  Created by nicolas on 25/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit

class RestoDetailViewController: UIViewController {
    
    @IBOutlet var myTableView : UITableView!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var descriptionTextView : UITextView!
    @IBOutlet var addressLabel : UILabel!
    @IBOutlet var ratingLabel : UILabel!
    @IBOutlet var priceRangeLabel : UILabel!
    @IBOutlet var myImageView : UIImageView!
    
    var resto : Resto!
    var restos : [Resto]!
    var selectedRestoInPin : Resto?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "detailtomap")
        {
            // on obtient une référence vers le ViewController de destination qui se trouve être un DetailViewController
            let mydestination: MapViewController =  segue.destinationViewController as! MapViewController
            
            // on passe à la destination une référence vers le movie qui a été choisi
            // l'index de la ligne selectionnée est myTableView.indexPathForSelectedRow!.row
            mydestination.allRestos = restos
            mydestination.selectedResto = resto
            
            if selectedRestoInPin != nil {
                mydestination.selectedResto = selectedRestoInPin!
            }
        }
        
        if (segue.identifier == "detailtoaddreview")
        {
            // on obtient une référence vers le ViewController de destination qui se trouve être un DetailViewController
            let mydestination: AddReviewViewController =  segue.destinationViewController as! AddReviewViewController
            
            // on passe à la destination une référence vers le movie qui a été choisi
            // l'index de la ligne selectionnée est myTableView.indexPathForSelectedRow!.row
            mydestination.resto = resto
        }
    }

    func updateDisplay() {
        nameLabel.text = resto.name
        descriptionTextView.text = resto.description

        if resto.address != nil {
            addressLabel.text = resto.address!
        } else {
            addressLabel.text = ""
        }
        
        if resto.rating != nil {
            ratingLabel.text = resto.rating!.toFormattedString
        } else {
            ratingLabel.hidden = true
        }
        
        if resto.image != nil {
            myImageView.image = resto.image!
        } else {
            myImageView.image = UIImage(named: "resto_placeholder")
        }
        
        let thetexte = priceRangeText(resto.priceRange)
        
        priceRangeLabel.text = thetexte
        
        // Pour trier les reviews, on met une date fictive pour celles qui n'en auraient pas
        for review in resto.reviews {
            if review.date == nil {
                review.date = "1970-01-01 00:00:00".toAbsoluteDate
            }
        }
        
        resto.reviews = resto.reviews.sort{$0.date!.timeIntervalSinceDate($1.date!) > 0}
        
       // resto.reviews = resto.reviews.sort{$0.date!.compare($1.date!) == NSComparisonResult.OrderedDescending}

        myTableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

extension RestoDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Revues"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // A modifier, retourner le nombre de ligne dans la section
        return resto.reviews.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row < resto.reviews.count {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell", forIndexPath: indexPath) as! ReviewCell
            // Ajouter la logique d'affichage du texte dans la cellule de la TableView
            
            let review = self.resto.reviews[indexPath.row]
            
            cell.ratingLabel.text = review.rating.toFormattedString
            
            if review.date != nil && review.date!.absoluteDateToString != "1970-01-01 00:00:00" {
                cell.dateLabel.text = review.date!.toSimpleDate
            } else {
                cell.dateLabel.text = ""
            }
            
            if let myNickname = review.nickName {
                cell.nicknameLabel.text = myNickname
            } else {
                cell.nicknameLabel.text = ""
            }
            
            if let myDescription = review.description {
                cell.descriptionLabel.text = myDescription
            } else {
                cell.descriptionLabel.text = ""
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddReviewCell", forIndexPath: indexPath) as! AddReviewCell
            cell.titleLabel.text = "Ajouter un avis"

            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // on peut utiliser la variable suivantes si nécessaire
        //let mySelectedRow = indexPath.row
        //faire quelque chose avec selectedRow
        
      //  performSegueWithIdentifier("todetail", sender: self)
        
        // récupérer les crédentials du User dans Core Data
        // si on a bien un user, on peut ajouter une review
        if CoreDataHelper.fetchOneUser() != nil {
            self.performSegueWithIdentifier("detailtoaddreview", sender: self)
        } else {// sinon, informer l'utilisateur
            simpleAlert("restodetail.createaccount".translate, message: "restodetail.youneedtocreateaccount", acceptTitle: nil, myController: self, completion: nil)
        }
        
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    // modification à la main de la hauteur des cellules
    // cette valeur override la valeur définie dans Interface Builder
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isIpad() {
            return 120
        } else {
            return 60
        }
    }
    
    
}