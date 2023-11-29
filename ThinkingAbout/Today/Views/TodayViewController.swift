//
//  TodayViewController.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/09.
//

import UIKit

class TodayViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let viewModel = TodayViewModel()

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
        tableView.backgroundColor = .uITheme.sub
        tableView.rowHeight = 100
    }
}

extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        viewModel.todayDateString = todayDateString
        return viewModel.getTodayMemo().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCell", for: indexPath) as? TodayCell {

            let memoVM = viewModel.memoViewModelAt(index: indexPath.row)
            cell.viewModel = memoVM

            if let categoryType = cell.viewModel.memoData?.category?.type {
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
        viewModel.goNewMemoVC(storyboard: self.storyboard, fromCurrentVC: self, index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteCell(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}
