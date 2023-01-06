//
//  ColorExtension.swift
//  friend
//
//  Created by 김정규님/Comm Client팀 on 2023/01/06.
//

import SwiftUI

extension Color {
    struct Ball {
        static let blue = Color("BallBlue")
        static let gray = Color("BallGray")
        static let green = Color("BallGreen")
        static let red = Color("BallRed")
        static let yellow = Color("BallYellow")
        static let line = Color("BallLine")
        static let number = Color("BallNumber")
    }
    
    struct List {
        static let rowLine = Color("RowLine")
        static let sectionBg = Color("SectionBg")
    }
    
    struct Order {
        static let line = Color("OrderLine")
        static let mark = Color("OrderMark")
        static let numberMark = Color("OrderNumberMark")
    }
    
    struct Button {
        static let text = Color("ButtonText")
        static let disable = Color("ButtonDisable")
    }
    
    struct Common {
        static let point = Color("Point")

    }
}
