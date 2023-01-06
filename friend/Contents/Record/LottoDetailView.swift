//
//  LottoDetailView.swift
//  Friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/28.
//

import SwiftUI

struct LottoDetailView: View {
    
    @EnvironmentObject var handler: LottoListHandler
    
    @State var modifyNumber = false
    
    var body: some View {
        VStack {
            Text("\(handler.selection.round)회")
            Text("\(String(describing: handler.selection.numbers))")
        }
        .navigationBarTitle("detail".localized)
        .toolbar {
            Button {
                self.modifyNumber = true
            } label: {
                Image(systemName: "square.and.pencil")
            }
            .foregroundColor(self.handler.selection.fixed ? Color.Button.disable : Color.Common.point)
            .disabled(self.handler.selection.fixed)
        }
        .toolbar {
            Button {
                var fixed = self.handler.selection.fixed
                fixed.toggle()
                self.handler.modifySelection(fixed: fixed)
            } label: {
                Image(systemName: handler.selection.fixed ? "lock" : "lock.open")
            }
            .foregroundColor(Color.Common.point)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $modifyNumber) {
            LottoOrderView()
        }
    }
}

struct LottoDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        LottoDetailView()
    }
}
