import Foundation
import SwiftUI
import LeanCloud

/// 尺寸集
public class MemberSizes {
    static public let screenWidth: CGFloat = UIScreen.main.bounds.width
    static public let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    /// 组件宽度 `组件 = (List, )`
    static public let componentWidth: CGFloat = isPad ? (screenWidth-30)/2-5 : screenWidth-30
    
    /// 有效宽度
    static public let effectiveWidth: CGFloat = screenWidth - 30
    
    /// 控件高度
    static public let controlHeight: CGFloat = 42
}

/// 判断是否为iPad设备
public let isPad = UIDevice.current.userInterfaceIdiom == .pad

/// LeanCloud `Version` Class
public class LCVersionClass {
    static public let className: String = "Version"
    static public let versionID: String = "versionID"
    static public let downloadAddress: String = "downloadAddress"
    static public let needUpdate: String = "needUpdate"
}

/// LeanCloud `Profile` Class
public class LCProfileClass {
    static public let className: String = "Profile"
    static public let phoneNumber: String = "phoneNumber"
    static public let name: String = "name"
    static public let photo: String = "photo"
    static public let user: String = "user"
}
