//
//  LottoDetailView.swift
//  Friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/28.
//

import SwiftUI

struct LottoDetailView: View {
    
    @Binding var item: LottoRecordItem
    
    @EnvironmentObject var handler: LottoListHandler
    
    @State var modifyNumber = false
    
    var body: some View {
        VStack {
            Text("\(item.round)회")
            Text("\(String(describing: item.numbers))")
        }
        .navigationBarTitle("detail".localized)
        .toolbar {
            Button {
                //                    self.handler.addList()
                self.modifyNumber = true
            } label: {
                Image(systemName: "square.and.pencil")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $modifyNumber) {
            LottoOrderView(item:$item)
        }
    }
}

struct LottoDetailView_Previews: PreviewProvider {
    
    @State static var item = LottoRecordItem.sampleItem()
    
    static var previews: some View {
        LottoDetailView(item:$item)
    }
}
