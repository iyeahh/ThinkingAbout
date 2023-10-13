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

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ThinkingAbout")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    let modelName: String = "MemoData"

    var memoList: [MemoData] = []

    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func fetchFromCoreData() {
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        let dateOrder = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateOrder]

        do {
            guard let fetchedMemoList = try mainContext.fetch(request) as? [MemoData] else {
                print("Fetch 실패")
                return
            }
            memoList = fetchedMemoList
        } catch {
            print("가져오는 것 실패")
        }

    }

    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func createMemoData(memoText: String?, date: Date, category: Category) {
        let newMemoData = MemoData(context: mainContext)

        // MARK: - ToDoData에 실제 데이터 할당 ⭐️
        newMemoData.memoText = memoText
        newMemoData.date = date
        newMemoData.category = category

        memoList.insert(newMemoData, at: 0)
        saveContext()

    }

    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteMemo(data: MemoData?, at index: Int) {
        guard let deleteMemo = data else {
            print("삭제 실패")
            return
        }

        memoList.remove(at: index)
        mainContext.delete(deleteMemo)
        saveContext()
    }

    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateMemo(updatingMemoData: MemoData?, at index: Int) {
        guard let memodata = updatingMemoData else {
            print("업데이트 실패")
            return
        }
        
        saveContext()
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
