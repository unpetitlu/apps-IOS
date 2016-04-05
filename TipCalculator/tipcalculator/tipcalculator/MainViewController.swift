//
//  ViewController.swift
//  tipcalculator
//
//  Created by Nicolas on 25/01/2016.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var welcomeLabel : UILabel!
    @IBOutlet var startButton : UIButton!

    @IBAction func startButtonPressed () {
        print("Bouton start pressed")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        welcomeLabel.text = "Hello World"
        startButton.setTitle("Start", forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

