//
//  CreateProfileViewController.swift
//  troiswaresto
//
//  Created by etudiant-02 on 06/05/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController {

    @IBOutlet var loginTextField : UITextField!
    @IBOutlet var nicknameTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var passwordConfirmTextField : UITextField!
    
    @IBOutlet var createButton : UIButton!
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        FirebaseHelper.createFirebaseUser(loginTextField.text!, nickName: nicknameTextField.text!, password: passwordTextField.text!)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
