//
//  ListHandler.swift
//  Friend
//
//  Created by JK Kim on 2022/12/06.
//

import Foundation
import Combine

struct ItemModel: Identifiable, Equatable {
    
    var id: String
    var date: Date
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

class ListHandler: ObservableObject {
    
    @Published var list = [ItemModel]()
    
    func addList() {
        self.list.append(ListHandler.createItem())
    }
    
    func delete(item: ItemModel) {
        print("DELETE : \(item.id)")
        self.list.removeAll(where: { $0 == item } )
    }
}

extension ListHandler {
    static func createItem() -> ItemModel {
        return ItemModel(id: UUID().description, date: Date())
    }
}

class SampleListHandler: ListHandler {
    
    override init() {
        super.init()
        
        (0..<10).forEach{ _ in
            self.addList()
            print("<--- ADD")
        }
    }
}
