//
//  NewMemoViewController.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/04.
//

import UIKit

class NewMemoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryPicker: UIPickerView!

    let memoDataManager = MemoDataManager.shared

    var memoData: MemoData?

    var indexOfMemo: Int = 0

    var currentCategory: Category = Category(type: "업무", color: #colorLiteral(red: 0.9921761155, green: 0.7328807712, blue: 0.4789910913, alpha: 1), image: UIImage(systemName: "text.book.closed"))

    var categoryPickerValue: String = "업무"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupCategoryPicker()
        setupDatePicker()
        configureUI()
        memoTextView.delegate = self
        checkingButtonValid()
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

    @objc func keyboardWillShow(_ notification: Notification) {
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

    @objc func keyboardWillHide(_ notification: Notification) {
        buttonBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func checkingButtonValid() {
        if memoTextView.text.isEmpty || memoTextView.text == "텍스트를 여기에 입력하세요." {
            finishButton.isEnabled = false
            finishButton.backgroundColor = UIColor.lightGray
        } else {
            finishButton.isEnabled = true
            finishButton.backgroundColor = #colorLiteral(red: 0.2988972366, green: 0.4551405311, blue: 0.8419892788, alpha: 1)
        }
    }

    func configureUI() {
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

    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = #colorLiteral(red: 0.97647053, green: 0.97647053, blue: 0.97647053, alpha: 1)
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 10

        guard let value = Category.categoryArray.map({ category in
            category.type
        }).firstIndex(of: categoryPickerValue) else {
            return
        }
        categoryPicker.selectRow(value - 1, inComponent: 0, animated: false)
    }

    func setupCategoryPicker() {
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.backgroundColor = #colorLiteral(red: 0.97647053, green: 0.97647053, blue: 0.97647053, alpha: 1)
        categoryPicker.clipsToBounds = true
        categoryPicker.layer.cornerRadius = 10
    }

    func setupNaviBar() {
        navigationItem.hidesBackButton = true
    }

    @IBAction func exitButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func finishButtonTapped(_ sender: UIButton) {
        if let memoData = self.memoData {

            memoData.memoText = memoTextView.text
            memoData.date = datePicker.date
            memoData.category = currentCategory

            memoDataManager.updateMemo(data: memoData, at: indexOfMemo)
            self.navigationController?.popViewController(animated: true)

        } else {
            let memoText = memoTextView.text
            let date = datePicker.date

            memoDataManager.createMemo(text: memoText, date: date, category: currentCategory)
            self.navigationController?.popViewController(animated: true)

        }
    }

    func makeAttributedString(image: UIImage, text: String) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        let imageString = NSAttributedString(attachment: attachment)

        let attributedString = NSMutableAttributedString(attributedString: imageString)
        attributedString.append(NSAttributedString(string: " " + text))

        return attributedString
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.categoryArray.count - 1
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return [
            makeAttributedString(image: UIImage(systemName: "text.book.closed")!, text: "업무"),
            makeAttributedString(image: UIImage(systemName: "beats.headphones")!, text: "음악"),
            makeAttributedString(image: UIImage(systemName: "airplane")!, text: "여행"),
            makeAttributedString(image: UIImage(systemName: "pencil")!, text: "공부"),
            makeAttributedString(image: UIImage(systemName: "house")!, text: "일상"),
            makeAttributedString(image: UIImage(systemName: "paintpalette")!, text: "취미"),
            makeAttributedString(image: UIImage(systemName: "cart")!, text: "쇼핑")
        ][row]
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            currentCategory = Category.categoryArray[1]
        case 1:
            currentCategory = Category.categoryArray[2]
        case 2:
            currentCategory = Category.categoryArray[3]
        case 3:
            currentCategory = Category.categoryArray[4]
        case 4:
            currentCategory = Category.categoryArray[5]
        case 5:
            currentCategory = Category.categoryArray[6]
        case 6:
            currentCategory = Category.categoryArray[7]
        default:
            currentCategory = Category.categoryArray[1]
        }
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
