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
    
    var pickerData = [Int]()
    var game : Game!
    var mainViewController : MainViewController!
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
        let chosen = pickerData[pickerView.selectedRowInComponent(0)]
        
        if chosen != game.nbColumns {
           mainViewController.startGame(chosen)
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
            return "\(pickerData[row]) x \(pickerData[row])"
        } else {
            return nil
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //row donne l'index de la ligne
        let chosen = pickerData[row]
        print("chosen = \(chosen) columns")
    }

    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //création du tableau du valeur utilisé dans le UIPickerView
        for index in 2...10 {
            pickerData.append(index)
        }
        
        if let myIndex = pickerData.indexOf(game.nbColumns)  {
            pickerView.selectRow(myIndex, inComponent: 0, animated: true)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
