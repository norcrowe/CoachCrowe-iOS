import Foundation
import CoachCroweBasic
import UIKit
import LeanCloud
import SwiftUI

/// 主视图 View Model
public class MasterViewModel: ObservableObject {
    @Published public var viewState: MasterViewState = .library
    @Published public var selectedSelection: [MasterViewState] = [.library]
    @Published public var initializationState: InitializationState? = .initializing
    
    public init() {
        DispatchQueue.global().asyncAfter(deadline: .now()+1) {
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
                    /// 发现必须升级的版本
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
    @Published public var viewState: LoginViewState = .inputPhoneNumber
    @Published public var showImagePicker: Bool = false
    @Published public var showCropView: Bool = false
    @Published public var image: UIImage? = nil
    @Published public var region: Region = .china
    @Published public var phoneNumber: String = ""
    @Published public var name: String = ""
    @Published public var verificationCode: String = ""
    @Published public var hudState: HudState? = nil
    @Published public var alert: AlertModel = .init()
    public var fullPhoneNumber: String {
        self.region.number + self.phoneNumber
    }
    
    public init() {}
    
    /// 发送验证码
    public func sentVerificationCode() {
        withAnimation(.spring) {
            hudState = .progress
        }
        LCNetworkServices.sentVerificationCode(phoneNumber: self.fullPhoneNumber) { result in
            switch result {
            case .success:
                /// 判断用户是否已注册
                DispatchQueue.main.async {
                    LCNetworkServices.checkUserRegistered(phoneNumber: self.fullPhoneNumber) { result in
                        switch result {
                        case .success(let registered):
                            DispatchQueue.main.async {
                                withAnimation(.spring) {
                                    self.hudState = nil
                                    UIApplication.shared.endEditing()
                                    self.viewState = registered ? .inputVerificationCode : .signup
                                }
                            }
                        case .failure:
                            DispatchQueue.main.async {
                                withAnimation(.spring) {
                                    self.hudState = .completed(.failed, "Send failed")
                                }
                            }
                        }
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    withAnimation(.spring) {
                        self.hudState = .completed(.failed, "Send failed")
                    }
                }
            }
        }
    }
    
    /// 登录
    public func login(completion: @escaping () -> Void) {
        withAnimation(.spring) {
            self.hudState = .progress
        }
        
        LCNetworkServices.login(phoneNumber: self.fullPhoneNumber, verificationCode: verificationCode) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    withAnimation(.spring) {
                        self.hudState = nil
                        UIApplication.shared.endEditing()
                    }
                    completion()
                }
            case .failure:
                DispatchQueue.main.async {
                    withAnimation(.spring) {
                        self.hudState = .completed(.failed, "Verification failed")
                    }
                }
            }
        }
    }
    
    /// 注册
    public func signup(completion: @escaping () -> Void) {
        withAnimation(.spring) {
            self.hudState = .progress
        }
        
        guard let imageData = ImageView(image: self.image!, size: CGSize(width: 512, height: 512)).snapshot().pngData() else {
            self.hudState = .completed(.failed, "Signup failed")
            return
        }
        
        LCNetworkServices.signup(imageData: imageData, name: self.name, phoneNumber: fullPhoneNumber, verificationCode: self.verificationCode) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    withAnimation(.spring) {
                        self.hudState = .completed(.successed, "Signup successed")
                    }
                    completion()
                }
            case .failure:
                DispatchQueue.main.async {
                    withAnimation(.spring) {
                        self.hudState = .completed(.failed, "Signup failed")
                    }
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
