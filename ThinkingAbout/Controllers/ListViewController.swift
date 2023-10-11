//
//  ListViewController.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/03.
//

import UIKit

final class ListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!

    let memoDataManager = MemoDataManager.shared

    let flowLayout = UICollectionViewFlowLayout()

    var categoryArray: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollecionView()
        setupCategoryArray()
        setupAddButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    func setupAddButton() {
        addButton.backgroundColor = #colorLiteral(red: 0.3382760584, green: 0.5265126824, blue: 1, alpha: 1)
        addButton.setTitle("", for: .normal)
        addButton.tintColor = #colorLiteral(red: 0.97647053, green: 0.97647053, blue: 0.97647053, alpha: 1)
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = addButton.frame.width / 2
    }

    func setupCollecionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = #colorLiteral(red: 0.97647053, green: 0.97647053, blue: 0.97647053, alpha: 1)

        let inset: CGFloat = 20.0 // 원하는 안쪽 여백 크기
        collectionView.contentInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)

        let spacingWidth: CGFloat = 20
        let cellColumns: CGFloat = 2

        flowLayout.scrollDirection = .vertical

        let collectionCellWidth = ((UIScreen.main.bounds.width - 40) - spacingWidth * (cellColumns - 1)) / cellColumns

        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        flowLayout.minimumInteritemSpacing = spacingWidth
        flowLayout.minimumLineSpacing = spacingWidth

        collectionView.collectionViewLayout = flowLayout
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        if let newMemoVC = storyboard?.instantiateViewController(withIdentifier: "toNewMemoVC") as? NewMemoViewController {
            self.navigationController?.pushViewController(newMemoVC, animated: true)
        }
    }

    func setupCategoryArray() {
        categoryArray = [
            Category(type: "모아보기", color: #colorLiteral(red: 0.5236185193, green: 0.656108439, blue: 1, alpha: 1), image: UIImage(systemName: "list.clipboard")),
            Category(type: "업무", color: #colorLiteral(red: 0.9921761155, green: 0.7328807712, blue: 0.4789910913, alpha: 1), image: UIImage(systemName: "text.book.closed")),
            Category(type: "음악", color: #colorLiteral(red: 0.9771121144, green: 0.6577736735, blue: 0.6004146934, alpha: 1), image: UIImage(systemName: "beats.headphones")),
            Category(type: "여행", color: #colorLiteral(red: 0.440038383, green: 0.8220494986, blue: 0.5577589869, alpha: 1), image: UIImage(systemName: "airplane")),
            Category(type: "공부", color: #colorLiteral(red: 0.5635170937, green: 0.5420733094, blue: 0.8248844147, alpha: 1), image: UIImage(systemName: "pencil")),
            Category(type: "일상", color: #colorLiteral(red: 0.8769599795, green: 0.5063646436, blue: 0.4531673789, alpha: 1), image: UIImage(systemName: "house")),
            Category(type: "취미", color: #colorLiteral(red: 0.7281604409, green: 0.5113939643, blue: 0.8102740645, alpha: 1), image: UIImage(systemName: "paintpalette")),
            Category(type: "쇼핑", color: #colorLiteral(red: 0.2690466344, green: 0.7030950189, blue: 0.7497351766, alpha: 1), image: UIImage(systemName: "cart")),
        ]
        collectionView.reloadData()
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListCell {
            let category = categoryArray[indexPath.row]
            cell.categoryImageView.image = category.image
            cell.categoryImageView.tintColor = category.color
            cell.categoryLabel.text = category.type

            if cell.categoryLabel.text == "모아보기" {
                cell.numberOfTaskLabel.text = "\(memoDataManager.getMemoListFromCoreData().count)개의 생각"
            } else {
                let currentCategory = memoDataManager.getMemoListFromCoreData().filter { data in
                    data.category?.type == cell.categoryLabel.text
                }
                cell.numberOfTaskLabel.text = "\(currentCategory.count)개의 생각"
            }
            
            return cell
        }

        return UICollectionViewCell()
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let categoryVC = storyboard?.instantiateViewController(withIdentifier: "toCategoryVC") as? CategoryViewController {
            categoryVC.navibarTitle = categoryArray[indexPath.row].type ?? ""
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
}

