//
//  Utilities.swift
//  troiswaresto
//
//  Created by etudiant-02 on 25/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

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

extension Int {
    var secondsToTime : String {
        return String(format: "%02d:%02d", self / 60, self % 60)
        //"\(self/60):\(self % 60)"
    }
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