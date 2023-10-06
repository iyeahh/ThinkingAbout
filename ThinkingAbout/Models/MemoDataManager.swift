//
//  MemoDataManager.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/06.
//

import CoreData
import UIKit

//MARK: - Memo 관리하는 매니저 (코어데이터 관리)

final class MemoDataManager {

    static let shared = MemoDataManager()
    private init() {}

    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    lazy var context = appDelegate?.persistentContainer.viewContext

    let modelName: String = "MemoData"

    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getMemoListFromCoreData() -> [MemoData] {
        var memoList: [MemoData] = []

        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]

            do {
                if let fetchedToDoList = try context.fetch(request) as? [MemoData] {
                    memoList = fetchedToDoList
                }
            } catch {
                print("가져오는 것 실패")
            }
        }

        return memoList
    }

    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveMemoData(memoText: String?, date: Date, category: Category, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
                if let memoData = NSManagedObject(entity: entity, insertInto: context) as? MemoData {

                    // MARK: - ToDoData에 실제 데이터 할당 ⭐️
                    memoData.memoText = memoText
                    memoData.date = date
                    memoData.category = category

                    //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }

    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteMemo(data: MemoData, completion: @escaping () -> Void) {
        guard let date = data.date else {
            completion()
            return
        }

        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)

            do {
                if let fetchedMemoList = try context.fetch(request) as? [MemoData] {
                    if let targetMemo = fetchedMemoList.first {
                        context.delete(targetMemo)

                        //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }

    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateMemo(newMemoData: MemoData, completion: @escaping () -> Void) {
        guard let date = newMemoData.date else {
            completion()
            return
        }

        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)

            do {
                if let fetchedMemoList = try context.fetch(request) as? [MemoData] {
                    if var targetMemo = fetchedMemoList.first {
                        targetMemo = newMemoData

                        //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("지우는 것 실패")
                completion()
            }
        }
    }
}
