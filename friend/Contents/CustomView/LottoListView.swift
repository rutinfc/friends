//
//  LottoListView.swift
//  friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/26.
//

import SwiftUI

struct LottoListView: View {
    
    var ballList: [LottoBall]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(self.ballList) { number in
                LottoBallView(ball: number)
            }
        }.frame(height:40)
    }
}

struct LottoListView_Previews: PreviewProvider {
    
    static let samples = [1, 10, 20, 30, 40, 45]
    
    static var previews: some View {
        LottoListView(ballList: samples.compactMap( {LottoBall(number: $0)} ))
    }
}
