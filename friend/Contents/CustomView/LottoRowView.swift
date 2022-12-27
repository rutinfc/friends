//
//  LottoRowView.swift
//  friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/26.
//

import SwiftUI



struct LottoRowView: View {
    
    var item: LottoRecordRowItem
    
    var body: some View {
        
        ZStack(alignment:.topLeading) {
            
            VStack {
                
                Spacer(minLength: 10)
                
                VStack {
                    HStack(spacing: 5) {
                        LottoListView(ballList: item.balls)
                        Spacer()
                        Image(systemName: "chevron.forward").opacity(0.5)
                    }
                }
                Spacer(minLength: 10)
                
                Rectangle().frame(height:1).foregroundColor(Color("RowLine"))
            }
            .padding(.leading, 24)
            .padding(.trailing, 20)
            
            if item.fixed {
                Image(systemName: "lock.circle")
                    .foregroundColor(Color.red.opacity(0.8))
                    .padding(.leading, 10)
            }
        }
    }
}

struct LottoRowView_Previews: PreviewProvider {
    
    static var item = LottoRecordRowItem.sampleItem()
    
    static var previews: some View {
        LottoRowView(item: self.item).frame(height:60)
    }
}
