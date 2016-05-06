//
//  ViewController.swift
//  alert
//
//  Created by etudiant-02 on 02/05/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        simpleAlert("hello", message: "coucou", view: self, successHandler: {print("coucou")}, cancelHandler: {print("toto")})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

