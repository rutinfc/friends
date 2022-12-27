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

struct LottoRecordRowItem: Identifiable, Equatable, Hashable {
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

extension LottoRecordRowItem {
    static func sampleItem() -> LottoRecordRowItem {
        
        let numbers = (0..<6).compactMap { _ in
            return Int.random(in: 1...45)
        }
        
        return LottoRecordRowItem(id: UUID().description, numbers: numbers.sorted(by: {$0 < $1} ))
    }
}

class LottoListHandler: ObservableObject {
    
    @Published var sections = [LottoRecordSection]()
    @Published var records = [Int:[LottoRecordRowItem]]()
    
    var cancellable = Set<AnyCancellable>()
    
    func lastItem() -> LottoRecordRowItem? {
        guard let last = self.sections.last else {
            return nil
        }
        
        return self.records[last.round]?.last
    }
    
    func addList() {
        
        let item = LottoRecordRowItem.sampleItem()
        
        if var list = self.records[item.round] {
            list.append(item)
            self.records[item.round] = list
        } else {
            self.records[item.round] = [item]
            self.sections.append(LottoRecordSection(id: UUID().description, round: item.round))
        }
    }
    
    func delete(item: LottoRecordRowItem) {
        
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
}

class LottoCorDataListHandler: LottoListHandler {
    
    let dataHandler = CoreDataHandler<LottoRecordMO>()
    
    override init() {
        super.init()
        
        self.dataHandler.listPublisher().sink { result in
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
                return LottoRecordRowItem(id: mo.identifier,
                                          round: mo.round,
                                          numbers: numbers,
                                          fixed: mo.fixed,
                                          date: date)
            } as [LottoRecordRowItem]
            
            self.records = Dictionary(grouping: list) { item in
                return item.round
            }
            
            self.sections = self.records.keys.compactMap { round in
                return LottoRecordSection(round: round)
            }
            
        }.store(in: &self.cancellable)
    }
    
    override func addList() {
        
        let item = LottoRecordRowItem.sampleItem()
        
        self.dataHandler.insert { mo in
            mo.identifier = item.id
            mo.fixed = item.fixed
            mo.date = item.date
            mo.round = item.round
            mo.numbers = item.numbers
            return true
        }
    }
}
