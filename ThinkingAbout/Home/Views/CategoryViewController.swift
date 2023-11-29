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

    let viewModel = CategoryViewModel()

    var navibarTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func setupUI() {
        setupTableView()
        setupNavi()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .uITheme.sub
        tableView.rowHeight = 100
    }

    private func setupNavi() {
        title = navibarTitle
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .uITheme.main
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.navibarTitle = navibarTitle
        return viewModel.getCategoryMemo().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryDetailCell {

            let memoVM = viewModel.memoViewModelAt(index: indexPath.row)
            cell.viewModel = memoVM

            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

extension CategoryViewController: UITableViewDelegate {

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
