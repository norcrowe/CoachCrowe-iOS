import Foundation
import SwiftUI
import LeanCloud

/// 尺寸集
public class MemberSizes {
    /// 设备安全区域值
    static public let safeAreaInsets = UIApplication.shared.windows.first!.safeAreaInsets

    /// 设备总宽度
    static public let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    /// 设备总高度
    static public let screenHeight: CGFloat = UIScreen.main.bounds.height
    
    /// 组件宽度
    static public let componentWidth: CGFloat = isPad ? (screenWidth-30)/2-5 : screenWidth-30
    
    /// 有效宽度
    static public let effectiveWidth: CGFloat = screenWidth - 30
    
    /// 控件高度
    static public let controlHeight: CGFloat = 42
    
    /// 控件次高度
    static public let controlSecondaryHeight: CGFloat = 35
    
    /// 主视图Head Bar高度
    static public let mainViewHeadBarHeight: CGFloat = 50 + 5 + controlSecondaryHeight

    /// Side Bar 宽度
    static public let sideBarWidth: CGFloat = isPad ? 320 : 260
    
    static public let bottomSpacerHeight: CGFloat = safeAreaInsets.bottom == 0 ? 10 : 0
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
    static public let id: String = "id"
    static public let photo: String = "photo"
    static public let user: String = "user"
}

/// Default Datas
class DefaultDatas {
    /// 默认半场篮球场数据
    static public var halfBasketballFieldData: Data {
        return try! JSONEncoder().encode(FieldModels.BasketballFieldModel(template: FieldModels.BasketballFieldTemplateModel(type: .half, mainLinesSize: .medium, aspectRatio: 0.95, fieldInteriorRatio: 1, threePointLineStartingXRatio: 0.12, threePointLineVerticalYRation: 0.66, threePointLineBottomCornerYRatio: 0.3, threePointLineCurveControlXRatio: 0.35, passingLineYRatio: 0.66, interiorLineStartingXRation: 0.6, interiorLineVerticalYRatio: 0.39, reboundXRation: 0.83, reboundYRation: 0.0833, threeSecondZoneLineStartingXRation: 0.8, threeSecondZoneLineVerticalYRation: 0.19), colors: FieldModels.BasketballFieldColorsModel(mainLinesColor: RGBAModel(red: 255, green: 255, blue: 255), interiorFillColor: RGBAModel(red: 255, green: 0, blue: 0), threePointLineInteriontFillColor: RGBAModel(red: 0, green: 255, blue: 0), interiorLineFillColor: RGBAModel(red: 0, green: 0, blue: 255))))
    }
    
    /// 默认全场篮球场数据
    static public var fullBasketballFieldData: Data {
        return try! JSONEncoder().encode(FieldModels.BasketballFieldModel(template: FieldModels.BasketballFieldTemplateModel(type: .full, mainLinesSize: .medium, aspectRatio: 1.7, fieldInteriorRatio: 1, threePointLineStartingXRatio: 0.12, threePointLineVerticalYRation: 0.66, threePointLineBottomCornerYRatio: 0.3, threePointLineCurveControlXRatio: 0.35, passingLineYRatio: 0.66, interiorLineStartingXRation: 0.6, interiorLineVerticalYRatio: 0.39, reboundXRation: 0.83, reboundYRation: 0.0833, threeSecondZoneLineStartingXRation: 0.8, threeSecondZoneLineVerticalYRation: 0.19), colors: FieldModels.BasketballFieldColorsModel(mainLinesColor: RGBAModel(red: 255, green: 255, blue: 255), interiorFillColor: RGBAModel(red: 255, green: 0, blue: 0), threePointLineInteriontFillColor: RGBAModel(red: 0, green: 255, blue: 0), interiorLineFillColor: RGBAModel(red: 0, green: 0, blue: 255))))
    }

    /// 默认半场足球场数据
    var halfFootballFieldData: Data {
        return try! JSONEncoder().encode(FieldModels.FootballFieldModel(template: FieldModels.FootballFieldTemplateModel(type: .half, mainLinesSize: .medium, aspectRatio: 0.85, fieldInteriorRatio: 1, penaltyAreaStartingXRatio: 0.68, penaltyAreaVerticalYRatio: 0.12, bigPenaltyAreaStartingXRatio: 0.34, bigPenaltyAreaVerticalYRatio: 0.296, arcXRation: 0.75, arcControlPointYRation: 0.385, goalpostStartingXRation: 0.85, goalpostVerticalYRation: 0.03, penaltyPointY: 0.207), colors: FieldModels.FootballFieldColorsModel(mainLinesColor: RGBAModel(red: 0, green: 0, blue: 0), turfColor: RGBAModel(red: 127, green: 204, blue: 76))))
    }
}
