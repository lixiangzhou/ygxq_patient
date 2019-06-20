//
//  RCManager.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/11.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation

class RCManager: NSObject {
    static let shared = RCManager()
    
    private override init() {
        super.init()
        rcModels = getCachedRCModels()
    }
    
    func setup() {
        RCIM.shared().initWithAppKey(key)
        RCIM.shared()?.userInfoDataSource = self
    }
    
    // MARK: - Property
    private var key: String {
        switch enviroment {
        case .release:
            return "8w7jv4qb83aey"
        case .test:
            return "uwd1c0sxuqql1"
        case .develop:
            return "x18ywvqfxcclc"
        }
    }
    
    private var isLogin: Bool {
        return PatientManager.shared.isLogin && patientId > 0
    }
    
    private var userId: String {
        return patientId.description
    }
    
    private let rcModelsPath = zz_filePath(with: .documentDirectory, fileName: "rcModels")
    private var rcModels: [RCModel]!
}

// MARK: - 连接
extension RCManager {
    /// 1. 通过 getRCModel 获取token；2.连接融云；3.失败时刷新token并重连
    func connect(_ completion: ((Bool) -> Void)? = nil) {
        if isLogin {
            print("==>RC连接 获取Token")
            getRCModel { (model) in
                if let model = model {
                    self.save(model)
                    print("==>RC连接 获取Token成功")
                    print("==>RC连接 ...")
                    RCIM.shared()?.connect(withToken: model.rcToken, success: { (rcId) in
                        if rcId != nil {
                            print("==>RC连接 成功")
                            completion?(true)
                        } else {
                            print("==>RC连接 失败")
                            self.reConnect(completion)
                        }
                    }, error: { (errorCode) in
                        print("==>RC连接 失败：RCConnectErrorCode \(errorCode.rawValue)")
                        if errorCode == .CONN_TOKEN_INCORRECT {
                            self.reConnect(completion)
                        }
                    }, tokenIncorrect: {
                        print("==>RC连接 失败: tokenIncorrect")
                        self.reConnect(completion)
                    })
                } else {
                    print("==>RC连接 获取Token失败")
                    self.reConnect(completion)
                }
            }
        } else {
            print("==>RC连接 未登录")
            completion?(false)
        }
    }
    
    /// 刷新token 并重连
    private func reConnect(_ completion: ((Bool) -> Void)? = nil) {
        print("==>重新获取Token")
        if isLogin {
            UserApi.createRCToken(userId: userId).responseModel(RCModel.self) { (rcModel) in
                if let model = rcModel {
                    self.save(model)
                    print("==>重新连接RC ...")
                    RCIM.shared()?.connect(withToken: model.rcToken, success: { (rcId) in
                        if rcId != nil {
                            print("==>重新连接RC 成功")
                            completion?(true)
                        } else {
                            print("==>重新连接RC 失败")
                            completion?(false)
                        }
                    }, error: { (errorCode) in
                        print("==>重新连接RC 失败：RCConnectErrorCode \(errorCode.rawValue)")
                        completion?(false)
                    }, tokenIncorrect: {
                        print("==>重新连接RC 失败: tokenIncorrect")
                        completion?(false)
                    })
                }
            }
        } else {
            print("==>重新获取Token 未登录")
            completion?(false)
        }
    }
}

// MARK: - Token
extension RCManager {
    /// 获取TokenModel：1.本地获取token；2.服务器获取token；3.服务器刷新token
    private func getRCModel(completion: @escaping (RCModel?) -> Void) {
        if isLogin {
            if let model = getCachedRCModel() { // 获取本地缓存的TokenModel
                completion(model)
            } else {    // 服务器请求TokenModel
                UserApi.getRCToken(userId: userId).responseModel(RCModel.self) { (rcModel) in
                    if rcModel == nil {
                        // Token 错误，在线上环境下主要是因为 Token 已经过期，您需要向 App Server 重新请求一个新的 Token
                        UserApi.createRCToken(userId: self.userId).responseModel(RCModel.self) { (rcModel) in
                            completion(rcModel)
                        }
                    } else {
                        completion(rcModel)
                    }
                }
            }
        }
    }
}

// MARK: - UserInfo
extension RCManager {
    private func setUserInfo() {
        if isLogin {
            if let patientModel = PatientManager.shared.patientInfoModel {
                RCIM.shared()?.currentUserInfo = RCUserInfo(userId: patientModel.id.description, name: patientModel.realName, portrait: "")
            }
        }
    }
}

// MARK: - 融云本地用户管理相关
extension RCManager {
    /// 获取当前登录用户的 TokenModel
    private func getCachedRCModel() -> RCModel? {
        return getCachedRCModel(userId: userId)
    }
    
    /// 获取指定用户的 TokenModel
    private func getCachedRCModel(userId: String) -> RCModel? {
        return getCachedRCModel(rcId: "RC_\(userId)")
    }
    
    private func getCachedRCModel(rcId: String) -> RCModel? {
        for model in rcModels {
            if model.rcId == rcId {
                return model
            }
        }
        return nil
    }
    
    private func removeCachedRCModel(_ rcModel: RCModel) {
        rcModels.removeAll { (model) -> Bool in
            return model.rcId == rcModel.rcId
        }
    }
    
    private func removeCachedRCModel(rcId: String) {
        rcModels.removeAll { (rcModel) -> Bool in
            return rcModel.rcId == rcId
        }
    }
    
    private func removeCachedRCModel(userId: String) {
        removeCachedRCModel(rcId: "RC_\(userId)")
    }
    
    /// 保存 TokenModel
    private func save(_ rcModel: RCModel) {
        if rcModel.rcId.count > 0 && rcModel.rcToken.count > 0 {
            removeCachedRCModel(rcModel)
            rcModels.append(rcModel)
            saveAll()
        }
    }
    
    private func getCachedRCModels() -> [RCModel] {
        if let rcModelsString = try? String(contentsOfFile: rcModelsPath), let rcModels = [RCModel].deserialize(from: rcModelsString) as? [RCModel] {
            return rcModels
        } else {
            try! rcModels.tojson().toJSONString()?.write(toFile: rcModelsPath, atomically: true, encoding: .utf8)
            return rcModels
        }
    }
    
    private func saveAll() {
        try? rcModels.tojson().toJSONString()?.write(toFile: rcModelsPath, atomically: true, encoding: .utf8)
    }
}

// MARK: - RCIMUserInfoDataSource
extension RCManager: RCIMUserInfoDataSource {
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        DoctorApi.doctorInfo(duid: userId.replacingOccurrences(of: "RC_", with: "")).responseModel(DoctorInfoModel.self) { (model) in
            let user = RCUserInfo()
            user.userId = userId
            user.name = model?.realName
            user.portraitUri = model?.imgUrl
            completion(user)
        }
    }
}

// MARK: - RCCallSessionDelegate
extension RCManager: RCCallSessionDelegate {
    func callDidConnect() {
        print(#function)
    }
    
    func callDidDisconnect() {
        print(#function)
    }
}

// MARK: - RCCallReceiveDelegate
extension RCManager: RCCallReceiveDelegate {
    func didReceiveCall(_ callSession: RCCallSession!) {
        print(#function)
        callSession.setDelegate(self)
        callSession.accept(.video)
    }
    
    func didReceiveCallRemoteNotification(_ callId: String!, inviterUserId: String!, mediaType: RCCallMediaType, userIdList: [Any]!, userDict: [AnyHashable : Any]!) {
        print(#function)
    }
    
    func didCancelCallRemoteNotification(_ callId: String!, inviterUserId: String!, mediaType: RCCallMediaType, userIdList: [Any]!) {
        print(#function)
    }
}

/// TokenModel
struct RCModel: ModelProtocol {
    var rcToken = ""
    var rcId = ""
}
