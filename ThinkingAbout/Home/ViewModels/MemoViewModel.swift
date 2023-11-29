//
//  MemoViewModel.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 11/29/23.
//

import Foundation
import UIKit

class MemoViewModel {
    private let memoDataManager = MemoDataManager.shared

    var memoData: MemoData?
    var index: Int?

    init(memoData: MemoData? = nil, index: Int? = nil) {
        self.memoData = memoData
        self.index = index
    }

    var dateString: String? {
        return memoData?.dateString
    }

    var categoryColor: UIColor? {
        return memoData?.category?.color
    }

    var categoryType: String? {
        return memoData?.category?.type
    }

    var memoText: String? {
        return memoData?.memoText
    }

    func update(memo: MemoData, index: Int, vc: UIViewController) {
        memoDataManager.updateMemo(memoData, at: index)
        vc.navigationController?.popViewController(animated: true)
    }

    func createMemo(text: String?, date: Date, category: Category, vc: UIViewController) {
        memoDataManager.createMemo(text: text, date: date, category: category)
        vc.navigationController?.popViewController(animated: true)
    }
}
