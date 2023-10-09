//
//  TodayCell.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/09.
//

import UIKit

class TodayCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!

    var memoData: MemoData? {
        didSet {
            configureUIwithData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCategoryLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupCategoryLabel() {
        categoryLabel.textColor = .lightGray
    }

    func configureUIwithData() {
        categoryLabel.text = memoData?.category?.type
        memoLabel.text = memoData?.memoText
    }
}
