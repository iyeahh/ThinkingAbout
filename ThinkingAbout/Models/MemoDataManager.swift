//
//  MemoDataManager.swift
//  ThinkingAbout
//
//  Created by Bora Yang on 2023/10/06.
//

import CoreData
import UIKit

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

    func createMemo(text: String?, date: Date, category: Category) {
        let newMemoData = MemoData(context: mainContext)

        newMemoData.memoText = text
        newMemoData.date = date
        newMemoData.category = category

        memoList.insert(newMemoData, at: 0)
        saveContext()
    }

    func deleteMemo(data: MemoData?, at index: Int) {
        guard let deletingMemo = data else {
            print("삭제 실패")
            return
        }

        memoList.remove(at: index)
        mainContext.delete(deletingMemo)
        saveContext()
    }

    func updateMemo(data: MemoData?, at index: Int) {
        guard let updatingMemo = data else {
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
