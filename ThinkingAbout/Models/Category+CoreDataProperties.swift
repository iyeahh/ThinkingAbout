//
//  Category+CoreDataProperties.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/04.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var type: String?
    @NSManaged public var color: Int64
    @NSManaged public var image: String?

}

extension Category : Identifiable {

}
