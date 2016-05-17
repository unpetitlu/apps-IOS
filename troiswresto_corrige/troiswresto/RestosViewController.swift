//
//  RestosViewController.swift
//  troiswresto
//
//  Created by nicolas on 25/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit
import CoreLocation

class RestosViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var myTableView : UITableView!
    
    var restos = [Resto]()
    let locationManager = CLLocationManager()

    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {//tri par note
            restos = restos.sort{$0.rating > $1.rating}
            myTableView.reloadData()
        }
        
        if sender.selectedSegmentIndex == 1 {// tri par distance
            restos = restos.sort{$0.distance < $1.distance}
            myTableView.reloadData()
        }
        
        if sender.selectedSegmentIndex == 2 {// tri par prix
          //  makeToast(self.view, message: "tri par prix")
            restos = restos.sort{$0.priceRange?.rawValue < $1.priceRange?.rawValue}
            myTableView.reloadData()
        }
    }
    
    @IBAction func backToRestos (segue: UIStoryboardSegue) {
        logDebug("welcome back to restos")
    }
    
    func initRestoDatabase() {
        FirebaseHelper.getStationsInfo(myTableView, completion: {(restoReceived) in
            self.restos = restoReceived
            self.myTableView.reloadData()
            self.updateUserLocation()
            // logDebug("restos=\(restos)")
        })
    }
    
    func updateRestosPositions() {
        for resto in restos {
            resto.distance = locationManager.location?.distanceFromLocation(resto.position)
        }
        
        // mise à jour de la table
        myTableView.reloadData()
        
    }
    
    // MARK: - LocationManager
    func updateUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // cette fonction écoute le changement de position du user
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        logDebug("did update location")
        
        if manager.location != nil {
            locationManager.stopUpdatingLocation()
            
            // La position du user est connue, on peut maintenant calculer la distance de toutes les stations
            updateRestosPositions()
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "todetail")
        {
            // on obtient une référence vers le ViewController de destination qui se trouve être un DetailViewController
            let mydestination: RestoDetailViewController =  segue.destinationViewController as! RestoDetailViewController
            
            // on passe à la destination une référence vers le movie qui a été choisi
            // l'index de la ligne selectionnée est myTableView.indexPathForSelectedRow!.row
            mydestination.resto = restos[myTableView.indexPathForSelectedRow!.row]
            mydestination.restos = restos
        }
        
        if (segue.identifier == "restostomap")
        {
            // on obtient une référence vers le ViewController de destination qui se trouve être un DetailViewController
            let mydestination: MapViewController =  segue.destinationViewController as! MapViewController
            
            // on passe à la destination une référence vers le movie qui a été choisi
            // l'index de la ligne selectionnée est myTableView.indexPathForSelectedRow!.row
            logWarning("to resto map")
            mydestination.allRestos = restos
        }
        
        if (segue.identifier == "toaddresto")
        {
            // on obtient une référence vers le ViewController de destination qui se trouve être un DetailViewController
            let mydestination: MapViewController =  segue.destinationViewController as! MapViewController
            
            // on passe à la destination une référence vers le movie qui a été choisi
            // l'index de la ligne selectionnée est myTableView.indexPathForSelectedRow!.row
            mydestination.allRestos = restos
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initRestoDatabase()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      //  makeToast(self.view, message: "Bravo les gars")


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension RestosViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // A modifier, retourner le nombre de ligne dans la section
        return restos.count
    }
    
    func priceRangeText(priceRange : PriceRange?)->String {
        var output = ""
        
        if priceRange != nil {
            switch priceRange! {
            case .Cheap:
                output = "€"
            case .Normal:
                output = "€€"
            case .Expensive:
                output = "€€€"
            }
        }
        
        return output
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestoCell", forIndexPath: indexPath) as! RestoCell
        // Ajouter la logique d'affichage du texte dans la cellule de la TableView
        
        let resto = self.restos[indexPath.row]
        
        cell.nameLabel.text = resto.name
        if resto.image != nil {
            cell.myImageView.image = resto.image!
          //  logDebug("changing image")
        }
        
        cell.priceLabel.text = priceRangeText(resto.priceRange)
        
        if resto.rating != nil {
         //   cell.ratingLabel.text = resto.rating!.toFormattedString
            cell.ratingLabel.text = resto.rating!.toFormattedString
           // logDebug("we have rating = " + resto.rating!.toFormattedString + "for \(resto.name)")
            cell.ratingLabel.hidden = false
        } else {
            cell.ratingLabel.hidden = true
          //  logDebug("No rating for \(resto.name)")

        }
        
        if resto.distance != nil {
            cell.distanceLabel.text = "\(Int(resto.distance!)) m"
        } else {
            cell.distanceLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // on peut utiliser la variable suivantes si nécessaire
        //let mySelectedRow = indexPath.row
        //faire quelque chose avec selectedRow
        
        performSegueWithIdentifier("todetail", sender: self)
        
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
    
    // créé 3 boutons custom quand l'utilisateur slide une ligne de la tableview vers la gauche
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // more
        
        // delete. Noter le .Desctructive dans le style qui donne automatiquement la couleur rouge
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { action, index in
            print("Delete button tapped")
            
            logDebug("going to delete restoId:\(self.restos[indexPath.row].restoId)")
            
            deleteRestoInFirebase(self.restos[indexPath.row].restoId)
            self.restos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        return [delete]
    }
}