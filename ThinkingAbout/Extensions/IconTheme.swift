//
//  IconTheme.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 10/17/23.
//

import UIKit

extension UIImage {
    static let mainIcon = MainIconTheme()
    static let subIcon = SubIconTheme()
}

struct MainIconTheme {
    let all: UIImage = UIImage(systemName: "list.clipboard")!
    let work: UIImage = UIImage(systemName: "text.book.closed")!
    let music: UIImage = UIImage(systemName: "beats.headphones")!
    let travel: UIImage = UIImage(named: "airplane")!
    let study: UIImage = UIImage(named: "edit")!
    let stuff: UIImage = UIImage(systemName: "house")!
    let hobby: UIImage = UIImage(systemName: "paintpalette")!
    let shopping: UIImage = UIImage(systemName: "cart")!
}

struct SubIconTheme {
    let work: UIImage = UIImage(systemName: "text.book.closed")!
    let music: UIImage = UIImage(systemName: "beats.headphones")!
    let travel: UIImage = UIImage(systemName: "airplane")!
    let study: UIImage = UIImage(systemName: "pencil")!
    let stuff: UIImage = UIImage(systemName: "house")!
    let hobby: UIImage = UIImage(systemName: "paintpalette")!
    let shopping: UIImage = UIImage(systemName: "cart")!
}
