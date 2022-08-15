//
//  CDComment+CoreDataProperties.swift
//  MyBitApp
//
//  Created by admin on 08.08.2022.
//
//

import Foundation
import CoreData


extension CDComment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDComment> {
        return NSFetchRequest<CDComment>(entityName: "CDComment")
    }

    @NSManaged public var commentAuthor: String?
    @NSManaged public var commentText: String?
    @NSManaged public var commentDate: Date?
    @NSManaged public var commentId: Int16
    @NSManaged public var postId: Int16

}
