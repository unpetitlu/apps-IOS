//
//  ViewController.swift
//  myvelib
//
//  Created by etudiant-02 on 11/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController : UIViewController, CLLocationManagerDelegate {
    
    //@IBOutlet var stationLabel : UILabel!
    //@IBOutlet var nbBikeLabel : UILabel!
    //@IBOutlet var nbAvailableBikeStandLabel : UILabel!
    
    @IBOutlet var myTableView : UITableView!
    @IBOutlet var titleButton : UIButton!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var tableViewLabel : UILabel!
    @IBOutlet var activityIndicator : UIActivityIndicatorView!
    
    @IBOutlet var progressLabel : UILabel!
    @IBOutlet var progressBar : UIProgressView!
    
    var stationsIds = [Int]()
    var myVelibStations = [VelibStation]()
    var allVelibStations = [VelibStation]()
    
    var refreshControl: UIRefreshControl!
    
    var indexPage : ScreenType!
    
    @IBAction func sendButtonPressed(sender : UIButton)
    {
        sendAnalyticsEvent("add-first-station", parameters: ["page" : "\(indexPage)"])
        performSegueWithIdentifier("tomap", sender: self)
    }
    
    /* Utilisation de "Alamofire" pour le JSON */
    /* IMPORTANT : Utilisation de getStationInfo() depuis le fichier Model.swift
    func getStationInfo(stationId : Int) {
        

        let urlString = "\(APIURL)/stations/\(stationId)?contract=\(APICONTRACT)&apiKey=\(APIKEY)"
        
        Alamofire.request(.GET, urlString, parameters : nil)
            .response { (request, response, data, error) in

                if (error == nil) {
                    NSLog("data=\(data)")
                    let json = JSON(data: data!)
                    NSLog("json=\(json)")
                    
                    /*
                    var nbBikeStand = 0
                    var nbBike = 0
                    var nameStation = ""
                    
                    
                    if let available_bike_stands = json["available_bike_stands"].number {
                        //self.nbAvailableBikeStandLabel.text = "\(available_bike_stands)"
                        nbBikeStand = Int(available_bike_stands)
                    }
                    
                    if let available_bikes = json["available_bikes"].number {
                        //self.self.nbBikeLabel.text = "\(available_bikes)"
                        nbBike = Int(available_bikes)
                    }
                    
                    if let name = json["name"].string {
                        nameStation = name
                    }
                    */
                    
                    if  let available_bike_stands = json["available_bike_stands"].number,
                        let available_bikes = json["available_bikes"].number,
                        let name = json["name"].string
                    {
                        self.velibStations.append(VelibStation(nameStation: name, bikeAvailable: Int(available_bikes), bikeStandAvailable: Int(available_bike_stands)))
                        self.myTableView.reloadData()
                    }
                    else
                    {
                        print("Problème de requête JSON")
                    }
                    
                    
                }
        }
        NSLog("fonction getStationInfo terminée")

    }
    */
    
    
    /* Première version de la fonction getStationInfo.
     Utilisation du JSON via les méthodes "basiques" de XCODE
    func getStationInfoV1 (stationId : Int)  {
        
        let urlString = "https://api.jcdecaux.com/vls/v1/stations/\(stationId)?contract=Paris&apiKey=9acaeb61c46a3bce075a85c5dac5381b2fe5949a"
        let request = NSURLRequest(URL: NSURL(string: urlString)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if (error == nil) && (data != nil) {
                
                NSLog("Response =\(response)")
                NSLog("Data =\(data)")
                
                //on parse le json
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                    
                    print("json=\(json)")
                    
                    if let available_bikes = json["available_bikes"] as! Int? {
                        print("available bikes=\(available_bikes)")
                        
                        self.nbBikeLabel.text = "\(available_bikes)"
                    }
                    else {
                        NSLog("error to get available bikes")
                    }
                    
                    if let available_bike_stands = json["available_bike_stands"] as! Int? {
                        print("bike stands=\(available_bike_stands)")
                        
                        self.nbAvailableBikeStandLabel.text = "\(available_bike_stands)"
                    }
                    else {
                        NSLog("error to get bike stands")
                    }
                    
                    if let number_station = json["number"] as! Int? {
                        print("number station=\(number_station)")
                        
                        self.stationLabel.text = "\(number_station)"
                    }
                    else {
                        NSLog("error to get number station")
                    }
                    
                } catch {
                    print(error)
                }
                
            } else {
                NSLog("error message=\(error)")
            }
        }
  
    }
    */
    
    func loadStation()
    {
        /*
        for id in stationsIds
        {
            getStationInfo(id)
        }
        */
        //getStationsInfo(stationsIds)
        // Utilisation de la fonction getStationsInfo depuis le fichier Model.swift
        // On écrit une closure permettant de récupérer le retour de la fonction uniquement lorsque celle-ci se termine ;)
        
        /* Ecriture plus longue
         getStationsInfo (stationsIds, completionHandler: { (stationsReceived : [VelibStation]) in
            self.velibStations = stationsReceived
            self.myTableView.reloadData()
         })
        */
        
        // Ecriture raccourci
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        getStationsInfo(self, stationsIds: stationsIds) { (stationsReceived : [VelibStation], allStations : [VelibStation]) in
            
            self.myVelibStations = stationsReceived
            self.allVelibStations = allStations
            if self.myVelibStations.count > 0 {
                self.myTableView.hidden = false
                self.myTableView.reloadData()
                self.tableViewLabel.hidden = true
            }
            else {
                self.tableViewLabel.hidden = false
                self.myTableView.hidden = true
            }
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
            
            self.displayStatutColor()
        }
    }
    
    func displayStatutColor() {
        let nbTotalVelib = myVelibStations.filter{$0.bikeAvailable >= 1}.count
        
        if nbTotalVelib >= 2 {
            self.view.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
        } else if nbTotalVelib == 1 {
            self.view.backgroundColor = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        } else {
            self.view.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
        }
    }
    
    func updateDisplay()
    {
        
        tableViewLabel.hidden = false
        myTableView.hidden = true
        activityIndicator.hidden = true
        // Add refresh to myTableView
        self.refreshControl = UIRefreshControl()
        
        let attribute = [NSForegroundColorAttributeName: UIColor.redColor()]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Glisser pour rafraichir", attributes: attribute)
        
        //  self.refreshControl.attributedTitle.attr
        self.refreshControl.addTarget(self, action: #selector(MainViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.myTableView.addSubview(self.refreshControl) // not required when using UITableViewController
        // End add refresh to myTableView
        
        if indexPage != .Geoloc {
            
            stationsIds = getStationsIds(indexPage)
            loadStation()
            
        } else {
            initGeoloc()
        }
    }
    
    func initPageView()
    {
        tableViewLabel.text = "Veuillez appuyer sur l'icone afin d'ajouter des stations"
        
        let imageHome = UIImage(named:"home")
        let imageWork = UIImage(named: "work")
        let imageGeoloc = UIImage(named: "geoloc")

         switch indexPage! {
            case .Home:
                titleButton.setBackgroundImage(imageHome, forState: .Normal)
                titleLabel.text = "Home"
                //self.view.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
            case .Work:
                titleButton.setBackgroundImage(imageWork, forState: .Normal)
                titleLabel.text = "Work"
                //self.view.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            case .Geoloc:
                titleButton.setBackgroundImage(imageGeoloc, forState: .Normal)
                titleLabel.text = "Geoloc"
                //self.view.backgroundColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPageView()
        
        //updateDisplay()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // mise à jour de la TableView après un Pull to refresh
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        loadStation()
        self.refreshControl.endRefreshing()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tomap")
        {
            // on obtient une référence vers le ViewController de destination qui se trouve être un MapViewController
            let mydestination: MapViewController =  segue.destinationViewController as! MapViewController
            
            // on passe à la destination une référence vers le centerStation qui a été choisi
            // l'index de la ligne selectionnée est myTableView.indexPathForSelectedRow!.row
            if myTableView.indexPathForSelectedRow != nil {
                mydestination.centerStation = myVelibStations[myTableView.indexPathForSelectedRow!.row]
            }
            
            mydestination.allVelibStations = allVelibStations
            mydestination.favorisStations = stationsIds
            mydestination.indexPage = indexPage
        }
    }
    
    
    
    // MARK: - LocationManager
    let locationManager = CLLocationManager()
    
    func initGeoloc() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if manager.location != nil {
            locationManager.stopUpdatingLocation()
            logDebug("launching request")
            
            myVelibStations = getClosestStation(allVelibStations, userPosition: manager.location!, number: 3)
            myTableView.reloadData()
            myTableView.hidden = false
        }
    }
    // MARK: -
}



// MARK: - TableView
extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) ->Int {
        // A modifier, retourner le nombre de ligne dans la section
        return myVelibStations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! CustomCell
        // Ajouter la logique d'affichage du texte dans la cellule de la TableView
        // la variable indexPath indique la ligne selectionnée
        // on accède aux IBOutlet de la cellule avec par exemple : cell.name =
        
        cell.bikeAvailableLabel.text = "\(myVelibStations[indexPath.row].bikeAvailable)"
        cell.bikeStandAvailableLabel.text = "\(myVelibStations[indexPath.row].bikeStandAvailable)"
        cell.titleLabel.text = myVelibStations[indexPath.row].nameStation
        
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let selectedRow = indexPath.row
        //faire quelque chose avec selectedRow
        sendAnalyticsEvent("touch-cell", parameters: ["page" : "\(indexPage)"])
        performSegueWithIdentifier("tomap", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // créer boutons custom quand l'utilisateur slide une ligne de la tableview vers la gauche
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // more
        /*
        let more = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = UIColor.lightGrayColor()
        */
        
        // favorite
        /*
        let favorite = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = UIColor.orangeColor()
        */
        
        // delete. Noter le .Desctructive dans le style qui donne automatiquement la couleur rouge
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { action, index in
            //print("Delete button tapped")
            self.myVelibStations.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        return [delete]
    }

}