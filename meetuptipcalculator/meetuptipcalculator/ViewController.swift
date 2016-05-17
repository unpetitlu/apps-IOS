//
//  ViewController.swift
//  meetuptipcalculator
//
//  Created by nicolas on 12/05/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hello World !
        welcomeLabel.text = "Hello World"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

