//
//  ReviewViewController.swift
//  troiswaresto
//
//  Created by etudiant-02 on 28/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var authorText : UITextField!
    @IBOutlet var commentText : UITextField!
    
    var rateSlider = 10
    var resto : Resto!
    
    @IBAction func changeValueRating(sender: UISlider!)
    {
        rateSlider = Int(sender.value)
    }
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addReviewButtonPressed() {
        resto.addReview(Double(rateSlider), comment: commentText.text, author: authorText.text) { (success) in
            if success {
                simpleAlert("Bravo !", message: "Votre commentaire a bien été ajouté", view: self)
            } else {
                simpleAlert("Oups !", message: "Un problème est survenu", view: self)
            }
        }
    }
    
    
    func updateDisplay() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDisplay()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
