//
//  MemoData+CoreDataProperties.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/04.
//
//

import Foundation
import CoreData

// MARK: - 메모 코어 데이터
extension MemoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoData> {
        return NSFetchRequest<MemoData>(entityName: "MemoData")
    }

    @NSManaged public var memoText: String?
    @NSManaged public var date: Date?
    @NSManaged public var category: Category?

    var dateString: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        guard let date = self.date else { return  "" }
        return dateFormatter.string(from: date)
    }
}

extension MemoData : Identifiable { }
