//
//  Workout+CoreDataProperties.swift
//  
//
//  Created by Varun Chitturi on 6/14/20.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var day: String?
    @NSManaged public var ghosts: Int64
    @NSManaged public var minutes: Int64
    @NSManaged public var order: Int64
    @NSManaged public var seconds: Int64

}
