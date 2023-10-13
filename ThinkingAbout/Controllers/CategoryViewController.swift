//
//  CategoryViewController.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/06.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let memoDataManager = MemoDataManager.shared

    var memoData: MemoData?

    var navibarTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        title = navibarTitle
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2988972366, green: 0.4551405311, blue: 0.8419892788, alpha: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = #colorLiteral(red: 0.97647053, green: 0.97647053, blue: 0.97647053, alpha: 1)
        tableView.rowHeight = 100
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if navibarTitle == "모아보기" {
            return memoDataManager.memoList.count
        } else {
            let currentCategory = memoDataManager.memoList.filter { data in
                data.category?.type == navibarTitle
            }
            return currentCategory.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell {

            cell.selectionStyle = .none

            if navibarTitle == "모아보기" {
                cell.memoData = memoDataManager.memoList[indexPath.row]
            } else {
                let currentCategoryArray = memoDataManager.memoList.filter { data in
                    data.category?.type == navibarTitle
                }
                cell.memoData = currentCategoryArray[indexPath.row]
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension CategoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newMemoVC = storyboard?.instantiateViewController(withIdentifier: "toNewMemoVC") as? NewMemoViewController {
            newMemoVC.categoryPickerValue = navibarTitle
            newMemoVC.memoData = memoDataManager.memoList[indexPath.row]
            self.navigationController?.pushViewController(newMemoVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if navibarTitle == "모아보기" {
                let deleteCell = memoDataManager.memoList[indexPath.row]
                memoDataManager.deleteMemo(data: deleteCell, at: indexPath.row)
            } else {
                let currentCategoryArray = memoDataManager.memoList.filter { data in
                    data.category?.type == navibarTitle
                }
                memoDataManager.deleteMemo(data: currentCategoryArray[indexPath.row], at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}
