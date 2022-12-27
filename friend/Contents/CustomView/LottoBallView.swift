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

struct LottoBallView: View {
    
    enum BallColor: String {
        case blue = "BallBlue", red = "BallRed", green = "BallGreen", gray = "BallGray", yellow = "BallYellow"
        
        var color: Color {
            return Color(self.rawValue)
        }
        
        static func color(number:Int) -> Color {
            var ballColorType: BallColor
            if number < 10 {
                ballColorType = .yellow
            } else if number < 20 {
                ballColorType = .blue
            } else if number < 30 {
                ballColorType = .red
            } else if number < 40 {
                ballColorType = .gray
            } else {
                ballColorType = .green
            }
            return ballColorType.color
        }
    }
    
    var ball: LottoBall
    
    var body: some View {
        ZStack {
            Circle().fill(BallColor.color(number: self.ball.number))
            Text("\(self.ball.number)")
                .font(Font.system(size: 24, weight: .medium))
                .foregroundColor(Color("BallNumber"))
                .shadow(color:Color("BallLine"), radius: 1)
        }
    }
}

struct LottoBallView_Previews: PreviewProvider {
    
    static var previews: some View {
        LottoBallView(ball: LottoBall(number: 1))
    }
}
