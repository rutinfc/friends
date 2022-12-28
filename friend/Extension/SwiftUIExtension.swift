//
//  SwiftUIExtension.swift
//  friend
//
//  Created by 김정규님/Comm Client팀 on 2022/12/14.
//

import SwiftUI

struct RootPresentationModeKey: EnvironmentKey {
    static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

extension EnvironmentValues {
    var rootPresentationMode: Binding<RootPresentationMode> {
        get { return self[RootPresentationModeKey.self] }
        set { self[RootPresentationModeKey.self] = newValue }
    }
}

typealias RootPresentationMode = Bool

extension RootPresentationMode {
    
    public mutating func dismiss() {
        self.toggle()
    }
}


struct HideTabbarKey: EnvironmentKey {
    static let defaultValue: Binding<HideTabbar> = .constant(HideTabbar())
}

extension EnvironmentValues {
    var hideTabbar: Binding<HideTabbar> {
        get { return self[HideTabbarKey.self] }
        set { self[HideTabbarKey.self] = newValue }
    }
}

typealias HideTabbar = Bool

extension HideTabbar {
    
    public mutating func hidden() {
        self = true
    }
    
    public mutating func show() {
        self = false
    }
}
