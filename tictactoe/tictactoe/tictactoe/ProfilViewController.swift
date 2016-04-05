//
//  ProfilViewController.swift
//  tictactoe
//
//  Created by etudiant-02 on 05/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

class ProfilViewController: UIViewController {

    @IBOutlet var pickerView : UIPickerView!
    
    var pickerData = [Int]()
    
    var game : Game!
    
    var mainViewController : MainViewController!
    
    var chosen : Int!
    
    
    // MARK: - delegate methods du PickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //title for row attend un optionel en sortie. On vérifie que l'index row est bien présent dans le tableau
        if (row < pickerData.count) {
            return "\(pickerData[row]) x \(pickerData[row])"
        } else {
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //row donne l'index de la ligne
        chosen = pickerData[row]
    }
    // MARK: -
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if chosen != mainViewController.game.nbColumns
        {
            NSUserDefaults.standardUserDefaults().setInteger(chosen, forKey: "columns")
            mainViewController.game.nbColumns = chosen
            mainViewController.restart()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var index = 3
        while index <= 7 {
            pickerData.append(index)
            index += 1
        }
        
        if let indexPicker = pickerData.indexOf(mainViewController.game.nbColumns) {
            self.pickerView.selectRow(indexPicker, inComponent: 0, animated: true)
        } else {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
