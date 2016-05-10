//
//  CoreDataReview+CoreDataProperties.swift
//  troiswaresto
//
//  Created by etudiant-02 on 10/05/2016.
//  Copyright © 2016 ludo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CoreDataReview {

    @NSManaged var rate: NSNumber?
    @NSManaged var comment: String?
    @NSManaged var dateOfReview: NSDate?
    @NSManaged var user: CoreDataUser?

}
