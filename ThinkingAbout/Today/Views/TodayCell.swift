//
//  TodayCell.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/09.
//

import UIKit

class TodayCell: UITableViewCell {

    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!

    var viewModel: MemoViewModel! {
        didSet {
            setupUIwithData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCategoryLabel()
        setupCategoryView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupCategoryView() {
        categoryView.clipsToBounds = true
        categoryView.layer.cornerRadius = 10
    }

    func setupCategoryLabel() {
        categoryLabel.textColor = .white
        categoryLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }

    func setupUIwithData() {
        categoryView.backgroundColor = viewModel.categoryColor
        categoryLabel.text = viewModel.categoryType
        memoLabel.text = viewModel.memoText
    }
}
