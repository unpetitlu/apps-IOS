//
//  ReviewCell.swift
//  troiswresto
//
//  Created by nicolas on 25/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    @IBOutlet  var nicknameLabel: UILabel!
    @IBOutlet  var ratingLabel : UILabel!
    @IBOutlet var descriptionLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!

}

class AddReviewCell: UITableViewCell {
    @IBOutlet  var titleLabel: UILabel!
}