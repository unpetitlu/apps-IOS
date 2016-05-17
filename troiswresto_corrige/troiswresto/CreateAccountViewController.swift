//
//  CreateAccountViewController.swift
//  troiswrestos
//
//  Created by nicolas on 21/02/2016.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet var emailTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var nicknameTextField : UITextField!

    
    @IBAction func viewTapped() {
        //rend la main à la vue
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @IBAction func okButtonPressed() {
        
        logDebug("trying to login")
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let nickname = nicknameTextField.text!
        
        if email != "" && password != "" && nickname != "" {
            
            FirebaseHelper.createFirebaseUser(email, password: password, nickname: nickname, completion: {(user) in
                if user != nil {
                    simpleAlert("successtocreateuser".translate, message: nil, acceptTitle: nil, myController: self, completion: {() in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                } else {
                    simpleAlert("errortocreateuser".translate, message: nil, acceptTitle: nil, myController: self, completion: nil)
                }
            
            })
        } else {
            logDebug("fields empty")
            simpleAlert("enteremailandpassword".translate, message: nil, acceptTitle: nil, myController: self, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Remonter la vue avec le clavier
    /*
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
*/
}
