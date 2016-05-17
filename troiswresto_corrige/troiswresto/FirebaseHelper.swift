//
//  FirebaseHelper.swift
//  troiswresto
//
//  Created by nicolas on 26/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class FirebaseHelper {
    
   static func getStationsInfo (myTableView : UITableView, completion:(stations : [Resto])->Void)  {
        //  logDebug("launch resto request")
        let restosRef = Firebase(url:"\(firebaseUrl)/data/resto")
        
        restosRef.observeSingleEventOfType(.Value, withBlock: {
            
            // restosRef.observeEventType(.Value, withBlock: {
            snapshot in
            
            var output = [Resto]()
            
            logDebug("Received snapshot from getStationsInfo")
            
            for item in snapshot.children.allObjects as! [FDataSnapshot] {
                if let name = item.value.objectForKey("name") as? String,
                    let position = item.value.objectForKey("position") as? [String : Double],
                    let latitude = position["lat"],
                    let longitude = position["long"]
                    
                {
                    let oneResto = Resto(restoId: item.key, name: name, position: CLLocation(latitude: latitude, longitude: longitude))
                    
                    if let description = item.value.objectForKey("description") as? String {
                        oneResto.description = description
                    }
                    
                    if let address = item.value.objectForKey("address") as? String {
                        oneResto.address = address
                    }
                    
                    if let priceRangeValue = item.value.objectForKey("priceRange") as? Int {
                        if let priceRange = PriceRange(rawValue: priceRangeValue) {
                            oneResto.priceRange = priceRange
                        }
                    }
                    
                    if let imageId = item.value.objectForKey("imageId") as? String {
                        // oneResto.image = getImageFromURL(imageUrl)
                        
                        FirebaseHelper.getImageFromFirebase(imageId, completionHandler: {(image) in
                            if image != nil {
                                oneResto.image = image!
                                myTableView.reloadData()
                                
                            } else {
                                logWarning("pb with image for resto:\(oneResto.name)")
                            }
                            
                        })
                        
                    } else {
                        oneResto.image = nil
                    }
                    
                    let reviews = item.childSnapshotForPath("reviews")
                    
                    // ajout des reviews
                    
                    for review in reviews.children.allObjects as! [FDataSnapshot] {
                        if let rating = review.value.objectForKey("rating") as? Double {
                            
                            var mydate = NSDate?()
                            if let dateString = review.value.objectForKey("date") as? String,
                                let tempdate = dateString.toAbsoluteDate {
                                mydate = tempdate
                            } else {
                                mydate = nil
                            }
                            
                            let oneReview = Review(rating: rating, date: mydate)
                            
                            if let description = review.value.objectForKey("description") as? String {
                                oneReview.description = description
                            }
                            
                            if let nickname = review.value.objectForKey("nickName") as? String {
                                oneReview.nickName = nickname
                            }
                            oneResto.reviews.append(oneReview)
                        }
                    }
                    
                    output.append(oneResto)
                }
                
            } //fin de la boucle for
            completion(stations: output)
        })
    }
    
    /**
     Création d'un nouveau User dans la BDD Firebase.
     */
    static func createFirebaseUser(email : String, password : String, nickname : String, completion:(user : User?)->()) {
        
        logDebug("creating account with password=\(password) and nickname=\(nickname)")
        
        let rootRef = Firebase(url: "\(firebaseUrl)")
        rootRef.createUser(email, password: password, withValueCompletionBlock: {(error,result) in
            
            if error != nil {
                // There was an error creating the account
                logError("error to create user:\(error)")
                completion(user: nil)
            } else {
                if let uid = result["uid"] as? String {
                    logDebug("Successfully created user account with uid: \(uid)")
                    
                    let myUser = User(uid: uid, email: email, password: password, nickname: nickname)
                    
                    let userRef = Firebase(url:"\(firebaseUrl)/user").childByAppendingPath(uid)
                    
                    let myDict = ["email" : email, "nickname" : nickname]
                    
                    userRef.updateChildValues(myDict)
                    
                  //  myUser.updatePlayerId()
                 //   myUser.persistUser()
                    
                    completion(user: myUser)
                } else {
                    completion(user: nil)
                }
            }
        })
    }
    
    static func loginUserInFirebase (email : String, password: String, completion:(success : Bool, user : User?)->Void) {
        if (OPTIMIZEFIREBASE) { Firebase.goOnline() }
        
        let rootRef = Firebase(url: firebaseUrl)
        
        rootRef.authUser(email, password: password) {
            error, authData in
            
            if error != nil {
                logError("error to log in")
                
                // an error occured while attempting login
                completion(success: false, user : nil)
            } else {
                logDebug("User is logged in OK")
                
                let uid = authData.uid
                logDebug("uid=\(uid)")
                let userRef = rootRef.childByAppendingPath("user/\(uid)/nickname")
                
                userRef.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                    logDebug("snapshot=\(snapshot)")
                    if let nickname = snapshot.value as? String {
                        let me = User(uid: uid, email: email, password: password, nickname : nickname)
                        me.persistUser()
                        me.persistUserInCoreData()
                        
                        completion(success: true, user : me)
                    } else {
                        logError("no nickname")
                        completion(success: false, user : nil)
                        
                    }
                    
                })
        }
        }
    }
    
    
    func getFirebaseRestosList (completion:([Resto])->Void) {
        
        let restosRef = Firebase(url:"\(firebaseUrl)/data/resto")
        
        restosRef.observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            var output = [Resto]()
            
            // print("we received restos from Firebase \(snapshot.key) -> \(snapshot.value)")
            
            for item in snapshot.children.allObjects as! [FDataSnapshot] {
                // print("item brut:\(item.key)")
                //  print("item:\(snapshotToResto(item))")
                
                if let newResto = self.snapshotToResto(item) {
                    output.append(newResto)
                }
            }
            completion(output)
        })
    }
    
    func snapshotToResto(snapshot : FDataSnapshot)->Resto? {
        if let name = snapshot.value.objectForKey("name") as? String, let position = snapshot.value.objectForKey("position") as? [String:Double] {
            
            logDebug("position=\(position)")
            logDebug("lat=\(position["lat"]!)")
            logDebug("long=\(position["long"]!)")
            
            if let lat = position["lat"], let long = position["long"] {
                let output = Resto(restoId: snapshot.key, name: name, position: CLLocation(latitude: lat, longitude: long))
                return output
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    static func getImageFromFirebase(imageId : String, completionHandler:(image : UIImage?)->Void ) {
        let myRef = Firebase(url:firebaseUrl).childByAppendingPath("data/images/\(imageId)")
        
        logDebug("launching request to Firebase for imageId=\(imageId)")
        
        myRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            logDebug("snapshot received from Firebase for imageId=\(imageId)")
            if let myString = snapshot.value.objectForKey("imagedata") as? String {
                // logDebug("size for imageString:\(myString.characters.count)")
               // logDebug("we have myString for \(imageId)")
                
                if let data = NSData(base64EncodedString: myString, options: NSDataBase64DecodingOptions(rawValue: 0)) {
                   // logDebug("we have data for \(imageId)")
                    
                    if let myImage = UIImage(data:data,scale:1.0) {
                       // logDebug("we have image for \(imageId)")
                        
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
    
    // http://richardbakare.com/thursday-tech-tip-firebase-images/
    static func uploadImageToFirebase(image: UIImage, completion: (imageId : String?)->Void ) {
        
        //reduction de la taille de l'image
        
        let resizefactor = Int(image.size.width / 200)
        let resizedImage = reduceImage(image, factor: resizefactor)

        logDebug("initial size=\(image.size)")
        logDebug("reduced size=\(resizedImage.size)")
        
        if let myData: NSData = UIImageJPEGRepresentation(resizedImage, 0.4) {
            let imageString = myData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
            let myRef = Firebase(url:firebaseUrl).childByAppendingPath("data/images").childByAutoId()
            
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

    static func isUserAuthenticated (completion:(success : Bool)->Void) {
        
        let ref = Firebase(url: firebaseUrl)
        if ref.authData != nil {
            // user authenticated
            print("authenticated")
            print(ref.authData)
            completion(success : true)
        } else {
            // No user is signed in
            completion(success: false)
        }
    }
    
    static func logoutFromFirebase () {
        let rootRef = Firebase(url: firebaseUrl)
        
        rootRef.unauth()
    }

    
}