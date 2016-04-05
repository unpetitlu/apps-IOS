//
//  Utilities.swift
//  tictactoe
//
//  Created by etudiant-02 on 01/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func toFormattedString(digits : Int) -> String? {
        let formatter = NSNumberFormatter()
        
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = digits
        formatter.minimumFractionDigits = digits
        
        if let output = formatter.stringFromNumber(self) {
            return output
        } else {
            return nil
        }
    }
}

/**
    Renvoie la largeur effective compte tenu de l'orientation (et non pas la hauteur du device)
    - returns: CGFloat
*/
func realScreenWidth() -> CGFloat {
    if isLandscape() {
        return CGFloat(UIScreen.mainScreen().bounds.size.height)
    } else {
        return CGFloat(UIScreen.mainScreen().bounds.size.width)
    }
}

/**
    Renvoie la hauteur effective compte tenu de l'orientation (et non pas la hauteur du device)
    - returns: CGFloat
*/
func realScreenHeight() -> CGFloat {
    if isLandscape() {
        return CGFloat(UIScreen.mainScreen().bounds.size.width)
    } else {
        return CGFloat(UIScreen.mainScreen().bounds.size.height)
    }
}

/**
    Position paysage
    - returns: Bool
*/
func isLandscape() -> Bool {
    let orientation =  UIApplication.sharedApplication().statusBarOrientation
    
    return ((orientation == UIInterfaceOrientation.LandscapeLeft ) || (orientation == UIInterfaceOrientation.LandscapeRight))
}