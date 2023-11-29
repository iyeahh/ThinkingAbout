//
//  CategoryViewModel.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 11/29/23.
//

import Foundation
import UIKit

class CategoryViewModel {
    private let memoDataManager = MemoDataManager.shared

    var memoData: MemoData?
    var navibarTitle = ""

    func getCategoryMemo() -> [MemoData] {
        if navibarTitle == "모아보기" {
            return memoDataManager.memoList
        } else {
            let currentCategory = memoDataManager.memoList.filter { data in
                data.category?.type == navibarTitle
            }
            return currentCategory
        }    }

    func memoViewModelAt(index: Int) -> MemoViewModel {
        let categoryMemo = getCategoryMemo()
        let memo = categoryMemo[index]
        return MemoViewModel(memoData: memo, index: index)
    }

    func goNewMemoVC(storyboard: UIStoryboard?, fromCurrentVC: UIViewController, index: Int) {
        guard let newMemoVC = storyboard?.instantiateViewController(identifier: "toNewMemoVC", creator: { coder in
            NewMemoViewController(coder: coder)
        })
        else {
            fatalError()
        }

        newMemoVC.viewModel.memoData = getCategoryMemo()[index]

        if let category = newMemoVC.viewModel.memoData?.category {
            newMemoVC.currentCategory = category
        }

        fromCurrentVC.navigationController?.pushViewController(newMemoVC, animated: true)
    }

    func deleteCell(index: Int) {
        if navibarTitle == "모아보기" {
            let deleteCell = memoDataManager.memoList[index]
            memoDataManager.deleteMemo(deleteCell, at: index)
        } else {
            memoDataManager.deleteMemo(getCategoryMemo()[index], at: index)
        }
    }
}
