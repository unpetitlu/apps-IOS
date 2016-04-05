//
//  CalculatorViewController.swift
//  tipcalculator
//
//  Created by Nicolas on 26/01/2016.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet var backButton : UIButton!
    @IBOutlet var tipAmountLabel: UILabel!
    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var serviceLabel: UILabel!
    @IBOutlet var checkAmountTextField: UITextField!

    @IBOutlet var serviceLevel0Button : UIButton!
    @IBOutlet var serviceLevel1Button : UIButton!
    @IBOutlet var serviceLevel2Button : UIButton!
    
    var calculatorModel = CalculatorModel()// l'instance du model. Est globale au ViewController.
    
    @IBAction func backButtonPressed() {
        //ferme la vue modale
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func serviceLevelButtonPressed (sender: UIButton!) {
      //  print("tag=\(sender.tag)")
        calculatorModel.serviceLevel = sender.tag
        updateDisplay()
    }
    
    @IBAction func viewTapped() {
        //rend la main à la vue
        checkAmountTextField.resignFirstResponder()
        updateDisplay()
    }
    
    func stringToAmount(myString : String)->Double {
        if let number = Double(myString) {
            return number
        } else {
            return 0.0
        }
    }
    
    // effacement du champ quand l'utiisateur commence à saisir
    @IBAction func checkAmountEditingBegan () {
        checkAmountTextField.text = ""
    }
    
    // fonction appelée à la fin de la saisie du texte
    @IBAction func checkAmountEntered () {
        updateDisplay()
    }

    
/**
Récupère les données et met à jour l'affichage
*/
    func updateDisplay() {
        //on récupère la valeur de l'addition

 // Optional binding du texte inclus dans le UITextField
    if let checkAmountTemporaire = stringToDouble(checkAmountTextField.text!) {
            calculatorModel.checkAmount = checkAmountTemporaire

            //mise à jour des boutons
            let imagePleine = UIImage(named:"fleche_pleine")
            let imageCreuse = UIImage(named: "fleche_creuse")
            
            serviceLevel0Button.setBackgroundImage(imagePleine, forState: UIControlState.Normal)
            serviceLevel1Button.setBackgroundImage(calculatorModel.serviceLevel >= 1 ? imagePleine : imageCreuse, forState: UIControlState.Normal)
            serviceLevel2Button.setBackgroundImage(calculatorModel.serviceLevel >= 2 ? imagePleine : imageCreuse, forState: UIControlState.Normal)
            
            checkAmountTextField.text = calculatorModel.checkAmount.toString!
            serviceLabel.text = calculatorModel.serviceLabelText()
            
            tipAmountLabel.text = calculatorModel.computedTip.toString! + " €"
        } else {
            tipAmountLabel.text = "Saisir un montant"
        }
        

    }
    
    //fonction lancée au chargement initial de la vue
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.setTitle("Retour", forState: UIControlState.Normal)
        tipLabel.text = "Tip"
        checkAmountTextField.text = "100"
        tipAmountLabel.adjustsFontSizeToFitWidth = true

        updateDisplay()
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
    // MARK: -

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
