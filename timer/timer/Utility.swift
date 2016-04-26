//
//  Utility.swift
//  timer
//
//  Created by etudiant-02 on 21/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit



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