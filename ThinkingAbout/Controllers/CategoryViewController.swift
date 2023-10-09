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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9450980392, blue: 0.9137254902, alpha: 1)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentCategory = memoDataManager.getMemoListFromCoreData().filter { data in
            data.category?.type == navibarTitle
        }
        return currentCategory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell {

            cell.selectionStyle = .none
            let currentCategory = memoDataManager.getMemoListFromCoreData().filter { data in
                data.category?.type == navibarTitle
            }
            cell.memoData = currentCategory[indexPath.row]

            return cell
        }
        return UITableViewCell()
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newMemoVC = storyboard?.instantiateViewController(withIdentifier: "toNewMemoVC") as? NewMemoViewController {
            newMemoVC.memoData = memoDataManager.getMemoListFromCoreData()[indexPath.row]
//            newMemoVC.categoryPickerValue = indexPath.last
            self.navigationController?.pushViewController(newMemoVC, animated: true)
        }
    }
}
