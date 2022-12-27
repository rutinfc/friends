//
//  AlphabetCounter.swift
//  friend
//
//  Created by JK Kim on 2022/12/21.
//

import Foundation
import Combine

struct LetterCount: Identifiable {
    
    var id: String { letter }
    var letter: String
    var count: Int
}

actor CounterActor {
    var counterInfo = [String: Int]()
    
    
}

class LetterCounter: ObservableObject {
    
    static let sample: [LetterCount] = [.init(letter: "A", count: 10),
                                          .init(letter: "B", count: 20),
                                          .init(letter: "C", count: 30),
                                          .init(letter: "D", count: 40),
                                          .init(letter: "E", count: 50),
                                          .init(letter: "F", count: 60),
                                          .init(letter: "G", count: 70),
                                          .init(letter: "H", count: 90),]
    
    @Published var summary = [LetterCount]()
    
    init() {
        self.summary = LetterCounter.sample
    }
}

