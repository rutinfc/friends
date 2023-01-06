//
//  LottoRecordView.swift
//  Friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/27.
//

import SwiftUI

struct LottoRecordView: View {
    
    @EnvironmentObject var handler: LottoListHandler
    @State private var isActive: Bool = false
    @State var visibility = Visibility.visible
    
    var body: some View {
        
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(handler.sections) { section in
                            if let rows = self.handler.records[section.round] {
                                ZStack(alignment: .leading) {
                                    Color.List.sectionBg
                                    VStack {
                                        Spacer(minLength: 10)
                                        Text(section.title)
                                            .font(.title3)
                                            .padding(.leading, 20)
                                        Spacer(minLength: 10)
                                    }
                                }
                                    
                                ForEach(rows) { item in
                                    Button {
                                        self.handler.selection = item
                                        self.isActive = true
                                    } label: {
                                        LottoRowView(item: item)
                                    }
                                    .id(item.id)
                                }
                            }
                        }.onChange(of: self.handler.records, perform: { newValue in
                            withAnimation {
                                if let last = self.handler.lastItem() {
                                    proxy.scrollTo(last.id, anchor: .bottom)
                                }
                            }
                        })
                    }
                }
            }
            .onAppear {
                self.visibility = .visible
            }
            .navigationDestination(isPresented: $isActive) {
                LottoDetailView()
                    .onAppear {
                        self.visibility = .hidden
                    }
            }
            .listStyle(.plain)
            .navigationBarTitle(!self.isActive ? "record".localized : "", displayMode: .inline)
            .toolbar(self.visibility, for: .tabBar)
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

struct LottoRecordView_Previews: PreviewProvider {
    static var previews: some View {
        LottoRecordView().environmentObject(LottoSampleListHandler() as LottoListHandler)
    }
}
