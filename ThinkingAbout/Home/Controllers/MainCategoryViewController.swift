//
//  MainCategoryViewController.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/03.
//

import UIKit

final class MainCategoryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!

    private let memoDataManager = MemoDataManager.shared

    private let flowLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    private func setupUI() {
        setupCollecionView()
        setupAddButton()
    }

    private func setupAddButton() {
        addButton.backgroundColor = .uITheme.main
        addButton.setTitle("", for: .normal)
        addButton.tintColor = .uITheme.sub
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = addButton.frame.width / 2
    }

    private func setupCollecionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .uITheme.sub

        let inset: CGFloat = 20.0
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

    @IBAction private func addButtonTapped(_ sender: UIButton) {
        if let newMemoVC = storyboard?.instantiateViewController(withIdentifier: "toNewMemoVC") as? NewMemoViewController {
            self.navigationController?.pushViewController(newMemoVC, animated: true)
        }
    }
}

extension MainCategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.mainCategoryArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? CategoryListCell {
            let category = Category.mainCategoryArray[indexPath.row]
            cell.categoryImageView.image = category.image
            cell.categoryImageView.tintColor = category.color
            cell.categoryLabel.text = category.type

            if cell.categoryLabel.text == "모아보기" {
                cell.numberOfTaskLabel.text = "\(memoDataManager.memoList.count)개의 생각"
            } else {
                let currentCategory = memoDataManager.memoList.filter { data in
                    data.category?.type == cell.categoryLabel.text
                }
                cell.numberOfTaskLabel.text = "\(currentCategory.count)개의 생각"
            }

            return cell
        }

        return UICollectionViewCell()
    }
}

extension MainCategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let categoryVC = storyboard?.instantiateViewController(withIdentifier: "toCategoryVC") as? CategoryViewController {
            categoryVC.navibarTitle = Category.mainCategoryArray[indexPath.row].type ?? ""
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
}
