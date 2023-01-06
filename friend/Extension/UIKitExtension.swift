//
//  File.swift
//  friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/13.
//

import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
//        self.interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}


extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "번호기록")
    }
}

// MARK: Retrieve TextField first responder for keyboard
extension UIResponder {

  private static weak var currentResponder: UIResponder?

  static var currentFirstResponder: UIResponder? {
    currentResponder = nil
    UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder),
                                    to: nil, from: nil, for: nil)
    return currentResponder
  }

  @objc private func findFirstResponder(_ sender: Any) {
    UIResponder.currentResponder = self
  }

  // Frame of the superview
  var globalFrame: CGRect? {
    guard let view = self as? UIView else { return nil }
    return view.superview?.convert(view.frame, to: nil)
  }
}

extension UIApplication {
    
    var firstWindows: UIWindow? {
        return UIApplication.shared.connectedScenes.compactMap({$0 as? UIWindowScene}).first?.windows.first
    }
}
