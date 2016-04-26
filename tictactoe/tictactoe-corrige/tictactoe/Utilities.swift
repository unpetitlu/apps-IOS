//
//  Utilities.swift
//  tictactoe
//
//  Created by Nicolas on 28/01/2016.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import Foundation
import UIKit

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

func isLandscape()->Bool {
    let orientation =  UIApplication.sharedApplication().statusBarOrientation
    
    return ((orientation == UIInterfaceOrientation.LandscapeLeft ) || (orientation == UIInterfaceOrientation.LandscapeRight))
}

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


extension Int {
    var secondsToTime : String {
        return String(format: "%02d:%02d", self / 60, self % 60)
        //"\(self/60):\(self % 60)"
    }
}





