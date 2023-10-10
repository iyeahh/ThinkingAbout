//
//  Category.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/06.
//

import UIKit

public class Category: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true

    var type: String?
    var color: UIColor?
    var image: UIImage?

    init(type: String?, color: UIColor?, image: UIImage?) {
        self.type = type
        self.color = color
        self.image = image
    }

    public func encode(with coder: NSCoder) {

        guard let type = type, let color = color, let image = image else { return }
        coder.encode(type as NSString, forKey: "type")
        coder.encode(color as UIColor, forKey: "color")
        coder.encode(image as UIImage, forKey: "image")
    }

    required public convenience init?(coder: NSCoder) {
        let type = coder.decodeObject(of: NSString.self, forKey: "type") as? String
        let color = coder.decodeObject(of: UIColor.self, forKey: "color")
        let image = coder.decodeObject(of: UIImage.self, forKey: "image")

        self.init(type: type, color: color, image: image)
    }

}
