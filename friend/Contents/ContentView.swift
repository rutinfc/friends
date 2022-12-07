//
//  ContentView.swift
//  Friend
//
//  Created by JK Kim on 2022/12/06.
//

import SwiftUI

struct Page2: View {
    var body: some View {
        Text("PAGE 2")
    }
}

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            HomeMainView()
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
            
            Page2()
                .tabItem{
                    Image(systemName: "gear")
                    Text("Setting")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().onOutline()
            ContentView()
        }
    }
}