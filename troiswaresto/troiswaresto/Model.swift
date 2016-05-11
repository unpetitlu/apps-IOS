//
//  Model.swift
//  troiswaresto
//
//  Created by etudiant-02 on 27/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import Alamofire
import SwiftyJSON
import MapKit
import Firebase

enum ScreenType {
    case AddResto
    case AllRestos
    case OneResto
}


// J'envoi la vue afin de pouvoir rafraichir la table pour les images
func getRestosInfoWithFirebase (view: UITableView, completion:(restos : [Resto])->Void)  {

    var output = [Resto]()
    
    let restosRef = Firebase(url:"\(ROOTFIREBASEURL)/data/restos")
    
    restosRef.observeSingleEventOfType(.Value, withBlock: {
        snapshot in
        for item in snapshot.children.allObjects as! [FDataSnapshot] {

            if let name = item.value.objectForKey("name") as? String,
                let position = item.value.objectForKey("position") as? [String:Double],
                let positionLat = position["lat"],
                let positionLng = position["lng"]
            {
                let resto = Resto(restoId: item.key, name: name, position: CLLocation(latitude: positionLat, longitude: positionLng))
                
                if let description = item.value.objectForKey("description") as? String {
                    resto.description = description
                }
                
                if let priceRange = item.value.objectForKey("priceRange") as? Int {
                    // ex: PriceRange(rawValue:1) permet de récupérer la valeur de l'enum par rapport à un chiffre
                    // Pour récupérer le chiffre par rapport à une valeur il faut écrire : PriceRange.Low.rawValue
                    resto.priceRange = PriceRange(rawValue:Int(priceRange))
                }
                
                if let imageId = item.value.objectForKey("image") as? String {
                    getImageFromFirebase(imageId) { imageReceived in
                        resto.image = imageReceived
                        view.reloadData()
                    }
                }
                
                let reviews = item.childSnapshotForPath("reviews")
                for itemReview in reviews.children.allObjects as! [FDataSnapshot] {

                    if let rate = itemReview.value.objectForKey("rate") as? Double {
                        let reviewResto = Review(rate: rate)
                        
                        if let comment = itemReview.value.objectForKey("comment") as? String {
                            reviewResto.comment = comment
                        }
                        
                        if let nickname = itemReview.value.objectForKey("nickname") as? String {
                            reviewResto.nickname = nickname
                        }
                        
                        if let dateReview = itemReview.value.objectForKey("dateOfReview") as? String {
                            reviewResto.dateOfReview = dateReview.toAbsoluteDate
                        }
                        
                        resto.reviews.append(reviewResto)
                    }
                }
                
                output.append(resto)
                
            } else {
                
            }
            
        }
        
        completion(restos: output)
    })
}

// Récupère l'intégralité des restos
// completionHandler permet de créer une closure. Celle-ci retournera tous les restos uniquement lorsque la requête asynchrone sera terminée
func getRestosInfo(completionHandler : (restos : [Resto]) -> () )
{
    var allResto = [Resto]()
    let urlString = "\(ROOTFIREBASEURL)/data/restos.json"
    
    Alamofire.request(.GET, urlString, parameters : nil)
        .response { (request, response, data, error) in
            
            if (error == nil) {
                let json = JSON(data: data!)
                
                for (key, subJson) : (String, JSON) in json {

                    if  let name = subJson["name"].string,
                        let positionLat = subJson["position"]["lat"].double,
                        let positionLng = subJson["position"]["lng"].double
                    {
                        let resto = Resto(restoId: key, name: name, position: CLLocation(latitude: positionLat, longitude: positionLng))
                        
                        if let description = subJson["description"].string {
                            resto.description = description
                        }
                        
                        if let priceRange = subJson["priceRange"].number {
                            // ex: PriceRange(rawValue:1) permet de récupérer la valeur de l'enum par rapport à un chiffre
                            // Pour récupérer le chiffre par rapport à une valeur il faut écrire : PriceRange.Low.rawValue
                            resto.priceRange = PriceRange(rawValue:Int(priceRange))
                        }
                        
                        if let imageId = subJson["image"].string {
                            getImageFromFirebase(imageId) { imageReceived in
                                resto.image = imageReceived
                            }
                        }
                        
                        let jsonReview = subJson["reviews"]
                        for (_,item) : (String, JSON) in jsonReview {

                            if let rate = item["rate"].double {
                                let reviewResto = Review(rate: rate)
                                
                                if let comment = item["comment"].string {
                                    reviewResto.comment = comment
                                }
                                
                                if let nickname = item["nickname"].string {
                                    reviewResto.nickname = nickname
                                }
                                
                                if let dateReview = item["dateOfReview"].string {
                                    reviewResto.dateOfReview = dateReview.toAbsoluteDate
                                }

                                resto.reviews.append(reviewResto)
                            }
                            
                        }

                        allResto.append(resto)
                        
                    } else {
                        //sendAnalyticsEvent("error-request-api-velib", parameters: ["errorAPI" : "values"])
                    }
                }
                
            } else {
                // Possibilité d'envoyer un petit analytic si le code se passe mal
                //sendAnalyticsEvent("error-request-api-velib", parameters: ["errorAPI" : "request"])
            }
            
            // Retourne la closure lorsque la requête asynchrone se termine
            completionHandler(restos: allResto)
            
    }
    
}



// fonction pour réduire une image d'un facteur entier
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


// Permet d'uploader une image sur Firebase
// http://richardbakare.com/thursday-tech-tip-firebase-images/
func uploadImageToFirebase(image: UIImage, completion: (imageId : String?)->Void ) {
    
    //reduction de la taille de l'image si elle est trop grande
    var resizedImage = image
    if image.size.width > 2400 {
        logWarning("initial size=\(image.size)")
        resizedImage = reduceImage(image, factor: 2)
        logWarning("reduced size=\(resizedImage.size)")
    }
    
    if let myData: NSData = UIImageJPEGRepresentation(resizedImage, 0.5) {
        let imageString = myData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        let myRef = Firebase(url:ROOTFIREBASEURL).childByAppendingPath("data/images").childByAutoId()
        
        // logWarning("size for imagedata:\(imageString.characters.count)")
        
        myRef.setValue(["imagedata" : imageString], withCompletionBlock: {(error, ref) in
            
            if error == nil {
                logWarning("upload image OK")
                completion(imageId: myRef.key)
            } else {
                logError("error to save image in Firebase:\(error.description)")
                completion(imageId: nil)
            }
        })
    } else {
        completion(imageId: nil)
        logError("error to save image in Firebase, data not good")
    }
}


// Permet de récupérer une image depuis Firebase
func getImageFromFirebase(imageId : String, completionHandler:(image : UIImage?)->Void ) {
    let myRef = Firebase(url:ROOTFIREBASEURL).childByAppendingPath("data/images/\(imageId)")
    
    logDebug("launching request to Firebase for imageId=\(imageId)")
    
    myRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
        logDebug("snapshot received from Firebase for imageId=\(imageId)")
        if let myString = snapshot.value.objectForKey("imagedata") as? String {
            // logDebug("size for imageString:\(myString.characters.count)")
            logDebug("we have myString for \(imageId)")
            
            if let data = NSData(base64EncodedString: myString, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                logDebug("we have data for \(imageId)")
                
                if let myImage = UIImage(data:data,scale:1.0) {
                    logDebug("we have image for \(imageId)")
                    
                    completionHandler(image: myImage)
                } else {
                    logError("no data in getImageFromFirebase")
                    completionHandler(image: nil)
                }
                
            } else {
                logError("no snpashot in getImageFromFirebase")
                completionHandler(image: nil)
            }
        }
    })
}

// MARK: - get user
func getUserFromUserDefault() -> User? {
    if let pwd = NSUserDefaults.standardUserDefaults().objectForKey("pwd"),
        let nickname = NSUserDefaults.standardUserDefaults().objectForKey("nickname"),
        let email = NSUserDefaults.standardUserDefaults().objectForKey("email"),
        let userid = NSUserDefaults.standardUserDefaults().objectForKey("userid")
    {
        return User(nickname: nickname as! String, email: email as! String, password: pwd as! String, userId: userid as! String)
    } else {
        return nil
    }
}


