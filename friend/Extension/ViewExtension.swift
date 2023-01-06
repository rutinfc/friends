//
//  ViewExtension.swift
//  Friend
//
//  Created by JK Kim on 2022/12/06.
//

import SwiftUI
import Combine

extension View {
    func onOutline() -> some View {
        return self.border(.green)
    }
    
    func pressAction(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(PressActions(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}

struct PressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}

struct HeightToKeyboard: ViewModifier {
    
    @Binding var keyboardHeight: CGFloat
    
    func body(content: Content) -> some View {

        content
            .onAppear(perform: {
                let publisehr = NotificationCenter.Publisher(center: NotificationCenter.default,
                                                             name: UIResponder.keyboardWillChangeFrameNotification)
                NotificationCenter.Publisher(center: NotificationCenter.default,
                                             name: UIResponder.keyboardWillShowNotification)
                .merge(with: publisehr)
                .compactMap { notification in
//                    withAnimation(.easeOut(duration: 0.16)) {
                        notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
//                    }
                }
                .map { rect in
                    rect.height //- (UIApplication.shared.firstWindows?.safeAreaInsets.bottom ?? 0)
                }
                .subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardHeight))
                
                NotificationCenter.Publisher(center: NotificationCenter.default,
                                             name: UIResponder.keyboardWillHideNotification)
                .compactMap { notification in
                    CGFloat.zero
                }
                .subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardHeight))
            })
    }
}

extension View {
    func keyboard(height:Binding<CGFloat>) -> some View {
        return modifier(HeightToKeyboard(keyboardHeight: height))
    }
}
