//
//  HomeItemView.swift
//  Friend
//
//  Created by JK Kim on 2022/12/09.
//

import SwiftUI

struct HomeItemView: View {
    
    var item: ItemModel
    @State var isPresented: Bool = false
    
    var body: some View {
        
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("ID").font(.largeTitle)
                    Button {
                        self.isPresented = true
                    } label: {
                        Text(item.id).multilineTextAlignment(.leading).font(.headline)
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("DATE").font(.largeTitle)
                    Text("\(item.date)").font(.headline)
                }
                
                Spacer()
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            Spacer()
        }
        .navigationDestination(isPresented: $isPresented) {
            Text(item.id).navigationTitle("ID")
        }
        .navigationTitle(!self.isPresented ? "Detail" : "")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct HomeItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let item = ListHandler.createItem()
        NavigationStack {
            HomeItemView(item: item)
        }
    }
}
