//
//  Utilities.swift
//  alcotest
//
//  Created by Nicolas on 15/02/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import Foundation
import UIKit

func simpleAlert(title: String?, message: String?, acceptTitle: String?, myController: UIViewController, completionHandler:(()->Void)? ) {
    let alertController = UIAlertController(title: title != nil ? title! : "Alert", message: message != nil ? message! : "", preferredStyle: .Alert)
    
    // Create the action.
    let acceptAction = UIAlertAction(title: acceptTitle != nil ? acceptTitle! : "OK", style: .Default) { _ in
        completionHandler?()
        // print("The simple alert's accept action occurred.")
    }
    
    // Add the action.
    alertController.addAction(acceptAction)
    myController.presentViewController(alertController, animated: true, completion: nil)
}

class Helper {
    func sayHello() {
        print("hello")
    }
    
    static func sayGoodbye() {
        print("Bye Bye")
    }
}

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

extension NSNumber {
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






