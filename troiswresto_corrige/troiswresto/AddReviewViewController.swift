//
//  AddReviewViewController.swift
//  troiswresto
//
//  Created by nicolas on 27/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit

class AddReviewViewController: UIViewController {
    
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var ratingSlider : UISlider!
    @IBOutlet var ratingLabel : UILabel!
    @IBOutlet var nameLabel : UILabel!
    
    var resto : Resto!
    
    @IBAction func viewTapped() {
        //rend la main à la vue
        descriptionTextField.resignFirstResponder()
    }
    
    @IBAction func textFieldDidEndOnExit() {
        descriptionTextField.resignFirstResponder()
    }

    @IBAction func sliderValueChanged(sender : UISlider) {
        ratingLabel.text = "Note : \(Int(sender.value)) / 10"
    }
    
    @IBAction func sendReviewPressed () {
        
        descriptionTextField.resignFirstResponder()
        
        let myReview = Review(rating: Double(Int(ratingSlider.value)), date : NSDate())
        
        if descriptionTextField.text != "" {
            myReview.description = descriptionTextField.text
        }
        
        resto.sendReviewToCloud(myReview, completionHandler: {(error) in
            
            if error == nil {
                // envoi d'une notification avec l'objet myReview passé
                
                
                NSNotificationCenter.defaultCenter().postNotificationName("reviewsubmitted", object: nil, userInfo: ["rating" : myReview.rating, "message" : 998])
                
                
                
                logDebug("review success")
                
                if let coreUser = CoreDataHelper.fetchOneUser() {
                    myReview.persistReviewInCoreData(coreUser)
                }
                
                simpleAlert("Review submitted", message: nil, acceptTitle: nil, myController: self, completion: {() in
                    logDebug("going to dismiss")
                    
                    self.navigationController?.popViewControllerAnimated(true)
                })
            } else {
                logError("send review to cloud:\(error.description)")
            }
        })
    }
    
    // MARK: - Remonter la vue avec le clavier
    
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
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        ratingLabel.text = "Note : \(Int(ratingSlider.value)) / 10"
        nameLabel.text = resto.name

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
