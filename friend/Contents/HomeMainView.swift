//
//  ListHandlerView.swift
//  Friend
//
//  Created by JK Kim on 2022/12/06.
//

import SwiftUI

struct PressedButton: View {
    
    @State private var isPressed = false
    
    private var action: () -> Void
    private var normalImage: Image
    private var pressedImage: Image
    
    init(normalImage:Image, pressedImage: Image, action: @escaping () -> Void) {
        self.action = action
        self.normalImage = normalImage
        self.pressedImage = pressedImage
    }
    
    var body: some View {
        
        (self.isPressed ? self.pressedImage : self.normalImage)
            .resizable()
            .overlay(
                GeometryReader { geometry in
                    Button(action: action) {
                        Text("")
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .pressAction {
                        self.isPressed = true
                    } onRelease: {
                        self.isPressed = false
                    }
                }
            )
    }
}

struct HomeMainOldView: View {
    
    @EnvironmentObject var handler: ListHandler
    @State var isActive: Bool = false
    
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

struct HomeMainView: View {
    
    @EnvironmentObject var handler: ListHandler
    @State private var isActive: Bool = false
    @State var current = ItemModel(id: "", date: Date())
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                Text("List Count : \(handler.list.count)")
                
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
            }
        }
    }
}

struct ListHandlerView_Previews: PreviewProvider {
    static var previews: some View {
        let handler = SampleListHandler()
        HomeMainView().environmentObject(handler as ListHandler)
    }
}
