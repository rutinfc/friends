//
//  PreesedButton.swift
//  friend
//
//  Created by JK Kim on 2022/12/19.
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

struct PreesedButton_Previews: PreviewProvider {
    static var previews: some View {
        PressedButton(normalImage: Image(systemName: "minus.circle"),
                      pressedImage: Image(systemName: "minus.circle.fill")) {
            
        }.frame(width: 40, height: 40)
    }
}
