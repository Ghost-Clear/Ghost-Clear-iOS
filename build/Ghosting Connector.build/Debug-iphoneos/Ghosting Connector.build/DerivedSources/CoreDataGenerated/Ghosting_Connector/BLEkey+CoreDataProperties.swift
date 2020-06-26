//
//  BLEkey+CoreDataProperties.swift
//  
//
//  Created by Varun Chitturi on 6/26/20.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension BLEkey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BLEkey> {
        return NSFetchRequest<BLEkey>(entityName: "BLEkey")
    }

    @NSManaged public var key: String?
    @NSManaged public var name: String?

}
