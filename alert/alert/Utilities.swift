//
//  Utilities.swift
//  alert
//
//  Created by etudiant-02 on 02/05/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

func simpleAlert(title: String, message: String, view: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)

    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alertController.addAction(OKAction)
    
    view.presentViewController(alertController, animated: true, completion: nil)
}


func simpleAlert(title: String, message: String, view: UIViewController, successHandler: ()->(), cancelHandler: ()->() ) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
    let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        successHandler()
    }
    alertController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
        cancelHandler()
    }
    alertController.addAction(cancelAction)
    
    view.presentViewController(alertController, animated: true, completion: nil)
}