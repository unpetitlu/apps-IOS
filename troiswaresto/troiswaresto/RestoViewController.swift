//
//  RestoViewController.swift
//  troiswaresto
//
//  Created by etudiant-02 on 25/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit
import MapKit

class RestoViewController: UIViewController {

    @IBOutlet var restoTableView : UITableView!
    var refreshControl: UIRefreshControl!
    
    var restos = [Resto]()
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateDisplay() {
        restos = [Resto]()
        let fakeResto = Resto(restoId: "1", name: "Le Serbe", position: CLLocation(latitude: 48.893741, longitude: 2.350840))
        fakeResto.priceRange = PriceRange.Low
        let fakeReview = Review(rate: 12)
        fakeResto.reviews.append(fakeReview)
        
        restos.append(fakeResto)
        
        let fakeResto2 = Resto(restoId: "2", name: "Le Basque", position: CLLocation(latitude: 48.894156, longitude: 2.353471))
        fakeResto2.priceRange = PriceRange.Low
        let fakeReview2 = Review(rate: 10)
        fakeResto2.reviews.append(fakeReview2)
        
        restos.append(fakeResto2)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "todetail")
        {
            // on obtient une référence vers le ViewController de destination qui se trouve être un DetailViewController
            let mydestination: DetailViewController =  segue.destinationViewController as! DetailViewController
            
            // on passe à la destination une référence vers le movie qui a été choisi
            // l'index de la ligne selectionnée est myTableView.indexPathForSelectedRow!.row
            mydestination.resto = restos[restoTableView.indexPathForSelectedRow!.row]
        } else if (segue.identifier == "tomap") {
            let mydestination: MapViewController =  segue.destinationViewController as! MapViewController
            mydestination.allRestos = restos
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateDisplay()
        
        refreshControl = UIRefreshControl()
        
        let attribute = [NSForegroundColorAttributeName: UIColor.redColor()]
        refreshControl.attributedTitle = NSAttributedString(string: "Glisser pour rafraichir", attributes: attribute)
        
        //  refreshControl.attributedTitle.attr
        refreshControl.addTarget(self, action: #selector(RestoViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        restoTableView.addSubview(self.refreshControl) // not required when using UITableViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // mise à jour de la TableView après un Pull to refresh
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        updateDisplay()
        
        restoTableView.reloadData()
        
        refreshControl.endRefreshing()
    }

}


// MARK: - TableView

extension RestoViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // A modifier, retourner le nombre de ligne dans la section
        return restos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("restoCustomCell", forIndexPath: indexPath) as! CustomCell
        // Ajouter la logique d'affichage du texte dans la cellule de la TableView
        /*
        if isIpad() {
            cell.imageWidthConstraint.constant = 300
            cell.imageHeightConstraint.constant = 168
        }
        */
        
        cell.titleLabel.text = restos[indexPath.row].name
        if restos[indexPath.row].image != nil {
            cell.myImage.image = restos[indexPath.row].image
        } else {
            cell.myImage.image = UIImage(named: "default-resto")
        }
        
        if let price = restos[indexPath.row].priceRange {
            var priceText = "€"
            switch price {
                case .Low:
                    priceText = "€"
                case .Medium:
                    priceText = "€€"
                case .High:
                    priceText = "€€€"
            }
            cell.priceLabel.text = priceText
        } else {
            cell.priceLabel.text = ""
        }
        
        cell.rateLabel.text = "\(restos[indexPath.row].rating)"
        //cell.positionLabel.text = "\(restos[indexPath.row].address)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // on peut utiliser la variable suivantes si nécessaire
        //let mySelectedRow = indexPath.row
        //faire quelque chose avec selectedRow
        
        
    
        performSegueWithIdentifier("todetail", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    /*  code classique pour effacer une ligne. j'ai mis à la place le code dans editActionsForRowAtIndexPath
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == UITableViewCellEditingStyle.Delete {
     movies.removeAtIndex(indexPath.row)
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     }
     }
     */
    
    
    // modification à la main de la hauteur des cellules
    // cette valeur override la valeur définie dans Interface Builder
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if isIpad() {
            return 200
        } else {
            return 110
        }
    }
    
    // créé 3 boutons custom quand l'utilisateur slide une ligne de la tableview vers la gauche
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // more
        let more = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = UIColor.lightGrayColor()
        
        // favorite
        let favorite = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = UIColor.orangeColor()
        
        // delete. Noter le .Desctructive dans le style qui donne automatiquement la couleur rouge
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { action, index in
            print("Delete button tapped")
            self.restos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        return [delete, favorite, more]
    }
}