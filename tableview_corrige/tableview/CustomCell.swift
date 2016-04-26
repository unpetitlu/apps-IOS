//
//  CustomCell.swift
//  tableview
//
//  Created by nicolas on 06/04/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//

import UIKit

// Définition de la CustomCell utilisée dans la tableview
class CustomCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var myImageView : UIImageView!
    @IBOutlet var genreLabel : UILabel!
    
    @IBOutlet var imageHeightConstraint : NSLayoutConstraint!
    @IBOutlet var imageWidthConstraint : NSLayoutConstraint!
}
