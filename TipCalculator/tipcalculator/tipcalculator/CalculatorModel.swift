//
//  CalculatorModel.swift
//  tipcalculator
//
//  Created by nicolas on 27/01/2016.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import Foundation

struct CalculatorModel {
    //les deux variables de base
    var checkAmount = 0.0
    var serviceLevel = 1 //la note donnée au service 0, 1 ou 2
     
    //Tableaux des taux de tip payés et des messages
    let tipRates = [0.1, 0.15, 0.2]
    let tipMessages = ["Mauvais service", "Bon service", "Très bon service"]
    
    var computedTip : Double {
        return checkAmount * tipRates[serviceLevel]
    }
    
    func serviceLabelText()->String {
        return "\(tipMessages[serviceLevel]) : \(tipRates[serviceLevel] * Double(100))%"
    }
}