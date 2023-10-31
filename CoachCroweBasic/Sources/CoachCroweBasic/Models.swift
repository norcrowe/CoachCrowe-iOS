import Foundation

/// `三原色+不透明值`模型
public struct RGBAModel: Codable, Equatable, Hashable {
    public var red: Double
    public var green: Double
    public var blue: Double
    public var alpha: Double
    
    public enum CodingKeys: String, CodingKey {
        case red = "red"
        case green = "green"
        case blue = "blue"
        case alpha = "alpha"
    }
    
    public init(red: Double = 0, green: Double = 0, blue: Double = 0, alpha: Double = 255) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

/// Alert 模型
public struct AlertModel {
    public var showAlert: Bool
    public var title: String
    public var caption: String
    
    public init(showAlert: Bool = false, title: String = "", caption: String = "") {
        self.showAlert = showAlert
        self.title = title
        self.caption = caption
    }
}

/// 战术模型集
public class TacticModels {
    /// 坐标模型
     public struct Point: Codable, Equatable {
        public var x: CGFloat
        public var y: CGFloat
        

        public enum CodingKeys: String, CodingKey {
            case x = "x"
            case y = "y"
        }
        
        public init(x: CGFloat, y: CGFloat) {
            self.x = x
            self.y = y
        }
    }

    /// 球员线条模型
    public struct PlayerLineModel: Codable, Equatable {
        public var styleRaw: Int
        public var markRaw: Int
        public var sizeRaw: Int
        public var color: RGBAModel
        public var dotted: Bool
        
        public enum CodingKeys: String, CodingKey {
            case styleRaw = "styleRaw"
            case markRaw = "markRaw"
            case sizeRaw = "sizeRaw"
            case color = "color"
            case dotted = "dotted"
        }
        
        public init(styleRaw: Int, markRaw: Int, sizeRaw: Int, color: RGBAModel, dotted: Bool) {
            self.styleRaw = styleRaw
            self.markRaw = markRaw
            self.sizeRaw = sizeRaw
            self.color = color
            self.dotted = dotted
        }
    }

    /// 单个球员步骤模型
    public struct SinglePlayerStepModel: Codable, Equatable {
        public var points: [Point]
        public var lineModel: PlayerLineModel
        
        public init(points: [Point], lineModel: PlayerLineModel) {
            self.points = points
            self.lineModel = lineModel
        }
    }

    /// 单个球员数据模型
    public struct SinglePlayerModel: Codable, Equatable {
        public var index: Int
        public var number: String
        public var name: String
        public var imageData: Data?
        public var steps: [SinglePlayerStepModel]
        
        public init(index: Int, number: String, name: String, imageData: Data?, steps: [SinglePlayerStepModel]) {
            self.index = index
            self.number = number
            self.name = name
            self.imageData = imageData
            self.steps = steps
        }
    }


    /// 步骤式战术模型 `SBS` = `Step By Step`
    struct SBSTacticModel: Codable, Equatable {
        public var name: String
        public var playersData: [SinglePlayerModel]
        public var ballData: SinglePlayerModel
        public var aPlayersColor: RGBAModel
        public var bPlayersColor: RGBAModel
        public var aPlayersDescriptionColor: RGBAModel
        public var bPlayersDescriptionColor: RGBAModel
        public var details: [String]
    }
}

/// 球场模型集
public class FieldModels {
    /// 篮球球场模版模型
    public struct BasketballFieldTemplateModel: Codable {
        public var type: FieldType
        public var mainLinesSize: UniversalSize
        public var aspectRatio: Double
        public var fieldInteriorRatio: Double /// 球场内部占比
        public var threePointLineStartingXRatio: Double //三分线的起点X 在1/4球场width中的占比
        public var threePointLineVerticalYRation: Double // 三分线的顶点Y 在1/4球场height中的占比
        public var threePointLineBottomCornerYRatio: Double //三分线的底角线段Y 在1/4球场height中的占比
        public var threePointLineCurveControlXRatio: Double
        public var passingLineYRatio: Double
        public var interiorLineStartingXRation: Double
        public var interiorLineVerticalYRatio: Double
        public var reboundXRation: Double
        public var reboundYRation: Double
        public var threeSecondZoneLineStartingXRation: Double
        public var threeSecondZoneLineVerticalYRation: Double
        
        
        public init(type: FieldType, mainLinesSize: UniversalSize, aspectRatio: Double, fieldInteriorRatio: Double, threePointLineStartingXRatio: Double, threePointLineVerticalYRation: Double, threePointLineBottomCornerYRatio: Double, threePointLineCurveControlXRatio: Double, passingLineYRatio: Double, interiorLineStartingXRation: Double, interiorLineVerticalYRatio: Double, reboundXRation: Double, reboundYRation: Double, threeSecondZoneLineStartingXRation: Double, threeSecondZoneLineVerticalYRation: Double) {
            self.type = type
            self.mainLinesSize = mainLinesSize
            self.aspectRatio = aspectRatio
            self.fieldInteriorRatio = fieldInteriorRatio
            self.threePointLineStartingXRatio = threePointLineStartingXRatio
            self.threePointLineVerticalYRation = threePointLineVerticalYRation
            self.threePointLineBottomCornerYRatio = threePointLineBottomCornerYRatio
            self.threePointLineCurveControlXRatio = threePointLineCurveControlXRatio
            self.passingLineYRatio = passingLineYRatio
            self.interiorLineStartingXRation = interiorLineStartingXRation
            self.interiorLineVerticalYRatio = interiorLineVerticalYRatio
            self.reboundXRation = reboundXRation
            self.reboundYRation = reboundYRation
            self.threeSecondZoneLineStartingXRation = threeSecondZoneLineStartingXRation
            self.threeSecondZoneLineVerticalYRation = threeSecondZoneLineVerticalYRation
        }
    }

    /// 篮球球场颜色模型
    public struct BasketballFieldColorsModel: Codable {
        public var mainLinesColor: RGBAModel
        public var interiorFillColor: RGBAModel  //球场内填充色
        public var threePointLineInteriontFillColor: RGBAModel //三分线内的颜色(包括中场logo填充色)
        public var interiorLineFillColor: RGBAModel //内线填充色 (外场填充色 = 70% self)
        
        public init(mainLinesColor: RGBAModel, interiorFillColor: RGBAModel, threePointLineInteriontFillColor: RGBAModel, interiorLineFillColor: RGBAModel) {
            self.mainLinesColor = mainLinesColor
            self.interiorFillColor = interiorFillColor
            self.threePointLineInteriontFillColor = threePointLineInteriontFillColor
            self.interiorLineFillColor = interiorLineFillColor
        }
    }

    /// 篮球球场模型
    public struct BasketballFieldModel: Codable {
        public var template: BasketballFieldTemplateModel
        public var colors: BasketballFieldColorsModel
        
        public init(template: BasketballFieldTemplateModel, colors: BasketballFieldColorsModel) {
            self.template = template
            self.colors = colors
        }
    }
    
    /// 足球球场模版模型
    public struct FootballFieldTemplateModel: Codable {
        public var type: FieldType
        public var mainLinesSize: UniversalSize
        public var aspectRatio: Double
        public var fieldInteriorRatio: Double

        public var penaltyAreaStartingXRatio: Double
        public var penaltyAreaVerticalYRatio: Double
        
        public var bigPenaltyAreaStartingXRatio: Double
        public var bigPenaltyAreaVerticalYRatio: Double
        
        public var arcStartingXRation: Double
        public var arcControlPointYRation: Double
        
        public var goalpostStartingXRation: Double
        public var goalpostVerticalYRation: Double
        
        public var penaltyPointYRation: Double
        
        public init(type: FieldType, mainLinesSize: UniversalSize, aspectRatio: Double, fieldInteriorRatio: Double, penaltyAreaStartingXRatio: Double, penaltyAreaVerticalYRatio: Double, bigPenaltyAreaStartingXRatio: Double, bigPenaltyAreaVerticalYRatio: Double, arcXRation: Double, arcControlPointYRation: Double, goalpostStartingXRation: Double, goalpostVerticalYRation: Double, penaltyPointY: Double) {
            self.type = type
            self.mainLinesSize = mainLinesSize
            self.aspectRatio = aspectRatio
            self.fieldInteriorRatio = fieldInteriorRatio
            self.penaltyAreaStartingXRatio = penaltyAreaStartingXRatio
            self.penaltyAreaVerticalYRatio = penaltyAreaVerticalYRatio
            self.bigPenaltyAreaStartingXRatio = bigPenaltyAreaStartingXRatio
            self.bigPenaltyAreaVerticalYRatio = bigPenaltyAreaVerticalYRatio
            self.arcStartingXRation = arcXRation
            self.arcControlPointYRation = arcControlPointYRation
            self.goalpostStartingXRation = goalpostStartingXRation
            self.goalpostVerticalYRation = goalpostVerticalYRation
            self.penaltyPointYRation = penaltyPointY
        }
    }
    
    /// 足球球场颜色模型
    public struct FootballFieldColorsModel: Codable {
        public var mainLinesColor: RGBAModel
        public var turfColor: RGBAModel
        
        public init(mainLinesColor: RGBAModel, turfColor: RGBAModel) {
            self.mainLinesColor = mainLinesColor
            self.turfColor = turfColor
        }
    }
    
    /// 足球球场模型
    public struct FootballFieldModel: Codable {
        public var template: FootballFieldTemplateModel
        public var colors: FootballFieldColorsModel
        
        public init(template: FootballFieldTemplateModel, colors: FootballFieldColorsModel) {
            self.template = template
            self.colors = colors
        }
    }
}

