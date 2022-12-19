//
//  GraphView.swift
//  Friend
//
//  Created by JK Kim on 2022/12/20.
//

import SwiftUI
import Charts

struct GraphView: View {
    
    @ObservedObject var counter: LetterCounter
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Letter count").font(.title).bold()
            Chart {
                ForEach(counter.summary) { summary in
                    BarMark(x: .value("Sum", summary.count),
                            y: .value("Alphabet", summary.letter))
                }
            }
        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
    }
}

struct GraphView_Previews: PreviewProvider {
    
    static var previews: some View {
        GraphView(counter: LetterCounter())
    }
}
