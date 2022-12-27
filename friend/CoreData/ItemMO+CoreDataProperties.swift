//
//  ModelItem+CoreDataProperties.swift
//  
//
//  Created by JK Kim on 2022/12/19.
//
//

import Foundation
import CoreData

extension ItemMO {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemMO> {
        return NSFetchRequest<ItemMO>(entityName: "ItemMO")
    }
    
    @nonobjc public class func newEntityDescription(context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "ItemMO", in: context)
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
}
