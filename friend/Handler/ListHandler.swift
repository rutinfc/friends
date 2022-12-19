//
//  ListHandler.swift
//  Friend
//
//  Created by JK Kim on 2022/12/06.
//

import Foundation
import Combine
import CoreData

struct ItemModel: Identifiable, Equatable, Hashable {
    
    var id: String
    var date: Date
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

class ListHandler: ObservableObject {
    
    @Published var list = [ItemModel]()
    @Published var isShake: Bool = false
    @Published var recommendList = [ItemModel]()
    @Published var searchText: String = "" {
        didSet {
            
            if self.searchText.isEmpty {
                self.clearSearch()
                return
            }
            
            self.doSearch()
        }
    }
    
    var cancellable = Set<AnyCancellable>()
    
    func count() -> Int {
        return self.list.count
    }
    
    func addList() {
        self.list.append(ListHandler.createItem())
    }
    
    func delete(item: ItemModel) {
        self.list.removeAll(where: { $0 == item } )
    }
    
    func shakeList() {
        self.isShake = true
        Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
            self.addList()
        }.store(in: &self.cancellable)
        
        Timer.publish(every: 0.12, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
            if let item = self.list.first {
                self.delete(item: item)
            }
        }.store(in: &self.cancellable)
    }
    
    func stopShake() {
        self.cancellable.removeAll()
        self.isShake = false
    }
    
    func clearSearch() {
        
    }
    
    func doSearch() {
        
    }
    
    func submitSearch() {
        
    }
}

extension ListHandler {
    static func createItem() -> ItemModel {
        return ItemModel(id: UUID().description, date: Date())
    }
}

class SampleListHandler: ListHandler {
    
    private var tempList: [ItemModel]?
    
    override init() {
        super.init()
        
        (0..<10).forEach{ _ in
            self.addList()
        }
    }
    
    override func clearSearch() {
        self.recommendList.removeAll()
        if let list = self.tempList {
            self.list = list
            self.tempList = nil
        }
    }
    
    override func doSearch() {
        self.recommendList = self.list.filter { $0.id.lowercased().contains(self.searchText.lowercased()) }
    }
    
    override func submitSearch() {
        self.tempList = self.list
        self.list = self.list.filter{ $0.id.lowercased().contains(self.searchText.lowercased()) }
    }
}

class CoreDataListHandler: ListHandler {
    
    private var searchCancelables: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        
        self.registerListPublisher()
    }
    
    override func clearSearch() {
        self.recommendList.removeAll()
        self.registerListPublisher()
    }
    
    override func doSearch() {
        if let result = CoreDataManager.shared.search(text: self.searchText)?.compactMap({ItemModel(id: $0.id!, date: $0.date!)}) {
            self.recommendList = result
        } else {
            self.recommendList.removeAll()
        }
    }
        
    override func addList() {
        let item = ListHandler.createItem()
        CoreDataManager.shared.insert(id: item.id, date: item.date)
    }
    
    override func delete(item: ItemModel) {
        CoreDataManager.shared.delete(id: item.id)
    }
    
    override func submitSearch() {
        self.registerListPublisher()
    }
}

extension CoreDataListHandler {
    
    func registerListPublisher() {
        
        self.cancellables.removeAll()
        
        CoreDataManager.shared.listPublisher(filteredId: self.searchText).sink { result in
            switch result {
            case .finished:
                break
            case .failure(let error) :
                print("Error : \(error)")
            }
        } receiveValue: { [weak self] result in
            
            guard let self = self else { return }
            
            self.list = result.compactMap { ItemModel(id: $0.id!, date: $0.date!)}
            
        }.store(in: &self.cancellables)
    }
}
