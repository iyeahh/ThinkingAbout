//
//  CategoryTransformer.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/10.
//

import UIKit

class CategoryTransformer: NSSecureUnarchiveFromDataTransformer {

    override class var allowedTopLevelClasses: [AnyClass] {
        return [Category.self]
    }

    static func register() {
        let className = String(describing: CategoryTransformer.self)
        let name = NSValueTransformerName(className)

        let transformer = CategoryTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
