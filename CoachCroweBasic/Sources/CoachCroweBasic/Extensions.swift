import Foundation
import SwiftUI

public extension Color {
    /// 哈希值初始化支持
    init(_ hex: Int, alpha: Double = 1) {
        self.init(
        .sRGB,
          red: Double((hex >> 16) & 0xFF) / 255,
          green: Double((hex >> 8) & 0xFF) / 255,
          blue: Double(hex & 0xFF) / 255,
          opacity: alpha
        )
    }
    
    /// RGBA初始化支持
    init(_ color: RGBAModel) {
        self.init(
            .sRGB,
            red: color.red / 255,
            green: color.green / 255,
            blue: color.blue / 255,
            opacity: color.alpha / 255
        )
    }
    
    /// ColorSelection初始化支持
    init(_ colorSelection: ColorSelection) {
        self = colorSelection.color
    }
}

public extension UIApplication {
    /// 隐藏键盘
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


public extension Binding where Value == String {
    /// String限制
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}

public extension String {
    /// 获取Text尺寸
    func calculateSize(withAttributes attributes: [NSAttributedString.Key: Any]) -> CGSize {
        let textSize = (self as NSString).size(withAttributes: attributes)
        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
    }
}

public extension View {
    /// View转换成UIImage
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

public extension CGPoint {
    /// 通过`起点` `终点` 和 `预期的控制点` 返回一个`准确的控制点`
    static func calculateExactControlPoint(startingPoint: CGPoint, endPoint: CGPoint, expectedControlPoint: CGPoint) -> CGPoint {
        let x = 2 * expectedControlPoint.x - startingPoint.x/2 - endPoint.x/2
        let y = 2 * expectedControlPoint.y - startingPoint.y/2 - endPoint.y/2
        return CGPoint(x: x, y: y)
    }
}
