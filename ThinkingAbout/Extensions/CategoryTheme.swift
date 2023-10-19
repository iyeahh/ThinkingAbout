//
//  ColorTheme.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 10/17/23.
//

import UIKit

// MARK: - 컬러 테마
extension UIColor {
    static let categoryTheme = CategoryTheme()
    static let uITheme = UIColorTheme()
    static let darkmode = UIColor(named: "darkmodeColorAsset")!
}

struct CategoryTheme {
    let all: UIColor = #colorLiteral(red: 0.2988972366, green: 0.4551405311, blue: 0.8419892788, alpha: 1)
    let work: UIColor = #colorLiteral(red: 0.9921761155, green: 0.7328807712, blue: 0.4789910913, alpha: 1)
    let music: UIColor = #colorLiteral(red: 0.9771121144, green: 0.6577736735, blue: 0.6004146934, alpha: 1)
    let travel: UIColor = #colorLiteral(red: 0.440038383, green: 0.8220494986, blue: 0.5577589869, alpha: 1)
    let study: UIColor = #colorLiteral(red: 0.5635170937, green: 0.5420733094, blue: 0.8248844147, alpha: 1)
    let stuff: UIColor = #colorLiteral(red: 0.8769599795, green: 0.5063646436, blue: 0.4531673789, alpha: 1)
    let hobby: UIColor = #colorLiteral(red: 0.7281604409, green: 0.5113939643, blue: 0.8102740645, alpha: 1)
    let shopping: UIColor = #colorLiteral(red: 0.2690466344, green: 0.7030950189, blue: 0.7497351766, alpha: 1)
}

struct UIColorTheme {
    let main: UIColor = #colorLiteral(red: 0.3382760584, green: 0.5265126824, blue: 1, alpha: 1)
    let sub: UIColor = .darkmode
}
