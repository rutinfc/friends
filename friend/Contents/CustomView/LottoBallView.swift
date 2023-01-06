//
//  LottoBallView.swift
//  friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/26.
//

import SwiftUI

struct LottoBall: Identifiable {
    var id: String = UUID().description
    var number: Int
}

fileprivate extension Color.Ball {
    static func number(_ number:Int) -> Color {
        if number < 10 {
            return Color.Ball.yellow
        } else if number < 20 {
            return Color.Ball.blue
        } else if number < 30 {
            return Color.Ball.red
        } else if number < 40 {
            return Color.Ball.gray
        } else {
            return Color.Ball.green
        }
    }
}

struct LottoBallView: View {
    
    var ball: LottoBall
    
    var body: some View {
        ZStack {
            Circle().fill(Color.Ball.number(self.ball.number))
            Text("\(self.ball.number)")
                .font(Font.system(size: 24, weight: .medium))
                .foregroundColor(Color.Ball.number)
                .shadow(color:Color.Ball.line, radius: 1)
        }
    }
}

struct LottoBallView_Previews: PreviewProvider {
    
    static var previews: some View {
        LottoBallView(ball: LottoBall(number: 1))
    }
}
