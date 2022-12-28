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

struct KeyboardModifier: ViewModifier {

  @State var offset: CGFloat = .zero
  @State var subscription = Set<AnyCancellable>()

  func body(content: Content) -> some View {
    GeometryReader { geometry in
      content
        .padding(.bottom, self.offset)
        .onAppear {

            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .handleEvents(receiveOutput: { _ in self.offset = 0 })
                .sink { _ in }
                .store(in: &self.subscription)

            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
                .compactMap(\.userInfo)
                .compactMap {
                    ($0[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.size.height
                }
                .sink(receiveValue: { keyboardHeight in
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    let textFieldBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    self.offset = max(0, textFieldBottom - keyboardTop * 2 - geometry.safeAreaInsets.bottom)
                    print("<--- OFFSET : \(self.offset)")
                })
                .store(in: &self.subscription)
        }
        .onDisappear {
          // Dismiss keyboard
          UIApplication.shared.windows
            .first { $0.isKeyWindow }?
            .endEditing(true)

          self.subscription.removeAll() }
    }
  }
}
