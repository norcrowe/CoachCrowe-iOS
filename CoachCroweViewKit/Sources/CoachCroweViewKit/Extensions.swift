import SwiftUI
import CoachCroweBasic
import Foundation
import UIKit

public extension View {
    
    /// 背景毛玻璃
    func glassEffect(style: GlassEffectStyle = .main) -> some View {
        self.background(GlassEffect(style: style.style))
    }
    
    /// 圆角化
    func rounded(radius: CGFloat = 15) -> some View {
        self
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
    
    /// 圆角填充色背景
    func roundedColorBackground(color: Color, radius: CGFloat = 15, opacity: CGFloat = 1) -> some View {
        self
            .background(
                color
                    .opacity(opacity)
            )
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
    
    /// 圆角毛玻璃
    func roundedGlassEffectBackground(radius: CGFloat = 15, _ style: GlassEffectStyle = .main) -> some View {
        self
            .background(
                GlassEffect(style: style.style)
                    .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            )
    }

    /// 全局背景
    func fullBackgroundColor() -> some View {
        ZStack {
            Color(ColorSelection.backgroundColor)
                .ignoresSafeArea()
            self
        }
    }
    
    /// 颜色背景
    func backgroundColor(_ color: Color) -> some View {
        self
            .background(color)
    }
    
    /// 视图横向
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    /// 视图竖向
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    /// Hud
    func hud(hudState: Binding<HudState?>) -> some View {
        self
            .overlay(
                HudView(hudState: hudState)
            )
    }
    
    /// Caption修饰
    func caption() -> some View {
        self
            .font(.caption)
            .foregroundColor(.secondary)
    }

    /// 自定义Disabled
    func customDisabled(_ disabled: Bool, changeOpacity: Bool = true) -> some View {
        self
            .disabled(disabled)
            .opacity(changeOpacity&&disabled ? 0.5 : 1)
    }
}


public extension Text {
    /// 本地化
    init(key: String) {
        self
            .init(NSLocalizedString(key, comment: ""))
    }
}
