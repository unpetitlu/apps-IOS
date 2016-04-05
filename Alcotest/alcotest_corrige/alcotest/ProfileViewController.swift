//
//  profileViewController.swift
//  alcotest
//
//  Created by nicolas on 27/01/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var segmentedControl : UISegmentedControl!
    @IBOutlet var weightLabel : UILabel!
    @IBOutlet var pickerView : UIPickerView!
    
    var user : User!
    var pickerData = [Int]()
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // appelée par le Segemented Control
    @IBAction func indexChanged(sender:UISegmentedControl)  {
        print("index=\(segmentedControl.selectedSegmentIndex)")
        
        if segmentedControl.selectedSegmentIndex == 0 {
            user.gender = .Man
        } else {
            user.gender = .Woman
            print("is now a woman")
        }
        user.persistData()
    }
    
    func updateDisplay() {
        switch user.gender {
        case .Man:
            segmentedControl.selectedSegmentIndex = 0
        case .Woman:
            segmentedControl.selectedSegmentIndex = 1
        }
    }
    
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
            return "\(pickerData[row]) kg"
        } else {
            return nil
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //row donne l'index de la ligne
        user.weight = pickerData[row]
        
        print("we changed weight=\(user.weight)")
        user.persistData()
    }
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightLabel.text = "Poids"
        
        // remplissage du tableau du Picker
        var index = 40
        while index <= 120 {
            pickerData.append(index)
            index += 5
        }
        
        // choix de la ligne selectionnée au départ, avec un test pour vérifier si la valeur se
        // trouve dans le tableau ou pas
        if let rowToSelect = pickerData.indexOf(user.weight) {
            self.pickerView.selectRow(rowToSelect, inComponent: 0, animated: true)
        } else {
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
        }
        

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDisplay()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
