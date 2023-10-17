//
//  TodayViewController.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/09.
//

import UIKit

class TodayViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let memoDataManager = MemoDataManager.shared

    var memoData: MemoData?

    var category: String = "업무"

    var todayDateString: String? {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let dateString = dateFormatter.string(from: today)
        return dateString
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNaviBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func setupNaviBar() {
        navigationItem.title = "Today's thinking"
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = #colorLiteral(red: 0.97647053, green: 0.97647053, blue: 0.97647053, alpha: 1)
        tableView.rowHeight = 100
    }
}

extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let todayDataArray = memoDataManager.memoList.filter { data in
            data.dateString == todayDateString
        }

        return todayDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCell", for: indexPath) as? TodayCell {

            let todayDataArray = memoDataManager.memoList.filter { data in
                data.dateString == todayDateString
            }

            cell.memoData = todayDataArray[indexPath.row]

            if let categoryType = cell.memoData?.category?.type {
                category = categoryType
            }
            cell.selectionStyle = .none

            return cell
        }
        return UITableViewCell()
    }
}

extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newMemoVC = storyboard?.instantiateViewController(withIdentifier: "toNewMemoVC") as? NewMemoViewController {
            newMemoVC.categoryPickerValue = category
            newMemoVC.memoData = memoDataManager.memoList[indexPath.row]
            self.navigationController?.pushViewController(newMemoVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todayDataArray = memoDataManager.memoList.filter { data in
                data.dateString == todayDateString
            }
            memoDataManager.deleteMemo(todayDataArray[indexPath.row], at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}
