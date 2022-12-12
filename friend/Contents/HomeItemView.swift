//
//  HomeItemView.swift
//  Friend
//
//  Created by JK Kim on 2022/12/09.
//

import SwiftUI

struct HomeItemView: View {
    
    var item: ItemModel
        
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            VStack(alignment: .leading, spacing: 10) {
                Text("ID").font(.largeTitle)
                Text(item.id).font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("DATE").font(.largeTitle)
                Text("\(item.date)").font(.headline)
            }
            
            Spacer()
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}

struct HomeItemView_Previews: PreviewProvider {
    static var previews: some View {
        
        let item = ListHandler.createItem()
        
        HomeItemView(item: item)
    }
}
