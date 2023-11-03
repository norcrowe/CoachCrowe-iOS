import Foundation
import SwiftUI
import LeanCloud

/// LeanCloud 网络功能服务
public class LCNetworkServices {
    
    /// 密码账号注册
    public static func passwordSignup(id: String, password: String, imageData: Data, completion: @escaping(MyResult<()>) -> Void) {
        DispatchQueue.global().async {
            let user = LCUser()
            user.username = LCString(id)
            user.password = LCString(password)
            
            user.signUp { result in
                switch result {
                case .success:
                    /// 上传Profile
                    let photoFile = LCFile(payload: .data(data: imageData))
                    photoFile.save { result in
                        switch result {
                        case .success:
                            /// 上传用户Profile数据
                            let profile = LCObject(className: LCProfileClass.className)
                            do {
                                try profile.set(LCProfileClass.id, value: id)
                                try profile.set(LCProfileClass.user, value: user)
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
        }
    }
    
    /// 密码账号登录
    public static func passwordLogin(id: String, password: String, completion: @escaping(MyResult<()>) -> Void) {
        DispatchQueue.global().async {
            LCUser.logIn(username: id, password: password) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure:
                    completion(.failure)
                }
            }
        }
    }
    
    /// 检查ID是否已注册
    public static func checkUserRegistered(id: String, completion: @escaping (MyResult<Bool>) -> Void) {
        DispatchQueue.global().async {
            let profileQuery = LCQuery(className: LCProfileClass.className)
            profileQuery.whereKey(LCProfileClass.id, .equalTo(id))
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
}
