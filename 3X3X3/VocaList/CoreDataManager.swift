//
//  CoreDataManager.swift
//  3X3X3
//
//  Created by 최유리 on 2/11/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static var shared: CoreDataManager = .init()
    
    let container = {
        let container = NSPersistentContainer(name: "_X3X3")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    private init() {}
    
    func readVocaCategory() -> [NSManagedObject] {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "VocabularyList")
        let result = try? context.fetch(fetchRequest)
        
        return result ?? []
    }
    
    func createVocaCategory(name: String) {
        let context = container.viewContext
        let object = NSEntityDescription.insertNewObject(forEntityName: "VocabularyList", into: context)
        object.setValue(name, forKey: "name")
        object.setValue(false, forKey: "isCompleted")
        
        try? context.save()
    }
    
    func readVoca() -> [NSManagedObject] {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Word")
        let result = try? context.fetch(fetchRequest)
        
        return result ?? []
    }
    
    func createVoca(word: String, meaning: String) {
        let context = container.viewContext
        let object = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context)
        object.setValue(word, forKey: "word")
        object.setValue(meaning, forKey: "meaning")
        object.setValue(false, forKey: "isCorrect")
        
        try? context.save()
    }
    
    func deleteVoca(_ voca: NSManagedObject) {
        let context = container.viewContext
        
        context.delete(voca)
        
        do {
            try context.save()
        } catch {
            fatalError("Failed to save context after deletion: \(error)")
        }
    }
}
