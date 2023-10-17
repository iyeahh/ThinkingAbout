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

    init(type: String? = nil, color: UIColor? = nil, image: UIImage? = nil) {
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

extension Category {
    static let mainCategoryArray: [Category] = [
        Category(type: "모아보기", color: .theme.all, image: .mainIcon.all),
        Category(type: "업무", color: .theme.work, image: .mainIcon.work),
        Category(type: "음악", color: .theme.music, image: .mainIcon.music),
        Category(type: "여행", color: .theme.travel, image: .mainIcon.travel),
        Category(type: "공부", color: .theme.study, image: .mainIcon.study),
        Category(type: "일상", color: .theme.stuff, image: .mainIcon.stuff),
        Category(type: "취미", color: .theme.hobby, image: .mainIcon.hobby),
        Category(type: "쇼핑", color: .theme.shopping, image: .mainIcon.shopping),
    ]

    static let subCategoryArray: [Category] = [
        Category(type: "업무", color: .theme.work, image: .subIcon.work),
        Category(type: "음악", color: .theme.music, image: .subIcon.music),
        Category(type: "여행", color: .theme.travel, image: .subIcon.travel),
        Category(type: "공부", color: .theme.study, image: .subIcon.study),
        Category(type: "일상", color: .theme.stuff, image: .subIcon.stuff),
        Category(type: "취미", color: .theme.hobby, image: .subIcon.hobby),
        Category(type: "쇼핑", color: .theme.shopping, image: .subIcon.shopping),
    ]

    func makeAttributedString() -> NSAttributedString {
        guard
            let img = self.image,
            let typeString = self.type else { return NSAttributedString() }
        let attachment = NSTextAttachment()
        attachment.image = img
        let imageString = NSAttributedString(attachment: attachment)

        let attributedString = NSMutableAttributedString(attributedString: imageString)
        attributedString.append(NSAttributedString(string: " " + typeString))

        return attributedString
    }
}
