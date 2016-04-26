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
        
        restoRateLabel.text = "\(resto.rating)"
        restoPositionLabel.text = ""
        restoDescriptionText.text = "Bonjour"
        
        restoDetailTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return resto.reviews.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}