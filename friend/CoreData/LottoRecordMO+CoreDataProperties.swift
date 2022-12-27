//
//  LottoRecordMO+CoreDataProperties.swift
//  
//
//  Created by 김정규님/Comm Client팀 on 2022/12/27.
//
//

import Foundation
import CoreData


extension LottoRecordMO: EntityProtocol {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LottoRecordMO> {
        return NSFetchRequest<LottoRecordMO>(entityName: "LottoRecordMO")
    }
    
    @nonobjc public class func newEntityDescription(context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "LottoRecordMO", in: context)
    }

    @NSManaged public var identifier: String
    @NSManaged public var numbers: [Int]?
    @NSManaged public var fixed: Bool
    @NSManaged public var date: Date?
    @NSManaged public var round: Int

}
