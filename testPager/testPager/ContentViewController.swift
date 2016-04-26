//
//  ContentViewController.swift
//  testPager
//
//  Created by etudiant-02 on 13/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet var titleLabel : UILabel!
    
    var pageIndex : Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = pageIndex == 0 ? UIColor.redColor() : UIColor.blueColor()
        
        titleLabel.text = "Hello : \(pageIndex)"
        
        print("Hello world!")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print(pageIndex)
        print("animated : \(pageIndex)")
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
