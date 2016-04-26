//
//  PageTwoViewController.swift
//  testPager
//
//  Created by etudiant-02 on 13/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

class PageTwoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hello page")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Salut")
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
