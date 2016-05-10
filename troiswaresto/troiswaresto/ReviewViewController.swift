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
    var coreDataUser : CoreDataUser?
    
    @IBAction func changeValueRating(sender: UISlider!)
    {
        rateSlider = Int(sender.value)
    }
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addReviewButtonPressed() {
        /* DATE - AVANT UTILISATION DE L'EXTENSION
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let mydateString = dateFormatter.stringFromDate(now)
        */
        
        // DATE - APRES UTILISATION DE L'EXTENSION
        let mydateString = NSDate().absoluteDateToString

        resto.addReview(Double(rateSlider), comment: commentText.text, author: authorText.text, dateReview: mydateString) { (success) in
            if success {
                simpleAlert("Bravo !", message: "Votre commentaire a bien été ajouté", view: self)
                
                if self.coreDataUser != nil {
                    // Ajout de la review dans le coreData
                    let review = Review(rate: Double(self.rateSlider))
                    review.comment = self.commentText.text
                    review.nickname = self.authorText.text
                    review.dateOfReview = mydateString
                    review.persistReviewWithCoreData(self.coreDataUser!)
                }
                
            } else {
                simpleAlert("Oups !", message: "Un problème est survenu", view: self)
            }
        }

    }
    
    
    func updateDisplay() {
        if let currentUser = CoreDataHelper.fetchOneUser() {
            coreDataUser = currentUser
            authorText.text = currentUser.nickname
        }
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
