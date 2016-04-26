//
//  DetailViewController.swift
//  tableview
//
//  Created by nicolas on 07/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var myTitleLabel : UILabel!
    @IBOutlet var pictureImageView : UIImageView!
    @IBOutlet var descriptionTextView : UITextView!
    var movie : Movie!

    func updateDisplay() {
        descriptionTextView.text = movie.description
        myTitleLabel.text = movie.title
        pictureImageView.image = movie.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDisplay()
    }
    
    // ruse pour scroller au début de la textview si elle est longue
    override func viewDidLayoutSubviews() {
        descriptionTextView.setContentOffset(CGPointZero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("leaving view")
    }
}
