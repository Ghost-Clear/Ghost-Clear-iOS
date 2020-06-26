//
//  IsFirstLaunch+CoreDataProperties.swift
//  
//
//  Created by Varun Chitturi on 6/26/20.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension IsFirstLaunch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IsFirstLaunch> {
        return NSFetchRequest<IsFirstLaunch>(entityName: "IsFirstLaunch")
    }

    @NSManaged public var bool: Bool

}
