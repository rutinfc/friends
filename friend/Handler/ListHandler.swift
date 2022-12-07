//
//  ListHandler.swift
//  Friend
//
//  Created by JK Kim on 2022/12/06.
//

import Foundation

class ListHandler: ObservableObject {
    
    @Published var list = [String]()
    
    func addList() {
        self.list.append(UUID().description)
    }
}
