//
//  CoreDataUser+CoreDataProperties.swift
//  troiswresto
//
//  Created by nicolas on 10/05/2016.
//  Copyright © 2016 nicolas. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CoreDataUser {

    @NSManaged var nickname: String?
    @NSManaged var password: String?
    @NSManaged var email: String?
    @NSManaged var uid: String?
    @NSManaged var extrastring1: String?
    @NSManaged var extradouble1: NSNumber?
    @NSManaged var review: NSSet?

}
