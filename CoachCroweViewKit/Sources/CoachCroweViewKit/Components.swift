import Foundation
import SwiftUI
import CoachCroweBasic
import PhotosUI
import SDWebImageSwiftUI

/// 登录界面 TextField
public struct LoginTextField<Content: View>: View {
    var sfSymbolName: String
    var content: () -> Content
    
    public init(sfSymbolName: String, content: @escaping () -> Content) {
        self.sfSymbolName = sfSymbolName
        self.content = content
    }
    
    /// body
    public var body: some View {
        HStack(spacing: 5) {
            Image(systemName: sfSymbolName)
                .foregroundColor(Color(ColorSelection.primary))
                .font(.title3.bold())
                .padding(5)
                .frame(width: MemberSizes.controlHeight, height: MemberSizes.controlHeight)
                .roundedGlassEffectBackground(radius: 7.5, .secondary)
            content()
        }
        .padding(7.5)
        .roundedColorBackground(color: Color(ColorSelection.gray), radius: 15)
    }
}

/// Image Picker
public struct ImagePicker: UIViewControllerRepresentable {
    public typealias UIViewControllerType = PHPickerViewController

    @Environment(\.presentationMode) private var presentationMode
    @Binding public var selectedImage: UIImage?

    public init(selectedImage: Binding<UIImage?>) {
        _selectedImage = selectedImage
    }
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator

        return picker
    }

    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final public class Coordinator: PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()

            guard let result = results.first else {
                return
            }

            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let error = error {
                    fatalError("Image load failed: \(error.localizedDescription)")
                } else if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image
                    }
                }
            }
        }
    }
}

/// 毛玻璃效果
struct GlassEffect: UIViewRepresentable {
    public var style: UIBlurEffect.Style
    
    public func makeUIView(context: Context) ->  UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
    
    public init(style: UIBlurEffect.Style) {
        self.style = style
    }
}
