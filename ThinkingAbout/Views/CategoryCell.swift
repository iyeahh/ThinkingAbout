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
        setupCategoryLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupBackView() {
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 0
        backView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9450980392, blue: 0.9137254902, alpha: 1)
    }

    func setupDateLabel() {
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        dateLabel.textAlignment = .center
        dateLabel.textColor = #colorLiteral(red: 0.4078431373, green: 0.5607843137, blue: 0.2588235294, alpha: 1)
    }

    func setupCategoryLabel() {
        categoryLabel.textColor = .lightGray
    }

    func configureUIwithData() {
        dateLabel.text = memoData?.dateString
        categoryLabel.text = memoData?.category?.type
        memoLabel.text = memoData?.memoText
    }
}
