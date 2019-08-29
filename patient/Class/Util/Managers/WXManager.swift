//
//  WXManager.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/6.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol WXResponseDelegate {
    func managerDidRecvAuthResponse(resp: SendAuthResp)
    func managerDidRecvPayResponse(resp: PayResp)
}

class WXManager: NSObject {
    static let shared = WXManager()
    
    private override init() { }
    
    let appId = "wx786e96c3326738ee"
    let secret = "50205e09e7edda0b9c01a208cb677608"
    private let auth_state = "wx_oauth_authorization_state"
    private var respDelegate: WXResponseDelegate?
    
    let payRespProperty = MutableProperty<PayResp?>(nil)
    let authRespProperty = MutableProperty<SendAuthResp?>(nil)
    
    // MARK: - User
    private let userPath = zz_filePath(with: .documentDirectory, fileName: "wxUser")
    private(set) var user: WXUserModel?
    // MARK: - Token
    private let tokenPath = zz_filePath(with: .documentDirectory, fileName: "wxToken")
    private(set) var token: WXOAuthToken?
}

extension WXManager {
    // MARK: -
    func setup() {
        WXApi.registerApp(appId)
    }
}

extension WXManager: WXResponseDelegate {
    func managerDidRecvAuthResponse(resp: SendAuthResp) {
        print(#function, resp)
    }
    
    func managerDidRecvPayResponse(resp: PayResp) {
        print(#function, resp)
    }
}

extension WXManager: WXApiDelegate {
    func onResp(_ resp: BaseResp) {
        if let response = resp as? SendAuthResp, let _ = response.code, response.state == auth_state {
            respDelegate?.managerDidRecvAuthResponse(resp: response)
            authRespProperty.value = response
        } else if let response = resp as? PayResp {
            respDelegate?.managerDidRecvPayResponse(resp: response)
            payRespProperty.value = response
        }
    }
    
    func handOpenUrl(_ url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
}

// MARK: - WXLogin
extension WXManager {
    //
    func sendAuthReq(from controller: WXResponseDelegate? = nil) {
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = auth_state
        WXApi.send(req)
        
        respDelegate = controller ?? self
    }
    
    func refresnToken() {
        if getCachedToken() != nil {
            AuthApi.wxRefreshToken.response { (result) in
                switch result {
                case let .success(resp):
                    if let json = String(data: resp.data, encoding: .utf8), let oauthToken = WXOAuthToken.deserialize(from: json) {
                        self.save(token: oauthToken)
                    } else {
                        HUD.show(toast: "登录失败")
                    }
                case .failure:
                    HUD.show(toast: "登录失败")
                }
            }
        }
    }
    
    // MARK: - User
    func save(user: WXUserModel) {
        if let jsonString = user.toJSONString() {
            do {
                try jsonString.write(toFile: userPath, atomically: true, encoding: .utf8)
                self.user = user
            } catch {
                self.user = nil
            }
        } else {
            self.user = nil
        }
    }
    
    @discardableResult
    func deleteUser() -> Bool {
        do {
            try FileManager.default.removeItem(atPath: userPath)
            self.user = nil
            return true
        } catch {
            return false
        }
    }
    
    func getCachedUser() -> WXUserModel? {
        if let jsonString = try? String(contentsOfFile: userPath) {
            self.user = WXUserModel.deserialize(from: jsonString)
            return self.user
        } else {
            return nil
        }
    }
    
    func save(token: WXOAuthToken) {
        if let jsonString = token.toJSONString() {
            do {
                try jsonString.write(toFile: tokenPath, atomically: true, encoding: .utf8)
                token.time = Date().timeIntervalSince1970
                self.token = token
            } catch {
                self.token = nil
            }
        } else {
            self.token = nil
        }
    }
    
    @discardableResult
    func deleteToken() -> Bool {
        do {
            try FileManager.default.removeItem(atPath: tokenPath)
            self.token = nil
            return true
        } catch {
            return false
        }
    }
    
    func getCachedToken() -> WXOAuthToken? {
        if let jsonString = try? String(contentsOfFile: tokenPath) {
            self.token = WXOAuthToken.deserialize(from: jsonString)
            return self.token
        } else {
            return nil
        }
    }
}

extension WXManager {
    func sendPayRequest(_ model: WXPayInfoModel, delegate: WXResponseDelegate? = nil) {
        let req = PayReq()
        req.partnerId = model.partnerid
        req.prepayId = model.prepay_id
        req.nonceStr = model.nonce_strs
        req.timeStamp = UInt32(model.timeStamp) ?? 0
        req.sign = model.signStr
        req.package = "Sign=WXPay"
        
        WXApi.send(req)
        
        respDelegate = delegate ?? self
    }
}

class WXOAuthToken: ModelProtocol {
    var refresh_token = ""
    var scope = ""
    var unionid = ""
    var expires_in = 0
    var access_token = ""
    var openid = ""
    
    var time: TimeInterval = 0
    
    required init() {}
}

struct WXUserModel: ModelProtocol {
    var openid = ""
    var city = ""
    var country = ""
    var nickname = ""
    var language = ""
    var headimgurl = ""
    var unionid = ""
    var sex = 0
    var province = ""
}

struct WXPayInfoModel: ModelProtocol {
    var partnerid: String = ""
    var mweb_url: String = ""
    var nonce_strs: String = ""
    var timeStamp: String = ""
    var appId: String = ""
    var prepay_id: String = ""
    var signStr: String = ""
}
