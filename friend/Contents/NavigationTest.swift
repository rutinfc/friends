//
//  NavigationTest.swift
//  FriendUI
//
//  Created by 김정규님/Comm Client팀 on 2022/12/12.
//

import SwiftUI

struct ViewA: View {

    @State var open = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("View isPresent")

                Button("Go to View 2") {
                    open = true
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(!self.open ? "TEST1" : "")
            .navigationDestination(isPresented: $open) {
                ViewB()
            }.toolbar {
                Button {

                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .environment(\.rootPresentationMode, $open)
    }
}

struct ViewB: View {

    @State var open: Bool = false
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>

    var body: some View {

        VStack {

            Text("View 2")

            Button("Go to View 3 ") {
                open = true
            }
            
            Button("Back Root") {
                self.rootPresentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle(!self.open ? "TEST2" : "")
        .navigationDestination(isPresented: $open) {
            ViewC()
        }
    }
}

struct ViewC: View {

    @State var open: Bool = false
    @Environment(\.rootPresentationMode) private var rootPresentationMode

    var body: some View {
        VStack {
            Text("View 3")

            Button("Go to View 4") {
                open = true
            }
            
            Button("Back Root") {
                self.rootPresentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle(!self.open ? "TEST3" : "")
        .navigationDestination(isPresented: $open) {
            ViewD()
        }
    }
}

struct ViewD: View {

    @State var open: Bool = false
    @Environment(\.rootPresentationMode) private var rootPresentationMode

    var body: some View {
        VStack {
            Text("View 4")

            Button("Go to View 1") {
                self.rootPresentationMode.wrappedValue.dismiss()
            }
        }.navigationTitle("TEST4")
    }
}

struct View1: View {

    @State var goToView2 = false
    @State var path = [String]()
    @State var titleFlag: Bool = true
    @State var titleFlag2: Bool = true
    @State var titleFlag3: Bool = true
    
    var body: some View {

        NavigationStack(path: $path) {
            VStack {
                Text("View NavigationLink")
                NavigationLink("Go to View 2", value: "1")
            }
            .navigationDestination(for: String.self, destination: { value in

                switch value {
                case "1":
                    View2(path: $path, titleFlag: $titleFlag2).onAppear{
                        self.titleFlag = false
                    }.onDisappear {
                        self.titleFlag = true
                    }
                case "2":
                    View3(path: $path, titleFlag: $titleFlag3).onAppear{
                        self.titleFlag2 = false
                    }.onDisappear {
                        self.titleFlag2 = true
                    }
                default:
                    View4(path: $path).onAppear{
                        self.titleFlag3 = false
                    }.onDisappear {
                        self.titleFlag3 = true
                    }
                }
            })
            .navigationTitle(self.titleFlag ? Text("TEST") : Text(""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {

                } label: {
                    Text("")
//                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct View2: View {

    @State var goToView3 = false
    @Binding var path: [String]
    @Binding var titleFlag: Bool
    
    var body: some View {

        VStack {

            Text("View 2 | \(String(describing: path.count))")

            NavigationLink(value: "2") {
                Text("Go to View 3")
            }
        }
        .navigationTitle(self.titleFlag ? Text("TEST2") : Text(""))
    }
}

struct View3: View {

    @State var goToView4 = false
    @Binding var path: [String]
    @Binding var titleFlag: Bool

    var body: some View {
        VStack {
            Text("View 3 | \(String(describing: path.count))")

            NavigationLink("Go to View 4", value: "3")
        }
        .navigationTitle(self.titleFlag ? Text("TEST3") : Text(""))
    }
}

struct View4: View {

    @Binding var path: [String]

    var body: some View {
        VStack {
            Text("View 4 | \(String(describing: path.count))")

            Button("Go to View 1") {
                print("Before: \(path.count)")
                path = .init()
                print("After: \(path.count)")
            }
        }
        .navigationTitle(Text("TEST4"))
    }
}

struct View1_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            ViewA()
            View1()
        }
    }
}
