//
//  ViewController.swift
//  myvelib
//
//  Created by etudiant-02 on 11/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController {
    
    @IBOutlet var stationLabel : UILabel!
    @IBOutlet var nbBikeLabel : UILabel!
    @IBOutlet var nbAvailableBikeStandLabel : UILabel!
    
    @IBOutlet var sendButton : UIButton!
    
    let stationId = 18037
    
    @IBAction func sendButtonPressed(sender : UIButton)
    {
        getStationInfo(stationId)
    }
    
    /* Utilisation de "Alamofire" pour le JSON */
    func getStationInfo(stationId : Int)  {
        
        let urlString = "\(APIURL)/stations/\(stationId)?contract=\(APICONTRACT)&apiKey=\(APIKEY)"
        
        Alamofire.request(.GET, urlString, parameters : nil)
            .response { (request, response, data, error) in
                if (error == nil) {
                    NSLog("data=\(data)")
                    let json = JSON(data: data!)
                    NSLog("json=\(json)")
                    
                    if let available_bike_stands = json["available_bike_stands"].number {
                        self.nbAvailableBikeStandLabel.text = "\(available_bike_stands)"
                    }
                    
                    if let available_bikes = json["available_bikes"].number {
                        self.self.nbBikeLabel.text = "\(available_bikes)"
                    }
                    
                    if let number = json["number"].number {
                        self.stationLabel.text = "\(number)"
                    }
                    
                }
        }
        NSLog("fonction getStationInfo terminée")
        
        
        
    }
    
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

