//
//  Name+CoreDataProperties.swift
//  
//
//  Created by Varun Chitturi on 6/26/20.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Name {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Name> {
        return NSFetchRequest<Name>(entityName: "Name")
    }

    @NSManaged public var name: String?

}
