//
//  MainCategoryViewModel.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 11/29/23.
//

import Foundation
import UIKit

class MainCategoryViewModel {
    private let memoDataManager = MemoDataManager.shared

    var memoList: [MemoData] {
        memoDataManager.memoList
    }

    func handleAddButtonTapped(storyboard: UIStoryboard?, fromCurrentVC: UIViewController) {
        guard let newMemoVC = storyboard?.instantiateViewController(identifier: "toNewMemoVC", creator: { coder in
            NewMemoViewController(coder: coder)
        })
        else {
            fatalError()
        }

        fromCurrentVC.navigationController?.pushViewController(newMemoVC, animated: true)
    }

    func goCategoryVC(storyboard: UIStoryboard?, fromCurrentVC: UIViewController, index: Int) {
        guard let categoryVC = storyboard?.instantiateViewController(identifier: "toCategoryVC", creator: { coder in
            CategoryViewController(coder: coder)
        })
        else {
            fatalError()
        }

        categoryVC.navibarTitle = Category.mainCategoryArray[index].type ?? ""

        fromCurrentVC.navigationController?.pushViewController(categoryVC, animated: true)
    }
}
