//
//  LottoListHandler.swift
//  Friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/27.
//

import Foundation
import Combine

struct LottoRecordSection: Identifiable, Equatable, Hashable {
    
    var id: String = UUID().description
    var round: Int
    var title: String {
        return "\(round)회"
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

struct LottoRecordItem: Identifiable, Equatable, Hashable {
    var id: String
    var round: Int = 1
    var numbers: [Int]
    var fixed: Bool = false
    var date: Date = Date()
    var balls: [LottoBall] {
        return numbers.compactMap({LottoBall(number: $0)})
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

extension LottoRecordItem {
    static func sampleItem() -> LottoRecordItem {
        
        let numbers = randomUniqueNumber(length: 6, range: (1...45))
        
        return LottoRecordItem(id: UUID().description, numbers: numbers.sorted(by: {$0 < $1} ))
    }
    
    static func randomUniqueNumber(length:Int, range:ClosedRange<Int>) -> [Int] {
        
        var result = [Int]()
        
        while(result.count < length) {
            result = self.addUniqueRandomNumbers(length: length, range: range, numbers: result)
        }
        
        return result.suffix(length)
    }
    
    static func addUniqueRandomNumbers(length:Int, range:ClosedRange<Int>, numbers: [Int]) -> [Int] {
        var result = (0..<length).compactMap { _ in
            return Int.random(in:range)
        }
        result.append(contentsOf: numbers)
        return Array(Set(result))
    }
}

class LottoListHandler: ObservableObject {
    
    @Published var sections = [LottoRecordSection]()
    @Published var records = [Int:[LottoRecordItem]]()
    
    var cancellable = Set<AnyCancellable>()
    
    func lastItem() -> LottoRecordItem? {
        guard let last = self.sections.last else {
            return nil
        }
        
        return self.records[last.round]?.last
    }
    
    func addList() {
        
    }
    
    func modify(item: LottoRecordItem) {
        
    }
    
    func delete(item: LottoRecordItem) {
        
        guard var list = self.records[item.round] else {
            return
        }
        
        list.removeAll(where: { $0 == item } )

        if list.count == 0 {
            self.records.removeValue(forKey: item.round)

            self.sections.removeAll { section in
                return section.round == item.round
            }

        } else {
            self.records[item.round] = list
        }
    }
}

class LottoSampleListHandler: LottoListHandler {
    
    override init() {
        super.init()
        (0..<10).forEach { _ in
            self.addList()
        }
    }
    
    override func addList() {
        
        let item = LottoRecordItem.sampleItem()
        
        if var list = self.records[item.round] {
            list.append(item)
            self.records[item.round] = list
        } else {
            self.records[item.round] = [item]
            self.sections.append(LottoRecordSection(id: UUID().description, round: item.round))
        }
    }
}

class LottoCorDataListHandler: LottoListHandler {
    
    let dataHandler = CoreDataHandler<LottoRecordMO>()
    
    override init() {
        super.init()
        
        self.dataHandler.listPublisher()
            .dropFirst(1)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error) :
                    print("Error : \(error)")
                }
            } receiveValue: { [weak self] result in
                
                guard let self = self else { return }
                
                let list = result.compactMap { mo in
                    
                    guard let numbers = mo.numbers,
                          let date = mo.date else {
                        return nil
                    }
                    return LottoRecordItem(id: mo.identifier,
                                           round: mo.round,
                                           numbers: numbers,
                                           fixed: mo.fixed,
                                           date: date)
                } as [LottoRecordItem]
                
                self.records = Dictionary(grouping: list) { item in
                    return item.round
                }
                
                self.sections = self.records.keys.compactMap { round in
                    return LottoRecordSection(round: round)
                }
                
                print("Update DataList : \(self.sections.count) | \(self.records.count)")
                
            }.store(in: &self.cancellable)
    }
    
    override func addList() {
        
        let item = LottoRecordItem.sampleItem()
        
        self.dataHandler.insert { mo in
            mo.identifier = item.id
            mo.fixed = item.fixed
            mo.date = item.date
            mo.round = item.round
            mo.numbers = item.numbers
            return true
        }
    }
    
    override func modify(item: LottoRecordItem) {
        
        let predicate = NSPredicate(format: "identifier == %@", item.id)
        
        self.dataHandler.newOrUpdate(predicate: predicate) { mo in
            guard let managedObject = mo else {
                return false
            }
            
            managedObject.identifier = item.id
            managedObject.fixed = item.fixed
            managedObject.date = item.date
            managedObject.round = item.round
            managedObject.numbers = item.numbers
            return true
        }
    }
}
