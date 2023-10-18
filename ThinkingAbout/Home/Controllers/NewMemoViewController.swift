//
//  NewMemoViewController.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/04.
//

import UIKit

class NewMemoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - 버튼의 위치를 동적으로 변경하기 위한 제약 연결
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!

    private let memoDataManager = MemoDataManager.shared

    var memoData: MemoData?

    var indexOfMemo: Int = 0

    private var currentCategory: Category = Category(type: "업무", color: .categoryTheme.work, image: UIImage(systemName: "text.book.closed"))

    var categoryPickerValue: String = "업무"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        memoTextView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let tabBar = self.tabBarController?.tabBar else {
            return
        }
        let tabBarHeight = tabBar.frame.size.height

        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardHeight = keyboardFrame.size.height

        buttonBottomConstraint.constant = keyboardHeight - tabBarHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        buttonBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func setupUI() {
        setupNaviBar()
        setupCategoryPicker()
        setupDatePicker()
        configureUI()
        checkingButtonValid()
    }

    private func setupNaviBar() {
        navigationItem.hidesBackButton = true
    }

    private func setupCategoryPicker() {
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.backgroundColor = .uITheme.sub

        categoryPicker.clipsToBounds = true
        categoryPicker.layer.cornerRadius = 10
    }

    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .uITheme.sub
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 10

        guard let value = Category.mainCategoryArray.map({ category in
            category.type
        }).firstIndex(of: categoryPickerValue) else {
            return
        }
        categoryPicker.selectRow(value - 1, inComponent: 0, animated: false)
    }

    private func configureUI() {
        if let memoData = self.memoData {
            print(memoData)
            self.title = "메모 수정"

            guard let text = memoData.memoText, let date = memoData.date else { return }
            memoTextView.text = text
            datePicker.date = date

            finishButton.setTitle("수정 완료", for: .normal)
        } else {
            self.title = "새로운 메모 작성"
            memoTextView.text = "텍스트를 여기에 입력하세요."
            memoTextView.textColor = .lightGray
        }
    }

    private func checkingButtonValid() {
        if memoTextView.text.isEmpty || memoTextView.text == "텍스트를 여기에 입력하세요." {
            finishButton.isEnabled = false
            finishButton.backgroundColor = UIColor.lightGray
        } else {
            finishButton.isEnabled = true
            finishButton.backgroundColor = .uITheme.main
        }
    }

    @IBAction func exitButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func finishButtonTapped(_ sender: UIButton) {
        if let memoData = self.memoData {

            memoData.memoText = memoTextView.text
            memoData.date = datePicker.date
            memoData.category = currentCategory

            memoDataManager.updateMemo(memoData, at: indexOfMemo)
            self.navigationController?.popViewController(animated: true)

        } else {
            let memoText = memoTextView.text
            let date = datePicker.date

            memoDataManager.createMemo(text: memoText, date: date, category: currentCategory)
            self.navigationController?.popViewController(animated: true)

        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.subCategoryArray.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        return Category.subCategoryArray.map {$0.makeAttributedString()}[row]
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCategory = Category.subCategoryArray[row]
    }
}

extension NewMemoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        checkingButtonValid()
        if textView.text == "텍스트를 여기에 입력하세요." {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        checkingButtonValid()
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "텍스트를 여기에 입력하세요."
            textView.textColor = .lightGray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        checkingButtonValid()
    }
}
