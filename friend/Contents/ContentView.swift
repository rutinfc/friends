//
//  ContentView.swift
//  Friend
//
//  Created by JK Kim on 2022/12/06.
//

import SwiftUI

struct ContentView: View {
    
    let handler = CoreDataListHandler()
    let lottoHandler = LottoCorDataListHandler()
    let counter = LetterListHandlerCounter()
    
    var body: some View {
        
        TabView {
            LottoRecordView()
                .environmentObject(self.lottoHandler as LottoListHandler)
                .tabItem{
                    Label("record".localized, systemImage: "circle.hexagongrid.fill")
                }
            
            HomeMainView()
                .environmentObject(self.handler as ListHandler) // enviormentObject로 사용하여 하위 view에서도 선언을 통해 공통적으로 사용 가능하다.
                .tabItem{
                    Label("record".localized, systemImage: "circle.hexagongrid.fill")
                }

            GraphView(counter: self.counter) // 앱 생성 시점에 주입하여 사용한다.
                .tabItem{
                    Label("Chart", systemImage: "sum")
                }
        }
        .onAppear {
            self.counter.sources = self.handler
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
