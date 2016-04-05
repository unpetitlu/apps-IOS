//
//  Drinks.swift
//  alcotest
//
//  Created by Nicolas on 27/01/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import Foundation

// Paramètres pour toute l'application
let maxAlcooholRate = 0.8 // taux max d'alcool autorisé
let firstAlcooholRate = 0.5 // taux à partir duquel la jauge devient orange

struct Drink {
    var name : String
    let alcooholRate : Double
    let glassSize : Double
    
    // calcul pour chaque boisson de sa contribution au taux d'alcool en fonction du sexe.
    func contribution(sexe : Gender, nbOfGlasses : Int, weight: Int)->Double? {
        var sexRatio  = 0.7
        
        if sexe == .Woman {
            sexRatio = 0.6
        }
        
        if (weight != 0) {
            return (Double(nbOfGlasses) * glassSize * alcooholRate * 0.8) / (Double(weight) * sexRatio)
        } else {
            return nil
        }
    }
}


class User {
    var weight : Int
    var nbOfGlasses = [Int]()
    var gender : Gender
    
    /* init simple, remplacé par un constructeur qui tient compte du stockage
    init (gender : Gender, weight : Int, numberOfDrinks: Int) {
        self.weight = weight
        self.gender = gender
    }
 */
    
    
    init (gender : Gender, weight : Int) {
        
        // si une valeur a été stockée dans les UserDefaults, on prend celle là plutôt que celle fournie dans le constructeur
        if NSUserDefaults.standardUserDefaults().objectForKey("weight") != nil {
            self.weight = NSUserDefaults.standardUserDefaults().integerForKey("weight")
        } else {
            self.weight = weight
        }
        
        if NSUserDefaults.standardUserDefaults().objectForKey("gender") != nil {
            self.gender = NSUserDefaults.standardUserDefaults().integerForKey("gender") == 0 ? .Man : .Woman
        } else {
            self.gender = gender
        }
    }
    
    func computeAlcooholRate (drinks : [Drink])->Double {
        var output = 0.0
        
        if drinks.count != 0 {
            for index in 0..<drinks.count {
                output += drinks[index].contribution(self.gender, nbOfGlasses : nbOfGlasses[index], weight: weight)!
            }
        }
        return output
    }
    
    // stockage des données dans les NSUserDefaults
    func persistData() {
        NSUserDefaults.standardUserDefaults().setInteger(self.weight, forKey: "weight")
        NSUserDefaults.standardUserDefaults().setInteger((self.gender == .Man) ? 0 : 1, forKey: "gender")
        // force la sauvegarde. Pas obligatoire
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
}

enum Gender {
    case Man
    case Woman
}



