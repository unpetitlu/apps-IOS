//
//  InfosViewController.swift
//  tipcalculator
//
//  Created by nicolas on 27/01/2016.
//  Copyright © 2016 Nicolas. All rights reserved.
//

import UIKit

class InfosViewController: UIViewController {

    @IBOutlet var messageLabel : UILabel!
    @IBOutlet var backButton : UIButton!

    @IBAction func backButtonPressed() {
        //ferme la vue modale
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backButton.setTitle("Retour", forState: UIControlState.Normal)
        messageLabel.text = "Bravo pour avoir acheté le tip calculator"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
