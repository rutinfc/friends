//
//  ListHandlerView.swift
//  Friend
//
//  Created by JK Kim on 2022/12/06.
//

import SwiftUI

struct HomeListView: View {
    
    @EnvironmentObject var handler: ListHandler
    
    var body: some View {
        Text("List Count : \(handler.list.count)")
    }
}

struct HomeMainView: View {
    
    @EnvironmentObject var handler: ListHandler
    
    var body: some View {
        NavigationView {
            HomeListView()
                .navigationBarTitle("Home", displayMode: .inline)
                .toolbar {
                    Button {
                        self.handler.addList()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
        }
    }
}

struct ListHandlerView_Previews: PreviewProvider {
    static var previews: some View {
        let handler = ListHandler()
//        HomeMainView(handler: handler)
        HomeMainView().environmentObject(handler)
    }
}
