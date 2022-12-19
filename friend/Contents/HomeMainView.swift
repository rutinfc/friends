//
//  ListHandlerView.swift
//  Friend
//
//  Created by JK Kim on 2022/12/06.
//

import SwiftUI

/**
    NavigationLink를 사용하여 Stack을 구현한다. ios16 이후에서 deprecated되는 isActive를 사용한다.
 
 */
struct HomeMainOldView: View {
    
    @EnvironmentObject var handler: ListHandler
    @State var isActive: Bool = false
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                Text("List Count : \(handler.list.count)")
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(handler.list) { item in
                            
                            HStack {
                                let destination = HomeItemView(item:item)
                                    .navigationTitle("Detail")
                                NavigationLink(destination: destination, isActive: $isActive) {
                                    VStack {
                                        Text("\(item.id)")
                                            .font(.headline)
                                            .lineLimit(1)
                                        Text("\(item.date)")
                                            .font(.subheadline)
                                            .lineLimit(1)
                                    }

                                }.padding(.trailing, 10)
                                Spacer()
                                PressedButton(normalImage: Image(systemName: "minus.circle"),
                                              pressedImage: Image(systemName: "minus.circle.fill")) {
                                    handler.delete(item: item)
                                }
                                              .frame(width: 40, height: 40)

                            }.padding(.trailing, 16)
                            
                            Rectangle()
                                .background(Color.gray)
                                .frame(width:UIScreen.main.bounds.width, height:1)
                        }
                    }
                }
            }
            .padding(.leading, 20)
            .searchable(text: $searchText)
            .navigationBarTitle(!self.isActive ? "Home" : "", displayMode: .inline)
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

/**
    NavigationStack를 사용하여 Stack을 구현한다.
    ListHandler를 무작의 생성하는 로직을 추가함
 */
struct HomeMainView: View {
    
    @EnvironmentObject var handler: ListHandler
    @State private var isActive: Bool = false
    @State var current = ItemModel(id: "", date: Date())
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                Text("List Count : \(handler.count())")
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        
                        ForEach(handler.list) { item in
                            
                            HStack {
                                Button {
                                    self.current = item
                                    self.isActive = true
                                } label: {
                                    VStack {
                                        Text("\(item.id)")
                                            .font(.headline)
                                            .lineLimit(1)
                                        Text("\(item.date)")
                                            .font(.subheadline)
                                            .lineLimit(1)
                                    }
                                }
                                Spacer()
                                PressedButton(normalImage: Image(systemName: "minus.circle"),
                                              pressedImage: Image(systemName: "minus.circle.fill")) {
                                    handler.delete(item: item)
                                }
                                              .frame(width: 40, height: 40)
                            }
                            
                            Rectangle()
                                .background(Color.gray)
                                .frame(width:UIScreen.main.bounds.width, height:1)
                        }
                    }
                }.navigationDestination(isPresented: $isActive) {
                    HomeItemView(item:self.current)
                }
            }
            .searchable(text: $handler.searchText, prompt: "ID Search") {
                ForEach($handler.recommendList) { result in
                    Text("\(result.id)").searchCompletion(result.id)
                }
            }.onSubmit(of: .search) {
                self.handler.submitSearch()
            }
            .padding(.leading, 20)
            .padding(.trailing, 10)
            .navigationBarTitle(!self.isActive ? "Home" : "", displayMode: .inline)
            .toolbar {
                Button {
                    self.handler.addList()
                } label: {
                    Image(systemName: "plus")
                }
                Button {
                    self.handler.isShake ? self.handler.stopShake() : self.handler.shakeList()
                } label: {
                    Image(systemName: self.handler.isShake ? "tornado.circle.fill" : "tornado.circle")
                }
            }
        }
    }
}

/**
    FetchedRequest property를 사용하여 데이터를 불러온다.
 */
struct HomeMainFetchView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: CoreDataManager.shared.sortDescriptor())
    var items: FetchedResults<ItemMO>
    
    @StateObject var handler = CoreDataListHandler()
    @State private var isActive: Bool = false
    @State var current = ItemModel(id: "", date: Date())
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                Text("List Count : \(items.count)")
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        
                        ForEach(items) { item in
                            
                            HStack {
                                Button {
                                    if let id = item.id, let date = item.date {
                                        self.current = ItemModel(id: id, date: date)
                                        self.isActive = true
                                    }
                                } label: {
                                    VStack {
                                        Text("\(item.id!)")
                                            .font(.headline)
                                            .lineLimit(1)
                                        Text("\(item.date!)")
                                            .font(.subheadline)
                                            .lineLimit(1)
                                    }
                                }
                                Spacer()
                                PressedButton(normalImage: Image(systemName: "minus.circle"),
                                              pressedImage: Image(systemName: "minus.circle.fill")) {
                                    
                                    if let id = item.id, let date = item.date {
                                        let item = ItemModel(id: id, date: date)
                                        self.handler.delete(item: item)
                                    }
                                }
                                              .frame(width: 40, height: 40)
                            }
                            
                            Rectangle()
                                .background(Color.gray)
                                .frame(width:UIScreen.main.bounds.width, height:1)
                        }
                    }.padding(.trailing, 10)
                }.navigationDestination(isPresented: $isActive) {
                    HomeItemView(item:self.current)
                }
            }
            .padding(.leading, 20)
            .navigationBarTitle(!self.isActive ? "Home" : "", displayMode: .inline)
            .toolbar {
                Button {
                    self.handler.addList()
                } label: {
                    Image(systemName: "plus")
                }
                Button {
                    self.handler.isShake ? self.handler.stopShake() : self.handler.shakeList()
                } label: {
                    Image(systemName: self.handler.isShake ? "tornado.circle.fill" : "tornado.circle")
                }
            }
        }
    }
}

struct ListHandlerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let handler = SampleListHandler()
            HomeMainView().environmentObject(handler as ListHandler)
            
            HomeMainFetchView().environment(\.managedObjectContext, CoreDataManager.shared.mainContext)
        }
    }
}
