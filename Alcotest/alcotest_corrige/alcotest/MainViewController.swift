//
//  ViewController.swift
//  alcotest
//
//  Created by nicolas on 25/01/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var drink0GlassesLabel : UILabel!
    @IBOutlet var drink1GlassesLabel : UILabel!
    @IBOutlet var drink2GlassesLabel : UILabel!
    @IBOutlet var drink3GlassesLabel : UILabel!
    @IBOutlet var rateLabel : UILabel!
    @IBOutlet var progressView : UIProgressView!
    @IBOutlet var profileLabel : UILabel!
    
    var user : User!
    var drinks = [Drink]()
  //  var visualEffectView : UIVisualEffectView!
    
    @IBAction func drinkPressed (sender : UIButton) {
        user.nbOfGlasses[sender.tag] += 1
        updateDisplay()
    }
    
    @IBAction func resetButtonPressed() {
        for index in 0...3 {
            user.nbOfGlasses[index] = 0
        }
        updateDisplay()
    }
    
    @IBAction func drinkMinusPressed (sender : UIButton) {
        
        let tag = sender.tag
        
        user.nbOfGlasses[tag] -= 1
        
        if (user.nbOfGlasses[tag] < 0) {
            user.nbOfGlasses[tag] = 0
        }
        updateDisplay()
    }
    
    /**
    Met à jour les calculs et l'affichage.
    Est appelée à plusieurs endroits.
    */
    
    func updateDisplay() {
        drink0GlassesLabel.text = "\(user.nbOfGlasses[0])"
        drink1GlassesLabel.text = "\(user.nbOfGlasses[1])"
        drink2GlassesLabel.text = "\(user.nbOfGlasses[2])"
        drink3GlassesLabel.text = "\(user.nbOfGlasses[3])"
        
        let rate = user.computeAlcooholRate(drinks)
        rateLabel.text = String(format: "%0.2f", rate )
        
        let progressRate = rate/maxAlcooholRate
        
        progressView.setProgress(Float(progressRate), animated: true)
        
        progressView.tintColor = UIColor.blackColor()
        rateLabel.textColor = UIColor.blackColor()

        if (progressRate > firstAlcooholRate) {
            progressView.tintColor = UIColor.orangeColor()
            rateLabel.textColor = UIColor.orangeColor()
        }
        
        if (progressRate >= 1) {
            progressView.tintColor = UIColor.redColor()
            rateLabel.textColor = UIColor.redColor()
        }
        
        let sexeString = user.gender == .Man ? "homme" : "femme"
        profileLabel.text = "\(sexeString), poids = \(user.weight) kg"
    }
    
    // Prépare la transition vers l'écran Profile
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "maintoprofile")
        {
            let mydestination: ProfileViewController =  segue.destinationViewController as! ProfileViewController
            
            // l'instance user est passée par référence au ProfileViewController
            mydestination.user = user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("main view did load")
        
        // initialisation du user et des des drinks
        user = User(gender: .Man, weight : 70)// profil de départ
        user.nbOfGlasses = [0,0,0,0]
        
        drinks.append(Drink(name: "Bière", alcooholRate: 0.04, glassSize: 330))
        drinks.append(Drink(name: "Vin", alcooholRate: 0.12, glassSize: 120))
        drinks.append(Drink(name: "Whisky", alcooholRate: 0.40, glassSize: 50))
        drinks.append(Drink(name: "Porto", alcooholRate: 0.10, glassSize: 150))
        
        profileLabel.adjustsFontSizeToFitWidth = true
    
    }
    
    override func viewWillAppear(animated: Bool) {
        print("main view will appear")
        
        updateDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

