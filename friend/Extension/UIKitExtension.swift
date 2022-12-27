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
