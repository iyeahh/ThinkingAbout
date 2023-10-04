//
//  MemoData+CoreDataProperties.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/04.
//
//

import Foundation
import CoreData


extension MemoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoData> {
        return NSFetchRequest<MemoData>(entityName: "MemoData")
    }

    @NSManaged public var memoText: String?
    @NSManaged public var date: Date?
    @NSManaged public var category: Category?

}

extension MemoData : Identifiable {

}
