//
//  CDPost+CoreDataProperties.swift
//  MyBitApp
//
//  Created by admin on 08.08.2022.
//
//

import Foundation
import CoreData


extension CDPost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPost> {
        return NSFetchRequest<CDPost>(entityName: "CDPost")
    }

    @NSManaged public var author: String?
    @NSManaged public var text: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: Int16
}
