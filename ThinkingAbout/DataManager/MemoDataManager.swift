//
//  MemoDataManager.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/06.
//

import CoreData
import UIKit

// MARK: - 메모 데이터 관리자
final class MemoDataManager {

    static let shared = MemoDataManager()
    private init() {
        fetchMemoList()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ThinkingAbout")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private let modelName: String = "MemoData"

    // MARK: - 메모 데이터 배열
    var memoList: [MemoData] = []

    private func fetchMemoList() {
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        let dateOrder = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateOrder].reversed()

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

    func createMemo(text: String?, date: Date, category: Category) {
        let newMemoData = MemoData(context: mainContext)

        newMemoData.memoText = text
        newMemoData.date = date
        newMemoData.category = category

        memoList.insert(newMemoData, at: 0)
        saveContext()
    }

    func deleteMemo(_ memo: MemoData?, at index: Int) {
        guard let deletingMemo = memo else {
            print("삭제 실패")
            return
        }

        memoList.remove(at: index)
        mainContext.delete(deletingMemo)
        saveContext()
    }

    func updateMemo(_ memo: MemoData?, at index: Int) {
        guard let _ = memo else {
            print("업데이트 실패")
            return
        }
        
        saveContext()
    }

    func saveContext() {
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
