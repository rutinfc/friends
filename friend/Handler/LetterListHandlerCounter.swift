//
//  LetterListHandlerCounter.swift
//  friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/26.
//

import Foundation
import Combine

class LetterListHandlerCounter: LetterCounter {
    
    private var cancellable = Set<AnyCancellable>()
    private var counterActor = CounterActor()
    
    var sources: ListHandler? {
        
        willSet {
            self.cancellable.removeAll()
        }
        
        didSet {
            self.sources?.$list.sink(receiveValue: { [weak self] list in
                guard let self = self else {
                    return
                }
                self.executeTaskGroup(list: list)
            }).store(in: &self.cancellable)
        }
    }
    
    private func executeTaskGroup(list:[ItemModel]) {
        Task.detached(operation: {
            
            var total: Int = 0
            
            let resultStack = await withTaskGroup(of: [String: Int].self,
                                                  returning: [String: Int].self,
                                                  body: { taskGroup in
                for item in list {
                    taskGroup.addTask {
                        await self.countAlphabet(text: item.id)
                    }
                }
                
                var result = [String: Int]()
                
                for await info in taskGroup {
                    info.forEach { key, count in
                        if let prevCount = result[key] {
                            result[key] = count + prevCount
                        } else {
                            result[key] = count
                        }
                        total += count
                    }
                }
                
                return result
            })
            
            let result = resultStack.compactMap { key, value in
                return LetterCount(letter: key, count: Int((Double(value) / Double(total)) * 100))
            }.sorted(by: {$0.letter < $1.letter })
            
            await MainActor.run(body: {
                self.summary = result
            })
        })
    }
    
    private func countAlphabet(text: String) async -> [String: Int] {
        
        var result = [String: Int]()
        
        for char in text.replacingOccurrences(of: "-", with: "") {
            
            let key = String(char)
            
            if let count = result[key] {
                result[key] = count + 1
            } else {
                result[key] = 1
            }
        }
        return result
    }
}
