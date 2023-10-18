//
//  CategoryDetailCell.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/06.
//

import UIKit

class CategoryDetailCell: UITableViewCell {

    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!

    var memoData: MemoData? {
        didSet {
            setupUIwithData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupUI() {
        setupBackView()
        setupDateLabel()
        setupCategoryView()
        setupCategoryLabel()
    }

    private func setupBackView() {
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 10
        backView.backgroundColor = .uITheme.sub
    }

    private func setupDateLabel() {
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        dateLabel.textAlignment = .center
        dateLabel.textColor = .uITheme.main
    }

    private func setupCategoryView() {
        categoryView.clipsToBounds = true
        categoryView.layer.cornerRadius = 10
    }

    private func setupCategoryLabel() {
        categoryLabel.textColor = .white
        categoryLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }

    private func setupUIwithData() {
        dateLabel.text = memoData?.dateString
        categoryView.backgroundColor = memoData?.category?.color
        categoryLabel.text = memoData?.category?.type
        memoLabel.text = memoData?.memoText
    }
}
