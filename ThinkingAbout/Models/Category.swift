//
//  Category.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/06.
//

import UIKit

public class Category: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true

    public func encode(with coder: NSCoder) { }

    public required init?(coder: NSCoder) { }

    var type: String?
    var color: UIColor?
    var image: UIImage?

    init(type: String?, color: UIColor?, image: UIImage?) {
        self.type = type
        self.color = color
        self.image = image
    }
}
