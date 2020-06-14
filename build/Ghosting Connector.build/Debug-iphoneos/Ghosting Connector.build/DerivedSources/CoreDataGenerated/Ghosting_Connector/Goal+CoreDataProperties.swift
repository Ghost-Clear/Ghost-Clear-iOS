//
//  Goal+CoreDataProperties.swift
//  
//
//  Created by Varun Chitturi on 6/14/20.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var ghosts: Int64
    @NSManaged public var isCompleted: Bool
    @NSManaged public var minutes: Int64
    @NSManaged public var order: Int64
    @NSManaged public var seconds: Int64

}
