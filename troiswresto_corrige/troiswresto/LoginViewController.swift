//
//  LoginViewController.swift
//  troiswrestos
//
//  Created by nicolas on 20/02/2016.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var emailTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!

    
    @IBAction func viewTapped() {
        //rend la main à la vue
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func okButtonPressed() {
        
        logDebug("trying to login")
        let email = emailTextField.text!
        let password = passwordTextField.text!

        if email != "" && password != ""  {
            FirebaseHelper.loginUserInFirebase(email, password: password) {(success, user) in
                if success {

                    simpleAlert("loginsuccess".translate, message: nil, acceptTitle: nil, myController: self, completion: {() in
                    self.navigationController?.popViewControllerAnimated(true)
                    })
                } else {
                    simpleAlert("errortologin".translate, message: nil, acceptTitle: nil, myController: self, completion: nil)
                }
            }
        } else {
            logDebug("fields empty")

            simpleAlert("enteremailandpassword".translate, message: nil, acceptTitle: nil, myController: self, completion: nil)
        }
    }
    /*
    // MARK: - Remonter la vue avec le clavier
    func textFieldDidBeginEditing(textField: UITextField) {
        logDebug("did begin editing")
        animateViewMoving(true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        logDebug("did end editing")

        animateViewMoving(false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        logDebug("animate view up=\(up)")

        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    // MARK: -
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
