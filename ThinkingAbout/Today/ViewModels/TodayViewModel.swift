//
//  TodayViewModel.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 11/29/23.
//

import Foundation
import UIKit

class TodayViewModel {
    let memoDataManager = MemoDataManager.shared

    var memoData: MemoData?

    var todayDateString: String?

    func getTodayMemo() -> [MemoData] {
        let todayDataArray = memoDataManager.memoList.filter { data in
            data.dateString == todayDateString
        }
        return todayDataArray
    }

    func goNewMemoVC(storyboard: UIStoryboard?, fromCurrentVC: UIViewController, index: Int) {
        guard let newMemoVC = storyboard?.instantiateViewController(identifier: "toNewMemoVC", creator: { coder in
            NewMemoViewController(coder: coder)
        })
        else {
            fatalError()
        }

        newMemoVC.viewModel.memoData = getTodayMemo()[index]

        if let category = newMemoVC.viewModel.memoData?.category {
            newMemoVC.currentCategory = category
        }

        fromCurrentVC.navigationController?.pushViewController(newMemoVC, animated: true)
    }

    func memoViewModelAt(index: Int) -> MemoViewModel {
        let todayMemo = getTodayMemo()
        let memo = todayMemo[index]
        return MemoViewModel(memoData: memo, index: index)
    }

    func deleteCell(index: Int) {
        memoDataManager.deleteMemo(getTodayMemo()[index], at: index)
    }
}
