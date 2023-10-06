//
//  NewMemoViewController.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/04.
//

import UIKit

class NewMemoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var dateImageView: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!

    let memoDataManager = MemoDataManager.shared

    let category = ["업무", "음악", "여행", "공부", "일상", "취미", "쇼핑"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage()
        setupNaviBar()
        setupCategoryPicker()
        setupDatePicker()

        memoTextView.becomeFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }

    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9450980392, blue: 0.9137254902, alpha: 1)
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 10
    }

    func setupCategoryPicker() {
        categoryPicker.dataSource = self
        categoryPicker.delegate = self

        categoryPicker.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9450980392, blue: 0.9137254902, alpha: 1)
        categoryPicker.clipsToBounds = true
        categoryPicker.layer.cornerRadius = 10
    }

    func setupNaviBar() {
        title = "새로운 메모 작성"
        navigationItem.hidesBackButton = true
    }
    
    func setupImage() {
        dateImageView.image = UIImage(systemName: "calendar")
        categoryImageView.image = UIImage(systemName: "tray.full")
        dateImageView.tintColor = #colorLiteral(red: 0.4078431373, green: 0.5607843137, blue: 0.2588235294, alpha: 1)
        categoryImageView.tintColor = #colorLiteral(red: 0.4078431373, green: 0.5607843137, blue: 0.2588235294, alpha: 1)
    }

    @IBAction func exitButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func finishButtonTapped(_ sender: UIButton) {
        let memoText = memoTextView.text
        let date = datePicker.date
//        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//            let category = category[row]
//            }
//        }

        memoDataManager.saveMemoData(memoText: memoText, date: date, category: Category(type: "업무", color: #colorLiteral(red: 0.9921761155, green: 0.7328807712, blue: 0.4789910913, alpha: 1), image: UIImage(systemName: "text.book.closed"))) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return category.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return category[row]
    }

}
