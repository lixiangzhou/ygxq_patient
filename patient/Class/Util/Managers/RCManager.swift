//
//  RCManager.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/11.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import CoreTelephony

class RCManager: NSObject {
    static let shared = RCManager()
    static let SECONDS = 30 * 60
    private override init() {
        super.init()
        rcModels = getCachedRCModels()
    }
    
    func setup() {
        RCIM.shared().initWithAppKey(key)
        RCIM.shared()?.receiveMessageDelegate = self
        
        
        RCIM.shared()?.userInfoDataSource = self
        RCIMClient.shared()?.logLevel = .log_Level_Info
        
        addFloatingBoardHook()
        addVideoHook()
        addCallVCHook()
        
        setLog()
        
        setUserInfo()
        
        callCenter.callEventHandler = { call in
            if call.callState == CTCallStateConnected {
                let vc = (UIApplication.shared.keyWindow?.rootViewController as? RCCallBaseViewController)
                vc?.hangupButtonClicked()
            }
        }
    }
    
    // MARK: - Property
    var key: String {
        switch context {
        case .release:
            return "8w7jv4qb83aey"
        case .test:
            return "uwd1c0sxuqql1"
        case .develop:
//            return "x18ywvqfxcclc"
            return "k51hidwqk4anb" // 3.0 引擎  对应的secret(服务端使用)：9AVKP0469gk23N
        }
    }
    
    private var isLogin: Bool {
        return PatientManager.shared.isLogin && patientId > 0
    }
    
    private var userId: String {
        return patientId.description
    }
    
    private let rcModelsPath = zz_filePath(with: .documentDirectory, fileName: "rcModels")
    private var rcModels = [RCModel]()
    
    
    var leftSeconds: Int = 1800
    var leftSecondLabel = UILabel(text: "30", font: .size(15), textColor: .white)
    var timer: Timer?
    var callSession: RCCallSession?
    var callFloatBoard: RCCallFloatingBoard?
    var callCenter = CTCallCenter()
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
                    }) {
                        print("==>RC连接 失败: tokenIncorrect")
                        self.reConnect(completion)
                    }
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
                } else {
                    print("==>重新获取Token 失败")
                    completion?(false)
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

extension RCManager {
    private func addFloatingBoardHook() {
        let connectClosure: @convention(block) (AspectInfo)-> Void = { [weak self] aspectInfo in
            self?.callSession = (aspectInfo.instance() as? RCCallFloatingBoard)?.callSession
            
            self?.startTimer()
            NotificationCenter.default.post(name: .init("callDidConnect"), object: (aspectInfo.instance() as? RCCallFloatingBoard)?.callSession)
        }
        _ = try? RCCallBaseViewController.aspect_hook(NSSelectorFromString("callDidConnect"), with: [], usingBlock: connectClosure)
        
        let disConnectClosure: @convention(block) (AspectInfo)-> Void = { [weak self] aspectInfo in
            self?.callSession = nil
            NotificationCenter.default.post(name: .init("callDidDisconnect"), object: (aspectInfo.instance() as? RCCallFloatingBoard)?.callSession)
        }
        _ = try? RCCallFloatingBoard.aspect_hook(NSSelectorFromString("callDidDisconnect"), with: [], usingBlock: disConnectClosure)
        
        let startClosure: @convention(block) (AspectInfo)-> Void = { [weak self] aspectInfo in
            self?.callFloatBoard = aspectInfo.instance() as? RCCallFloatingBoard
        }
        _ = try? RCCallFloatingBoard.aspect_hook(NSSelectorFromString("initBoard"), with: [], usingBlock: startClosure)
        
        let stopClosure: @convention(block) (AspectInfo)-> Void = { [weak self] aspectInfo in
            self?.callFloatBoard = nil
            
        }
        _ = try? RCCallFloatingBoard.aspect_hook(NSSelectorFromString("clearCallFloatingBoard"), with: [], usingBlock: stopClosure)
    }
    
    private func addVideoHook() {
        let connectClosure: @convention(block) (AspectInfo)-> Void = { [weak self] aspectInfo in
            self?.callSession = (aspectInfo.instance() as? RCCallBaseViewController)?.callSession
            
            self?.startTimer()
            NotificationCenter.default.post(name: .init("callDidConnect"), object: (aspectInfo.instance() as? RCCallBaseViewController)?.callSession)
        }
        _ = try? RCCallBaseViewController.aspect_hook(NSSelectorFromString("callDidConnect"), with: [], usingBlock: connectClosure)
        
        let disConnectClosure: @convention(block) (AspectInfo)-> Void = { [weak self] aspectInfo in
            self?.callSession = nil
            NotificationCenter.default.post(name: .init("callDidDisconnect"), object: (aspectInfo.instance() as? RCCallBaseViewController)?.callSession)
        }
        _ = try? RCCallBaseViewController.aspect_hook(NSSelectorFromString("callDidDisconnect"), with: [], usingBlock: disConnectClosure)
    }
    
    private func addCallVCHook() {
        let viewDidLoad: @convention(block) (AspectInfo)-> Void = { aspectInfo in
            (aspectInfo.instance() as? RCCallBaseViewController)?.cameraCloseButton.alpha = 0
        }
        _ = try? RCCallBaseViewController.aspect_hook(NSSelectorFromString("viewDidLoad"), with: [], usingBlock: viewDidLoad)
    }
    
    
    func startTimer() {
        stopTimer()
        timer = Timer(timeInterval: 1, target: self, selector: #selector(run), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func run() {
        guard let session = callSession else { return }
        let runSecond = Date().timeIntervalSince1970 - TimeInterval(session.connectedTime / 1000)
        let left = leftSeconds - Int(runSecond)
        print(runSecond, leftSeconds, Date().timeIntervalSince1970, session.connectedTime, left)
        
        if left <= 30 {
            leftSecondLabel.text = "还剩\(left)秒"
            
            if let timeLabel = (UIApplication.shared.keyWindow?.rootViewController as? RCCallBaseViewController)?.timeLabel {
                timeLabel.addSubview(leftSecondLabel)
                leftSecondLabel.snp.makeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.top.equalTo(timeLabel.snp.bottom).offset(20)
                }
            }
            
            if left <= 0 {
                let vc = (UIApplication.shared.keyWindow?.rootViewController as? RCCallBaseViewController)
                vc?.hangupButtonClicked()
                if let callFloatBoard = callFloatBoard {
                    callFloatBoard.callSession.hangup()
                    callFloatBoard.perform(NSSelectorFromString("callDidDisconnect"))
                }
            }
        }
    }
}

// MARK: - UserInfo
extension RCManager {
    private func setUserInfo() {
        PatientManager.shared.getPatientInfo()
        patientInfoProperty.producer.skipNil().startWithValues { (model) in
            let userInfo = RCUserInfo()
            userInfo.name = model.realName
            userInfo.portraitUri = model.imgUrl
            userInfo.userId = "RC_\(model.id)"
            RCIMClient.shared()?.currentUserInfo = userInfo
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
        removeCachedRCModel(rcId: rcModel.rcId)
    }
    
    private func removeCachedRCModel(userId: String) {
        removeCachedRCModel(rcId: "RC_\(userId)")
    }
    
    private func removeCachedRCModel(rcId: String) {
        rcModels.removeAll { (rcModel) -> Bool in
            return rcModel.rcId == rcId
        }
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

extension RCManager {
    private func setLog() {
        if context == .develop {
            return
        }
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "MMddHHmmss"
        let fileName = "rc" + df.string(from: date) + ".log"
        let logFilePath = path + "/" + fileName
        
        freopen(logFilePath.cString(using: .ascii), "a+", stdout)
        freopen(logFilePath.cString(using: .ascii), "a+", stderr)
    }
    
    private func getLog() {
        let doc = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        if let paths = try? FileManager.default.contentsOfDirectory(atPath: doc) {
            var result = ""
            
            for path in paths {
                if path.hasPrefix("rc") && path.hasSuffix(".log") {
                    if let content = try? String(contentsOfFile: doc + "/" + path) {
                        result.append(content)
                        print(content)
                    }
                }
            }
        }
    }
}

// MARK: - RCIMUserInfoDataSource
extension RCManager: RCIMUserInfoDataSource {
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        DoctorApi.doctorInfo(duid: Int(userId.replacingOccurrences(of: "RC_", with: "")) ?? 0).responseModel(DoctorInfoModel.self) { (model) in
            let user = RCUserInfo()
            user.userId = userId
            user.name = model?.realName
            user.portraitUri = model?.imgUrl
            completion(user)
        }
    }
}

extension RCManager: RCIMReceiveMessageDelegate {
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        if let txt = (message.content as? RCTextMessage)?.content, let time = Int(txt), time > 0 {
            print("TIME: =>", time)
            leftSeconds = time
        }
    }
}

/// TokenModel
struct RCModel: ModelProtocol {
    var rcToken = ""
    var rcId = ""
}

