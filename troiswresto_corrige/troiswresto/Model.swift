//
//  Model.Swift
//  troiswresto
//
//  Created by nicolas on 26/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation
import Firebase

enum ScreenType {
    case AllRestos
    case OneResto
}



/*
func getStationsInfoWithJson (myTableView : UITableView, completion:(stations : [Resto])->Void)  {
    logDebug("launch resto request")
    
    let urlString = "\(firebaseUrl)/data/resto.json"
    
    var output = [Resto]()
    
    Alamofire.request(.GET, urlString, parameters : nil)//by alamofire
        .response { (request, response, data, error) in
            
            logDebug("request received")
            
            if error == nil && data != nil {
                let json = JSON(data: data!)//json est un tableau ici
                
                for (key,subJson):(String, JSON) in json {
                    
                    if let name = subJson["name"].string, let latitude = subJson["position"]["lat"].double, let longitude = subJson["position"]["long"].double {
                        let oneResto = Resto(restoId: key, name: name, position: CLLocation(latitude: latitude, longitude: longitude))
                        
                        if let description = subJson["description"].string {
                            oneResto.description = description
                        }
                        
                        if let priceRangeValue = subJson["priceRange"].int {
                            if let priceRange = PriceRange(rawValue: priceRangeValue) {
                                oneResto.priceRange = priceRange
                            }
                        }
                        
                        if let imageUrl = subJson["imageUrl"].string {
                           // oneResto.image = getImageFromURL(imageUrl)
                            
                            getImageFromURLV2(imageUrl, completionHandler: {(image) in
                                if image != nil {
                                    oneResto.image = image!
                                    myTableView.reloadData()
                                    
                                } else {
                                    logWarning("pb with image for resto:\(oneResto.name)")
                                    oneResto.image = UIImage(named: "resto")
                                }
                            
                            })
                        } else {
                            oneResto.image = UIImage(named: "resto")
                        }
                        
                        // ajout des reviews
                        for (_, reviewJson):(String,JSON) in subJson["reviews"] {
                            if let rating = reviewJson["rating"].double {
                                
                                let oneReview = Review(rating: rating)
                                
                                if let description = reviewJson["description"].string {
                                    oneReview.description = description
                                }
                                
                                if let nickname = reviewJson["nickName"].string {
                                    oneReview.nickName = nickname
                                }
                                oneResto.reviews.append(oneReview)
                            }
                        }
                        output.append(oneResto)
                    }
                }
                
                completion(stations: output)
                
            } else {
                logError("error in GetStation=\(error)")
                completion(stations: output)
            }
    }
}
*/

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

// http://nshipster.com/image-resizing/
func reduceImage(image : UIImage, factor : Int)-> UIImage {
    let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(1 / CGFloat(factor), 1 / CGFloat(factor)))
    let hasAlpha = false
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
    
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    image.drawInRect(CGRect(origin: CGPointZero, size: size))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
}


func deleteRestoInFirebase(restoId: String) {
    let myRef = Firebase(url:firebaseUrl).childByAppendingPath("data/resto/\(restoId)")
    
    myRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
        
        if let imageId = snapshot.value.objectForKey("imageId") as? String {
           // logDebug("imageId=\(imageId)")
            let imageRef = Firebase(url:firebaseUrl).childByAppendingPath("data/images/\(imageId)")
            imageRef.removeValue()
        }
        
        myRef.removeValue()
    })
}

func getAdressFromLocation (location : CLLocation, completion:(String)->Void ) {
    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
        var output = ""
        if (error != nil) {
            print("Reverse geocoder failed with error" + error!.localizedDescription)
            output = "error"
        }
        
        if placemarks!.count > 0 {
            let pm = placemarks![0] as CLPlacemark
            if pm.thoroughfare != nil && pm.subThoroughfare != nil {
                output =  pm.subThoroughfare! + " " + pm.thoroughfare!
            } else {
                output = ""
            }
        } else {
            output = "Problem with the data received from geocoder"
        }
        completion(output)
    })
}




//MARK: - User


