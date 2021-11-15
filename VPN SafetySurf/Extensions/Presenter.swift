//
//  Presenter.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 01.11.2021.
//

import SwiftUI

fileprivate struct FullModal<PresentedView: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    let presentedView: PresentedView
    let style: ModalAnimationStyle
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                    content
                }
                ZStack {
                    Color.clear.edgesIgnoringSafeArea(.all)
                    
                    self.presentedView
                }.opacity(isPresented ? 1 : 0)
            }
        }
    }
    
    private var opacity: Double {
        switch style {
        case .none, .slide:
            return 1
        case .fade:
            return isPresented ? 1 : 0
        }
    }
    
    private func viewHeight(_ proxy: GeometryProxy) -> CGFloat {
        proxy.size.height + proxy.safeAreaInsets.top + proxy.safeAreaInsets.bottom
    }
    
}

/// Defines all the animation styles
enum ModalAnimationStyle {
    /// View will present without animation
    case none
    
    /// View will present by sliding from the bottom
    case slide
    
    /// View will fade in/out
    case fade
}

extension View {
    
    /// Presents a view like the old UIKit function to present a view controller `present()`
    func present<Content: View>(_ isPresented: Binding<Bool>, view: Content, style: ModalAnimationStyle = .slide) -> some View {
        self.modifier(FullModal(isPresented: isPresented, presentedView: view, style: style))
                .animation(style != .none ? .easeInOut : .none)
    }
    
}
