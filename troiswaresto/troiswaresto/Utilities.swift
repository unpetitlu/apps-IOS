//
//  Utilities.swift
//  troiswaresto
//
//  Created by etudiant-02 on 25/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

// MARK: - Log --------------------
let TESTVERSION = true

func logUserDefaultsWithFilter(needle: String?) {
    print("******    User Defaults  ******")
    for (key, value) in NSUserDefaults.standardUserDefaults().dictionaryRepresentation() {
        
        if (needle != nil) {
            if key.rangeOfString(needle!) != nil {
                NSLog("key=\(key) value=\(value)\n")
            }
        } else {
            logDebug("key=\(key) value=\(value)\n")
        }
    }
}

func logDebug (myString: String) {
    if (TESTVERSION) {
        NSLog("debug:" + myString)
    }
}

func logWarning (myString: String) {
    if (TESTVERSION) {
        NSLog("⚡️warning⚡️:" + myString)
    }
}

func logError (myString: String) {
    if (TESTVERSION) {
        NSLog("💔error💔:" + myString)
    }
}




// MARK: - Real height/width
//renvoie la largeur effective compte tenu de l'orientation (et non pas la largeur du device)
func realScreenWidth() -> CGFloat {
    if isLandscape() {
        return CGFloat(UIScreen.mainScreen().bounds.size.height)
    } else {
        return CGFloat(UIScreen.mainScreen().bounds.size.width)
    }
}

//renvoie la hauteur effective compte tenu de l'orientation (et non pas la hauteur du device)
func realScreenHeight()->CGFloat {
    if isLandscape() {
        return CGFloat(UIScreen.mainScreen().bounds.size.width)
    } else {
        return CGFloat(UIScreen.mainScreen().bounds.size.height)
    }
}





// MARK: - Apparition
func appearExpandView (image : UIView, duration : Double, delay : Double) {
    
    let x0 = image.frame.origin.x
    let y0 = image.frame.origin.y
    let w0 = image.frame.size.width
    let h0 = image.frame.size.height
    
    // modifie la view AVANT l'animation
    image.frame = CGRectMake(x0 + w0 / 2, y0 + w0 / 2, 0, 0)
    
    UIView.animateWithDuration(NSTimeInterval(duration), delay: delay, options: [], animations: {
        
        // frame de la vue A LA FIN de l'animation, on reprend la position initiale
        image.frame = CGRectMake(x0, y0, w0, h0);
        }, completion: nil)
}

func appearFromRight (theview: UIView, duree: Float, delay : Float, completionHandler:(()->Void)? ) {
    let x1 = theview.frame.origin.x
    let y1 = theview.frame.origin.y
    let w1 = theview.frame.size.width
    let h1 = theview.frame.size.height
    
    // modifie la view AVANT l'animation. La vue est décalée à droite
    theview.frame = CGRectMake(realScreenWidth(), y1, w1, h1)
    theview.hidden = false
    
    UIView.animateWithDuration(NSTimeInterval(duree), delay: 0, options: [], animations: {
        theview.frame = CGRectMake(x1, y1, w1, h1);
        }, completion: {(Bool) in
            
            if completionHandler != nil {
                completionHandler!()
            }
            
    })
}




// MARK: - Others
func isLandscape()->Bool {
    let orientation =  UIApplication.sharedApplication().statusBarOrientation
    
    return ((orientation == UIInterfaceOrientation.LandscapeLeft ) || (orientation == UIInterfaceOrientation.LandscapeRight))
}


// renvoie la  hauteur du device, independamment de l'orientation
func deviceScreenHeight()->Float {
    if isLandscape() {
        //  println("returning width instead of height")
        return Float(UIScreen.mainScreen().bounds.size.width)
    } else {
        return Float(UIScreen.mainScreen().bounds.size.height)
    }
}

//retourne le nom du modèle basé sur la hauteur
func getDevice ()-> String {
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

func isIpad()->Bool {
    return UIDevice.currentDevice().userInterfaceIdiom == .Pad
}

//from defined languages in localisation, "en" as default
func getUserLanguage()->String {
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


/**
 Récupère une image dans une url donnée
 
 Fonction **synchrone**.
 
 Renvoie nil en cas d'erreur
 */
func getImageFromURL(fileURL: String)->UIImage? {
    print("loading remote image:\(fileURL)")
    
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


// MARK: - Analytics
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

// MARK: - Simple alert
func simpleAlert(title: String, message: String, view: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(OKAction)
    
    view.presentViewController(alertController, animated: true, completion: nil)
}


func simpleAlert(title: String, message: String, view: UIViewController, successHandler: ()->(), cancelHandler: ()->() ) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
    let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        successHandler()
    }
    alertController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
        cancelHandler()
    }
    alertController.addAction(cancelAction)
    
    view.presentViewController(alertController, animated: true, completion: nil)
}
// MARK: - Simple alert like a toast
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

// MARK: - Extensions
extension Int {
    var secondsToTime : String {
        return String(format: "%02d:%02d", self / 60, self % 60)
        //"\(self/60):\(self % 60)"
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
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
}