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

    static var categoryArray: [Category] {
        return [Category(type: "모아보기", color: #colorLiteral(red: 0.5236185193, green: 0.656108439, blue: 1, alpha: 1), image: UIImage(systemName: "list.clipboard")),
                Category(type: "업무", color: #colorLiteral(red: 0.9921761155, green: 0.7328807712, blue: 0.4789910913, alpha: 1), image: UIImage(systemName: "text.book.closed")),
                Category(type: "음악", color: #colorLiteral(red: 0.9771121144, green: 0.6577736735, blue: 0.6004146934, alpha: 1), image: UIImage(systemName: "beats.headphones")),
                Category(type: "여행", color: #colorLiteral(red: 0.440038383, green: 0.8220494986, blue: 0.5577589869, alpha: 1), image: UIImage(named: "airplane")),
                Category(type: "공부", color: #colorLiteral(red: 0.5635170937, green: 0.5420733094, blue: 0.8248844147, alpha: 1), image: UIImage(named: "edit")),
                Category(type: "일상", color: #colorLiteral(red: 0.8769599795, green: 0.5063646436, blue: 0.4531673789, alpha: 1), image: UIImage(systemName: "house")),
                Category(type: "취미", color: #colorLiteral(red: 0.7281604409, green: 0.5113939643, blue: 0.8102740645, alpha: 1), image: UIImage(systemName: "paintpalette")),
                Category(type: "쇼핑", color: #colorLiteral(red: 0.2690466344, green: 0.7030950189, blue: 0.7497351766, alpha: 1), image: UIImage(systemName: "cart")),
        ]
    }
}
