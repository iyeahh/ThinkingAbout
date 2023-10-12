//
//  CategoryCell.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/06.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!

    var memoData: MemoData? {
        didSet {
            configureUIwithData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupBackView()
        setupDateLabel()
        setupCategoryView()
        setupCategoryLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupBackView() {
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 10
        backView.backgroundColor = #colorLiteral(red: 0.97647053, green: 0.97647053, blue: 0.97647053, alpha: 1)
    }

    func setupCategoryView() {
        categoryView.clipsToBounds = true
        categoryView.layer.cornerRadius = 10
    }

    func setupDateLabel() {
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        dateLabel.textAlignment = .center
        dateLabel.textColor = #colorLiteral(red: 0.2988972366, green: 0.4551405311, blue: 0.8419892788, alpha: 1)
    }

    func setupCategoryLabel() {
        categoryLabel.textColor = .white
        categoryLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }

    func configureUIwithData() {
        dateLabel.text = memoData?.dateString
        categoryView.backgroundColor = memoData?.category?.color
        categoryLabel.text = memoData?.category?.type
        memoLabel.text = memoData?.memoText
    }
}
