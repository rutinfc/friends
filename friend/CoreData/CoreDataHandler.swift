//
//  CoreDataHandler.swift
//  Friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/27.
//

import Foundation
import CoreData
import Combine

protocol EntityProtocol: NSManagedObject {
    associatedtype Entity: NSManagedObject
    static func fetchRequest() -> NSFetchRequest<Entity>
    static func newEntityDescription(context: NSManagedObjectContext) -> NSEntityDescription?
}

class CoreDataHandler<InOutEntity> where InOutEntity: EntityProtocol {
    
    lazy var persistentContainer: NSPersistentContainer = {
        return CoreDataManager.shared.persistentContainer
    }()
    
    var mainContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func insert(item:@escaping(InOutEntity) -> Bool) {
        
        self.persistentContainer.performBackgroundTask { context in
            
            guard let entity = InOutEntity.newEntityDescription(context: context) else {
                return
            }
            
            guard let managedObject = NSManagedObject(entity: entity, insertInto: context) as? InOutEntity else {
                return
            }
            
            if item(managedObject) == false {
                return
            }
            
            do {
                try context.save()
            } catch {
                print("Insert Error : \(error)")
            }
        }
    }
    
    func listPublisher() -> AnyPublisher<[InOutEntity.Entity], NSError> {
        
        let fetchRequest = InOutEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = self.sortDescriptor()
        
        return CoreDataPublisher<InOutEntity.Entity, NSError>(request: fetchRequest,
                                                  context: self.mainContext).eraseToAnyPublisher()
    }
    
    func sortDescriptor() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}