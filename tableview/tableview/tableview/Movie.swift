//
//  Movie.swift
//  tableview
//
//  Created by etudiant-02 on 07/04/2016.
//  Copyright © 2016 ludo. All rights reserved.
//

import Foundation
import UIKit

class Movie
{
    var title : String
    var genre : String
    var description : String
    var image : UIImage
    
    init (title : String, genre : String, description : String, image : UIImage)
    {
        self.title = title
        self.genre = genre
        self.description = description
        self.image = image
    }
}