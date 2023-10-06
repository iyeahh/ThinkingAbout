//
//  Category.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/06.
//

import UIKit

public class Category: NSObject {
    var type: String?
    var color: UIColor?
    var image: UIImage?

    init(type: String?, color: UIColor?, image: UIImage?) {
        self.type = type
        self.color = color
        self.image = image
    }
}
