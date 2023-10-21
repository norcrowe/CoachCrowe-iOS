import Foundation
import SwiftUI
import LeanCloud

/// LeanCloud 网络功能服务
public class LCNetworkServices {
    
    /// 发送验证码
    public static func sentVerificationCode(phoneNumber: String, completion: @escaping (MyResult<()>) -> Void) {
        DispatchQueue.global().async {
            LCSMSClient.requestShortMessage(mobilePhoneNumber: phoneNumber, templateName: "", signatureName: "") { (result) in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure:
                    completion(.success(()))
                }
            }
        }
    }
    
    /// 检查用户是否已注册
    public static func checkUserRegistered(phoneNumber: String, completion: @escaping (MyResult<Bool>) -> Void) {
        DispatchQueue.global().async {
            let profileQuery = LCQuery(className: LCProfileClass.className)
            profileQuery.whereKey(LCProfileClass.phoneNumber, .equalTo(phoneNumber))
            profileQuery.find { result in
                switch result {
                case .success(let objects):
                    let registered: Bool = objects.count != 0
                    completion(.success(registered))
                case .failure:
                    completion(.failure)
                }
            }
        }
    }

    /// 验证登录
    public static func login(phoneNumber: String, verificationCode: String, completion: @escaping (MyResult<()>) -> Void) {
        DispatchQueue.global().async {
            /// 检查是否已注册
            self.checkUserRegistered(phoneNumber: phoneNumber) { result in
                switch result {
                case .success(let registered):
                    if !registered {
                        completion(.failure)
                        return
                    }
                    /// 登录
                    LCUser.signUpOrLogIn(mobilePhoneNumber: phoneNumber, verificationCode: verificationCode) { result in
                        switch result {
                        case .success:
                            completion(.success(()))
                        case .failure:
                            completion(.failure)
                        }
                    }
                    
                case .failure:
                    completion(.failure)
                }
            }
        }
    }
    
    
    /// 验证注册
    public static func signup(imageData: Data, name: String, phoneNumber: String, verificationCode: String, completion: @escaping (MyResult<()>) -> Void) {
        DispatchQueue.global().async {
            /// 验证输入的验证码
            LCUser.signUpOrLogIn(mobilePhoneNumber: phoneNumber, verificationCode: verificationCode) { result in
                switch result {
                case .success(let user):
                    /// 检查用户是否已注册
                    self.checkUserRegistered(phoneNumber: phoneNumber) { result in
                        switch result {
                        case .success(let registered):
                            if registered {
                                completion(.failure)
                                return
                            }
                            
                            /// 上传Profile照片
                            let photoFile = LCFile(payload: .data(data: imageData))
                            photoFile.save { result in
                                switch result {
                                case .success:
                                    /// 上传用户Profile数据
                                    let profile = LCObject(className: LCProfileClass.className)
                                    do {
                                        try profile.set(LCProfileClass.name, value: name)
                                        try profile.set(LCProfileClass.user, value: user)
                                        try profile.set(LCProfileClass.phoneNumber, value: phoneNumber)
                                        try profile.set(LCProfileClass.photo, value: photoFile)
                                    } catch {
                                        completion(.failure)
                                        return
                                    }
                                    profile.save { result in
                                        switch result {
                                        case .success:
                                            completion(.success(()))
                                        case .failure:
                                            completion(.failure)
                                        }
                                    }
                                case .failure:
                                    completion(.failure)
                                    return
                                }
                            }
                            
                        case .failure:
                            completion(.failure)
                        }
                    }

                case .failure:
                    completion(.failure)

                }
            }
        }
    }
}
