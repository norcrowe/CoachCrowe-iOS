import Foundation
import CoachCroweBasic
import UIKit
import LeanCloud
import SwiftUI

/// 主视图 View Model
public class MasterViewModel: ObservableObject {
    @Published public var mainViewState: MainViewState = .library
    @Published public var initializationState: InitializationState? = .initializing
    @Published public var showSideBar: Bool = false
    
    public init() {
        DispatchQueue.global().asyncAfter(deadline: .now()) {
            LCUser.logOut()
            self.initialization()
        }
    }
    
    public func initialization() {
        DispatchQueue.global().async {
            /// 检查是否有必须升级的版本
            let versionQuery = LCQuery(className: LCVersionClass.className)
            versionQuery.whereKey(LCVersionClass.needUpdate, .equalTo(true))
            versionQuery.find { result in
                switch result {
                case .success(let versions):
                    /// 检查时否有必须升级的版本发布
                    if versions.count == 1 {
                        guard let versionID = versions[0].get(LCVersionClass.versionID)?.stringValue, let downloadAddressString = versions[0].get(LCVersionClass.downloadAddress)?.stringValue, let downloadURL = URL(string: downloadAddressString) else {
                            DispatchQueue.main.async {
                                withAnimation(.spring) {
                                    self.initializationState = .failed
                                }
                            }
                            return
                        }
                        
                        DispatchQueue.main.async {
                            withAnimation(.spring) {
                                self.initializationState = .newVersionReleased(versionID: versionID, downloadURL: downloadURL)
                            }
                        }
                    } else {
                        /// 没有发现必须升级的版本 检查用户状态
                        if LCApplication.default.currentUser == nil {
                            DispatchQueue.main.async {
                                withAnimation(.spring) {
                                    self.initializationState = .welcome
                                }
                            }
                            return
                        }
                        
                        /// 开始加载主页信息
                        
                    }
                case .failure:
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut) {
                            self.initializationState = .failed
                        }
                    }
                }
            }
        }
    }
}

/// 注册 View Model
public class LoginViewModel: ObservableObject {
    @Published public var viewState: LoginViewState = .login
    @Published public var showImagePicker: Bool = false
    @Published public var hudState: HudState? = nil
    @Published public var image: UIImage? = nil
    @Published public var id: String = "nor"
    @Published public var password: String = "norindarkglasses"

    public init() {}
    
    /// 密码注册
    public func passwordSignup(completion: @escaping () -> Void) {
        withAnimation(.spring) {
            hudState = .progress
        }
        
        /// 检测用户ID是否已被注册
        LCNetworkServices.checkUserRegistered(id: self.id) { result in
            switch result {
            case .success(let registered):
                if registered {
                    DispatchQueue.main.async {
                        self.hudState = .completed(.failed, "This ID has been registered")
                    }
                    return
                }
                
                /// 开始注册
                guard let imageData = self.image?.pngData() else {
                    DispatchQueue.main.async {
                        self.hudState = .completed(.failed, "Signup failed")
                    }
                    return
                }

                LCNetworkServices.passwordSignup(id: self.id, password: self.password, imageData: imageData) { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.hudState = .completed(.successed, "Signup successed", {
                                completion()
                            })
                        }
                    case .failure:
                        DispatchQueue.main.async {
                            self.hudState = .completed(.failed, "Signup failed")
                        }
                    }
                }
                
            case .failure:
                DispatchQueue.main.async {
                    self.hudState = .completed(.failed, "Signup failed")
                }
                return
            }
        }
        
    }
    
    /// 密码登录
    public func passwordLogin(completion: @escaping () -> Void) {
        withAnimation(.spring) {
            hudState = .progress
        }
        /// 检查ID是否已注册
        LCNetworkServices.checkUserRegistered(id: self.id) { result in
            switch result {
            case .success(let registered):
                if !registered {
                    DispatchQueue.main.async {
                        self.hudState = .completed(.failed, "This ID has not been registered")
                    }
                    return
                }
                
                /// 开始登录
                LCNetworkServices.passwordLogin(id: self.id, password: self.password) { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.hudState = nil
                            completion()
                        }
                    case .failure:
                        DispatchQueue.main.async {
                            self.hudState = .completed(.failed, "Login failed")
                        }
                    }
                }

            case .failure:
                DispatchQueue.main.async {
                    self.hudState = .completed(.failed, "Login failed")
                }
            }
        }
    }
    
    /// 用于剪切UIImage
    struct ImageView: View {
        let image: UIImage
        let size: CGSize
        
        init(image: UIImage, size: CGSize) {
            self.image = image
            self.size = size
        }
        
        /// body
        var body: some View {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
        }
    }

}

/// 篮球场View Model
public class BasketballFieldViewModel: ObservableObject {
    @Published public var fieldData: FieldModels.BasketballFieldModel
    @Published public var fullWidth: CGFloat
    
    /// 模版数据
    public var templateData: FieldModels.BasketballFieldTemplateModel {
        return fieldData.template
    }
    
    /// 颜色数据
    public var colorsData: FieldModels.BasketballFieldColorsModel {
        return fieldData.colors
    }
    
    /// 主要线条大小
    public var mainLinesWidth: CGFloat {
        return templateData.mainLinesSize.lineWidth
    }
    
    /// 球场视图总高
    public var fullHeight: CGFloat {
        return fullWidth*templateData.aspectRatio
    }
    
    /// 球场内部大小
    public var fieldInteriorSize: CGSize {
        return CGSize(width: templateData.fieldInteriorRatio * fullWidth, height: templateData.fieldInteriorRatio * fullHeight)
    }
        
    /// 四分之一球场的宽度
    public var quarterFieldWidth: CGFloat {
        return fullWidth/2
    }
    
    /// 四分之一球场的高度
    public var quarterFieldHeight: CGFloat {
        switch templateData.type {
        case .half:
            return fullHeight
        case .full:
            return fullHeight/2
        }
    }
    
    /// 三分线起点X
    public var threePointLineStartingX: Double {
        return templateData.threePointLineStartingXRatio * quarterFieldWidth
    }
    
    /// 三分线顶点Y
    public var threePointLineVerticalY: Double {
        return templateData.threePointLineVerticalYRation * quarterFieldHeight
    }
    
    /// 三分线底角直线终点Y
    public var threePointLineBottomCornerY: Double {
        return templateData.threePointLineBottomCornerYRatio * quarterFieldHeight
    }

    /// 三分线曲线控制点X
    public var threePointLineCurveControlX: Double {
        return templateData.threePointLineCurveControlXRatio * quarterFieldWidth
    }
    
    /// 掷球点Y
    public var passingLineY: Double {
        return templateData.passingLineYRatio * quarterFieldHeight
    }
    
    /// 内线起点X
    public var interiorLineStartingX: Double {
        return templateData.interiorLineStartingXRation * quarterFieldWidth
    }
    
    /// 内线顶点Y
    public var interiorLineVerticalY: Double {
        return templateData.interiorLineVerticalYRatio * quarterFieldHeight
    }
    
    /// 篮板点X
    public var reboundX: Double {
        return templateData.reboundXRation * quarterFieldWidth
    }
    
    /// 篮板点Y
    public var reboundY: Double {
        return templateData.reboundYRation * quarterFieldHeight
    }
    
    /// 三秒区起点X
    public var threeSecondZoneLineStartingX: Double {
        return templateData.threeSecondZoneLineStartingXRation * quarterFieldWidth
    }
    
    /// 三秒区顶点Y
    public var threeSecondZoneLineVerticalY: Double {
        return templateData.threeSecondZoneLineVerticalYRation * quarterFieldHeight
    }
    
    /// 罚球圈半径
    public var freeThrowCircleRadius: Double {
        /// 占0.7的内线宽
        return 0.7*((1-templateData.interiorLineStartingXRation)*quarterFieldWidth)
    }
    
    /// 篮筐半径
    public var basketRadius: Double {
        return 0.35*(quarterFieldWidth - reboundX)
    }

    public init(fieldData: FieldModels.BasketballFieldModel, fullWidth: CGFloat) {
        self.fieldData = fieldData
        self.fullWidth = fullWidth
    }
}

/// 足球场View Model
public class FootballFieldViewModel: ObservableObject {
    @Published public var fieldData: FieldModels.FootballFieldModel
    @Published public var fullWidth: CGFloat
    
    /// 模版数据
    public var templateData: FieldModels.FootballFieldTemplateModel {
        return fieldData.template
    }
    
    /// 颜色数据
    public var colorsData: FieldModels.FootballFieldColorsModel {
        return fieldData.colors
    }
    
    /// 球场视图总高
    public var fullHeight: CGFloat {
        return fullWidth*templateData.aspectRatio
    }
    
    /// 草地颜色
    public var turfColor: Color {
        return Color(colorsData.turfColor)
    }
    
    /// 草地二级颜色
    public var turfSecondaryColor: Color {
        let colorData = RGBAModel(red: colorsData.turfColor.red*0.8, green: colorsData.turfColor.green*0.8, blue: colorsData.turfColor.blue*0.8)
        return Color(colorData)
    }
    
    /// 主要线条大小
    public var mainLinesWidth: CGFloat {
        return templateData.mainLinesSize.lineWidth
    }
    
    
    /// 球场内部大小
    public var fieldInteriorSize: CGSize {
        return CGSize(width: templateData.fieldInteriorRatio * fullWidth, height: templateData.fieldInteriorRatio * fullHeight)
    }
        
    /// 四分之一球场的宽度
    public var quarterFieldWidth: CGFloat {
        return fullWidth/2
    }
    
    /// 四分之一球场的高度
    public var quarterFieldHeight: CGFloat {
        switch templateData.type {
        case .half:
            return fullHeight
        case .full:
            return fullHeight/2
        }
    }
    
    /// 禁区起点X
    public var penaltyAreaStartingX: CGFloat {
        return templateData.penaltyAreaStartingXRatio * quarterFieldWidth
    }
    
    /// 禁区顶点Y
    public var penaltyAreaVerticalY: CGFloat {
        return templateData.penaltyAreaVerticalYRatio * quarterFieldHeight
    }
    
    /// 大禁区起点X
    public var bigPenaltyAreaStartingX: CGFloat {
        return templateData.bigPenaltyAreaStartingXRatio * quarterFieldWidth
    }
    
    /// 大禁区顶点Y
    public var bigPenaltyAreaVerticalY: CGFloat {
        return templateData.bigPenaltyAreaVerticalYRatio * quarterFieldHeight
    }
    
    /// 圆弧起点
    public var arcStartingPoint: CGPoint {
        return CGPoint(x: templateData.arcStartingXRation * quarterFieldWidth, y: bigPenaltyAreaVerticalY)
    }
    
    /// 圆弧终点
    public var arcEndPoint: CGPoint {
        return CGPoint(x: fullWidth - arcStartingPoint.x, y: bigPenaltyAreaVerticalY)
    }
    
    /// 圆弧预期的控制点Y
    public var arcExpectedControlPointY: CGFloat {
        return templateData.arcControlPointYRation * quarterFieldHeight
    }
    
    /// 圆弧控制点
    public var arcControlPoint: CGPoint {
        return CGPoint.calculateExactControlPoint(startingPoint: arcStartingPoint, endPoint: arcEndPoint, expectedControlPoint: CGPoint(x: quarterFieldWidth, y: arcExpectedControlPointY))
    }
        
    /// 门柱起点X
    public var goalpostStartingX: CGFloat {
        return templateData.goalpostStartingXRation * quarterFieldWidth
    }
    
    /// 门柱顶点Y
    public var goalpostVerticalY: CGFloat {
        return templateData.goalpostVerticalYRation * quarterFieldHeight
    }
    
    /// 点球点Y
    public var penaltyPointY: CGFloat {
        return templateData.penaltyPointYRation * quarterFieldHeight
    }

    public init(fieldData: FieldModels.FootballFieldModel, fullWidth: CGFloat) {
        self.fieldData = fieldData
        self.fullWidth = fullWidth
    }
}

