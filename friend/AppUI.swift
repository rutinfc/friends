//
//  AppUI.swift
//  friend
//
//  Created by JK Kim on 2022/12/06.
//

import SwiftUI

#if SwiftUIApp
@main
struct FriendUIApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView2()
        }
    }
}
#endif

struct ContentView2: View {

  var body: some View {
      VStack {
          Text("RUN2????")
      }.background(Color.red)
  }
}

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView2()
    }
}
