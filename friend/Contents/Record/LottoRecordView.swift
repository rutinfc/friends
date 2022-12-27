//
//  LottoRecordView.swift
//  Friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/27.
//

import SwiftUI

struct LottoRecordOldView: View {
    @ObservedObject var handler = LottoListHandler()
    @State private var isActive: Bool = false
    @State var current = LottoRecordRowItem.sampleItem()

    var body: some View {
        NavigationStack {

            ScrollViewReader { proxy in
                List(handler.sections) { section in

                    Section(header: Text(section.title)) {
                        if let rows = self.handler.records[section.round] {
                            ForEach(rows) { item in
                                Button {
                                    self.current = item
                                    self.isActive = true
                                } label: {
                                    LottoRowView(item: item)
                                }
                                .id(item.id)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            }
                        }
                    }
                    .onChange(of: self.handler.records, perform: { newValue in
                        withAnimation {
                            if let last = self.handler.lastItem() {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    })
                }
            }
            .navigationDestination(isPresented: $isActive) {
                //                                        HomeItemView(item:self.current)
                Text("Detail")
            }
            .listStyle(.plain)
            .navigationBarTitle(!self.isActive ? "record".localized : "", displayMode: .inline)
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

struct LottoRecordView: View {
    
    @ObservedObject var handler: LottoListHandler
    @State private var isActive: Bool = false
    @State var current = LottoRecordRowItem.sampleItem()
    
    var body: some View {
        NavigationStack {
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(handler.sections) { section in
                            if let rows = self.handler.records[section.round] {
                                ZStack(alignment: .leading) {
                                    Color.gray.opacity(0.05)
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
                                        self.current = item
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
            .navigationDestination(isPresented: $isActive) {
                //                                        HomeItemView(item:self.current)
                Text("Detail")
            }
            .listStyle(.plain)
            .navigationBarTitle(!self.isActive ? "record".localized : "", displayMode: .inline)
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
        LottoRecordView(handler: LottoSampleListHandler())
    }
}
