//
//  Utilities.swift
//  tipcalculator
//
//  Created by nicolas on 25/03/2016.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import Foundation

// fonction utilitaire pour récupérer la valeur d'une string affichée avec des chiffres derrière la virgule
// valable pour les deux formats de virgule
func stringToDouble(myString : String)->Double? {
    let converter = NSNumberFormatter()
    
    converter.decimalSeparator = ","
    if let result = converter.numberFromString(myString) {
        return result.doubleValue
    } else {
        converter.decimalSeparator = "."
        if let result = converter.numberFromString(myString) {
            return result.doubleValue
        } else {
            return nil
        }
    }
}

extension Double {
    var toString : String? {
        
        let formatter = NSNumberFormatter()
        
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        if let output = formatter.stringFromNumber(self) {
            return output
        } else {
            return nil
        }
    }
}