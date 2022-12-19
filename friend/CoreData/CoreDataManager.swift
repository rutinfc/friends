//
//  CoreDataManager.swift
//  Friend
//
//  Created by JK Kim on 2022/12/15.
//

import Foundation
import CoreData
import Combine

class CoreDataManager {
    
    static var shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    init() {
        self.mainContext.automaticallyMergesChangesFromParent = true
    }
    
    var mainContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func insert(id: String, date:Date = Date()) {
        
        self.persistentContainer.performBackgroundTask { context in
            
            guard let entity = ItemMO.newEntityDescription(context: context) else {
                return
            }
            
            if let managedObject = NSManagedObject(entity: entity, insertInto: context) as? ItemMO {
                managedObject.id = id
                managedObject.date = date
            }
                
            do {
                try context.save()
            } catch {
                print("Insert Error : \(error)")
            }
        }
    }
    
    func delete(id: String) {
        
        self.persistentContainer.performBackgroundTask { context in
            
            let fetchRequest = ItemMO.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                if let firstObject = try context.fetch(fetchRequest).first {
                    context.delete(firstObject)
                    try context.save()
                }
            } catch {
                print("Delete Error : \(error)")
            }
        }
    }
    
    func search(text: String) -> [ItemMO]? {
        
        let predicate = NSPredicate(format: "id contains[cd] %@", text)
        let fetchRequest = ItemMO.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = self.sortDescriptor()
        
        return try? self.mainContext.fetch(fetchRequest)
    }
    
    func listPublisher(filteredId: String) -> AnyPublisher<[ItemMO], NSError> {
        
        let fetchRequest = ItemMO.fetchRequest()
        
        if filteredId.isEmpty == false {
            fetchRequest.predicate = NSPredicate(format: "id contains[cd] %@", filteredId)
        }
        
        fetchRequest.sortDescriptors = self.sortDescriptor()
        
        return CoreDataPublisher<ItemMO, NSError>(request: fetchRequest,
                                                  context: self.mainContext).eraseToAnyPublisher()
    }
    
    func sortDescriptor() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}
