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
