import Foundation
import SwiftUI

/// 主视图选项
public enum MainViewState: CaseIterable, Equatable {
    case library
    case community
    case personal
    
    public var description: String {
        switch self {
        case .library:
            return "Library"
        case .community:
            return "Community"
        case .personal:
            return "Personal"
        }
    }
    
    public var sFSymbolName: String {
        switch self {
        case .library:
            return "house"
        case .community:
            return "shippingbox"
        case .personal:
            return "person"
        }
    }
}

/// 初始化状态
public enum InitializationState: Equatable {
    case initializing
    case failed
    case welcome
    case needLogin
    case newVersionReleased(versionID: String, downloadURL: URL)
}

/// 毛玻璃选项
public enum GlassEffectStyle {
    case main
    case secondary
    
    public var style: UIBlurEffect.Style {
        switch self {
        case .main:
            return .systemMaterial
        case .secondary:
            return .systemThickMaterial
        }
    }
}

/// 登录界面状态
public enum LoginViewState {
    case inputPhoneNumber
    case inputVerificationCode
    case signup
}

/// 地区选项
public enum Region {
    case china
    case portugal
    
    public var name: String {
        switch self {
        case .china:
            return "China"
        case .portugal:
            return "Portugal"
        }
    }
    
    public var flag: String {
        switch self {
        case .china:
            return "🇨🇳"
        case .portugal:
            return "🇵🇹"
        }
    }
    
    public var number: String {
        switch self {
        case .china:
            return "+86"
        case .portugal:
            return "+351"
        }
    }
}

/// 颜色选项
public enum ColorSelection: String {
    case backgroundColor
    case primaryColor
    case secondary
    case gray
    case blue
    
    public var color: Color { Color(self.rawValue) }
}

/// 自定义的Result
public enum MyResult<T> {
    case success(T)
    case failure
}

/// Hud State
public enum HudState: Equatable {
    case progress
    case completed(CompletedState, String)
    
    public enum CompletedState {
        case successed
        case failed
    }
 }

/// 震动选项
public enum Vibration {
    case soft
    case medium
    case success
    case error
    
    public func vibrate() {
        switch self {
        case .soft, .medium:
            let generator = UIImpactFeedbackGenerator(style: self == .soft ? .soft : .medium)
            generator.prepare()
            generator.impactOccurred()
        case .success, .error:
            UINotificationFeedbackGenerator().notificationOccurred(self == .success ? .success : .error)
        }
    }
}

/// 球的偏移
public enum BallOffsetMode: String, Codable {
    case left
    case right
    case up
    case down
}

/// 球场类型
public enum FieldType: String, Codable {
    case half
    case full
}

/// 通用尺寸
public enum UniversalSize: String, Codable {
    case small = "1x"
    case medium = "2x"
    case large = "3x"
    
    /// 线条宽度
    public var lineWidth: CGFloat {
        switch self {
        case .small:
            return 1.5
        case .medium:
            return 2.5
        case .large:
            return 4
        }
    }
}
