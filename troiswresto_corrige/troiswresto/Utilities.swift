//
//  Utilities.swift
//  myvelib
//
//  Created by nicolas on 16/01/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import Alamofire
import Firebase

func distanceBetweenTwoPositions(position1 : CLLocation, _ position2: CLLocation)-> CLLocationDistance {
    return position1.distanceFromLocation(position2)

}

// http://nshipster.com/swift-documentation/

/**
 Sends a local notification to the device. Even if the app is exited.
 Notifications must have been previously registered.
 - parameter delay: the delay in seconds
*/
func scheduleLocalNotification (message : String, delay : Double) {
    let localNotification = UILocalNotification()
    localNotification.fireDate = NSDate(timeIntervalSinceNow: delay)
    localNotification.alertBody = message
    localNotification.soundName = UILocalNotificationDefaultSoundName
    localNotification.timeZone = NSTimeZone.defaultTimeZone()
    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
}

/**
 Gets the status of the app for remote and local notifications.
 
 Returns a tuple with booleans for all status.
 */
func getPushNotificationsStatus()->(remote: Bool, none: Bool, alerts: Bool, badges: Bool, sounds: Bool) {
    let remoteNotificationsEnabled = UIApplication.sharedApplication().isRegisteredForRemoteNotifications()
    //au cas où les settings ne sont pas accessibles
    if let userNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings() {
        let notificationType = userNotificationSettings.types
        
        let noneEnabled = notificationType == UIUserNotificationType.None
        let alertsEnabled = notificationType.contains([.Alert])
        let soundsEnabled = notificationType.contains([.Sound])
        let badgesEnabled = notificationType.contains([.Badge])
        
        return (remote: remoteNotificationsEnabled, none: noneEnabled, alerts : alertsEnabled, badges : badgesEnabled, sounds: soundsEnabled)
    } else {
        return (remote: false, none: true, alerts : false, badges : false, sounds: false)
    }
    
}

func logDebug (myString: String) {
    if (TESTVERSION) {
        NSLog("debug:" + myString)
    }
}

func logWarning (myString: String) {
    NSLog("⚡️warning⚡️:" + myString)
}

func logError (myString: String) {
    NSLog("💔error💔:" + myString)
}

extension String {
    var translate :String {
        return NSLocalizedString(self, comment: "")
    }
    
    
    func trimBefore(needle: String)->String {
        var output = self
        if let position = self.rangeOfString(needle) {
            output.removeRange(self.startIndex..<position.endIndex)
        }
        return output
    }
}

func customAnimationMoveRight (theview: UIView, duree: Float, completionHandler:()->Void) {
    let x1 = theview.frame.origin.x
    let y1 = theview.frame.origin.y
    let w1 = theview.frame.size.width
    let h1 = theview.frame.size.height
    
    theview.hidden = false
    
    
    UIView.animateWithDuration(NSTimeInterval(duree), delay: 0, options: [], animations: {
        theview.frame = CGRect(x: x1 + 50, y: y1, width: w1, height: h1)
        }) {(Bool) in
            //println("after frame=\(theview.frame)")
            completionHandler()
    }
}

func customAnimationMoveDown (theview: UIView, duree: Float, completionHandler:(()->Void)? ) {
    let x1 = theview.frame.origin.x
    let y1 = theview.frame.origin.y
    let w1 = theview.frame.size.width
    let h1 = theview.frame.size.height
    
    theview.hidden = false
    

    
    UIView.animateWithDuration(NSTimeInterval(duree), delay: 0, options: [], animations: {
        theview.frame = CGRect(x: x1 , y: y1 + 50, width: w1, height: h1)
    }) {(Bool) in
        //println("after frame=\(theview.frame)")
        completionHandler!()
    }
}

func logUserDefaultsWithFilter(needle: String?) {
    print("******    User Defaults  ******")
    for (key, value) in NSUserDefaults.standardUserDefaults().dictionaryRepresentation() {
        
        if (needle != nil) {
            if key.rangeOfString(needle!) != nil {
                logDebug("key=\(key) value=\(value)\n")
            }
        } else {
            logDebug("key=\(key) value=\(value)\n")
        }
    }
}

func isLandscape()->Bool {
    let orientation =  UIApplication.sharedApplication().statusBarOrientation
    
    return ((orientation == UIInterfaceOrientation.LandscapeLeft ) || (orientation == UIInterfaceOrientation.LandscapeRight))
}

func isIpad()->Bool {
    return UIDevice.currentDevice().userInterfaceIdiom == .Pad
}

func deviceScreenHeight()->Float {// renvoie la  hauteur du device, independamment de l'orientation
    if isLandscape() {
        //  println("returning width instead of height")
        return Float(UIScreen.mainScreen().bounds.size.width)
    } else {
        return Float(UIScreen.mainScreen().bounds.size.height)
    }
}

func getDevice ()-> String {//retourne le nom du modèle basé sur la hauteur
    #if os(iOS)
        let deviceHeight = deviceScreenHeight()
        
        //   println("realheight=\(deviceHeight)")
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            return "iPad"
        }
        else {
            switch deviceHeight {
            case 480:
                return "iPhone4"
            case 568:
                return "iPhone5"
            case 667:
                return "iPhone6"
            case 736:
                return "iPhone6plus"
            default:
                return "unknown"
            }
        }
    #else
        return "AppleTV"
    #endif
}


func getUserLanguage()->String {//from defined languages in localisation, "en" as default
    let displayNameString = NSLocale.preferredLanguages()[0]
    var output = "en"
    
    logDebug("langageString=\(displayNameString)")
    
    if (displayNameString.rangeOfString("fr") != nil) { output = "fr"  }
    if (displayNameString.rangeOfString("es") != nil) { output = "es"  }
    if (displayNameString.rangeOfString("de") != nil) { output = "de"  }
    if (displayNameString.rangeOfString("it") != nil) { output = "it"  }
    if (displayNameString.rangeOfString("Hans") != nil) { output = "zh" }
    if (displayNameString.rangeOfString("pt") != nil) { output = "pt" }
    if (displayNameString.rangeOfString("ko") != nil) { output = "ko" }
    if (displayNameString.rangeOfString("ja") != nil) { output = "ja" }
    if (displayNameString.rangeOfString("en-GB") != nil) { output = "en-GB" }
    
    return output
}

/*
func sendAnalyticsEvent(name : String, parameters : [String : String]?) {
    
    // dictionnaire vide qui va contenir les paramètres
    var params = [String:String]()
    
    // si paramaters est non vide, je le recopie dans params
    if parameters != nil {
        params = parameters!
    }
    
    // J'ajoute des paramètres standard que je vais retrouver dans tous les events
    params["landscape"] = isLandscape() ? "YES" : "NO"
    params["device"] = getDevice()
    params["langage"] = getUserLanguage()
    
    Flurry.logEvent(name, withParameters: params)
}
*/

extension Double {
    var toFormattedString : String {
        let formatter = NSNumberFormatter()
        
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        
        if let output = formatter.stringFromNumber(self) {
            return output
        } else {
            return ""
        }
    }
}

func simpleAlert(title: String?, message: String?, acceptTitle: String?, myController: UIViewController, completion:(()->Void)? ) {
    let alertController = UIAlertController(title: title , message: message != nil ? message! : "", preferredStyle: .Alert)
    
    // Create the action.
    let acceptAction = UIAlertAction(title: acceptTitle != nil ? acceptTitle! : "OK", style: .Default) { _ in
        completion?()
    }
    
    // Add the action.
    alertController.addAction(acceptAction)
    myController.presentViewController(alertController, animated: true, completion: nil)
}

func simpleActionSheet(title: String?, message: String?, acceptTitle: String?, myController: UIViewController, completion:(()->Void)? ) {
    let alertController = UIAlertController(title: title , message: message != nil ? message! : "", preferredStyle: .ActionSheet)
    
    // Create the action.
    let acceptAction = UIAlertAction(title: acceptTitle != nil ? acceptTitle! : "OK", style: .Default) { _ in
        completion?()
    }
    
    // Add the action.
    alertController.addAction(acceptAction)
    myController.presentViewController(alertController, animated: true, completion: nil)
}



/**
 Récupère une image dans une url donnée
 
 Fonction **synchrone**.
 
 Renvoie nil en cas d'erreur
 */

func getImageFromURL(fileURL: String)->UIImage? {
   // print("loading remote image:\(fileURL)")
    
    if let myurl = NSURL(string: fileURL) {
        if let mydata = NSData(contentsOfURL: myurl) {
            if let result = UIImage(data: mydata) {
                return result
            } else {
                logWarning("pb pour convertir en UIImage pour fileUrl=\(fileURL)")
                return nil
            }
        } else {
            logWarning("pb pour convertir en NSData pour fileUrl=\(fileURL)")
            return nil
        }
    } else {
        logWarning("error: not a valid url for:\(fileURL)")
        return nil
    }
}

func getDataFromURL(fileURL: String)->NSData? {
   // print("loading remote data:\(fileURL)")
    
    if let myurl = NSURL(string: fileURL) {
        if let mydata = NSData(contentsOfURL: myurl) {
            return mydata
        } else {
            logWarning("pb pour convertir en NSData pour fileUrl=\(fileURL)")
            return nil
        }
    } else {
        logWarning("error: not a valid url for:\(fileURL)")
        return nil
    }
}



func getImageFromURLV2(fileURL: String, completionHandler:(image: UIImage?)->Void ) {
    // print("loading remote image:\(fileURL)")
    
    if let myurl = NSURL(string: fileURL) {
        logDebug("launching image request")

        Alamofire.request(.GET, myurl, parameters : nil)//by alamofire
            .response { (request, response, data, error) in
                
                logDebug("image request received")
                
                if error == nil && data != nil {
                    if let result = UIImage(data: data!) {
                        completionHandler(image: result)
                        //return result
                    } else {
                        logDebug("pb pour convertir en UIImage pour :\(fileURL)")
                        completionHandler(image: nil)
                    }
                } else {
                    logWarning("erreur dans la requete pour :\(fileURL)")
                    completionHandler(image: nil)
                }
        }
    } else {
        logDebug("error: not a valid url for:\(fileURL)")
        completionHandler(image: nil)
    }
}


func downloadFileFromUrl(fileUrl : String) {
    Alamofire.download(.GET, fileUrl) { temporaryURL, response in
        let fileManager = NSFileManager.defaultManager()
        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let pathComponent = response.suggestedFilename
        
        let totox = directoryURL.URLByAppendingPathComponent(pathComponent!)
        logDebug("\(totox)")
        
        // envoi à la fin
        
        return directoryURL.URLByAppendingPathComponent(pathComponent!)
    }
}

/**
 * Renvoi une String avec la date en UTC
 */
extension NSDate {
    var absoluteDateToString : String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "UTC")
        return formatter.stringFromDate(self)
    }
    
    var toSimpleDate : String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        return formatter.stringFromDate(self)
    }
}

extension String {
    var toAbsoluteDate : NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "UTC")
        
        if let date = formatter.dateFromString(self) {
            return date
        } else {
            return nil
        }
    }
}

//renvoie la largeur effective compte tenu de l'orientation (et non pas la largeur du device)
func realScreenWidth() -> CGFloat {
    if isLandscape() {
        return CGFloat(UIScreen.mainScreen().bounds.size.height)
    } else {
        return CGFloat(UIScreen.mainScreen().bounds.size.width)
    }
}

//renvoie la hauteur effective compte tenu de l'orientation (et non pas la hauteur du device)
func realScreenHeight()->CGFloat {// renvoie la bonne hauteur compte tenu d'un bug dans ios 7
    #if os(iOS)
        if isLandscape() {
            return CGFloat(UIScreen.mainScreen().bounds.size.width)
        } else {
            return CGFloat(UIScreen.mainScreen().bounds.size.height)
        }
    #else
        return 1080
    #endif
}



enum ToastStyle {
    case FromTop
    case FromBottom
}

func makeToast(myview: UIView, message: String, offset: CGFloat, withStyle toastStyle:ToastStyle ) {
    let height: CGFloat = 40
    let waitingTime = 2.0
    
    var startPosition = CGPoint()
    var middlePosition = CGPoint()
    
    switch toastStyle {
    case .FromTop:
        startPosition = CGPoint(x: 10, y: -height)
        middlePosition = CGPoint(x: 10, y: offset)
    case .FromBottom:
        startPosition = CGPoint(x: 10, y: realScreenHeight())
        middlePosition = CGPoint(x: 10, y: realScreenHeight() - offset - height)

    }
        let myToastView = UIView(frame: CGRectMake(startPosition.x, startPosition.y, realScreenWidth() - 20, height) )
        
        myToastView.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        
        let myLabel = UILabel(frame: CGRectMake(2, 2, realScreenWidth() - 20 - 4, height - 4))
        myLabel.text = message
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        
        myToastView.addSubview(myLabel)
        
        myview.addSubview(myToastView)
        myview.bringSubviewToFront(myToastView)
        
        UIView.animateWithDuration(1, delay: 0, options: [], animations: {
            myToastView.frame = CGRectMake(middlePosition.x, middlePosition.y, realScreenWidth() - 20, height)
            }, completion: nil)
        
        UIView.animateWithDuration(1, delay: waitingTime, options: [], animations: {
            myToastView.frame = CGRectMake(startPosition.x, startPosition.y, realScreenWidth() - 20, height)
            }, completion: {(Bool) in
                myToastView.removeFromSuperview()
        })
}

func makeToast(myview: UIView, message: String) {
    makeToast(myview, message: message, offset: 10, withStyle: .FromBottom)
}








