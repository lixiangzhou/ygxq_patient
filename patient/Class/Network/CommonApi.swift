//
//  CommonApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/20.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum CommonApi: TargetType {
    case unreadMsgCount(uid: Int)
    case pushMsgs(uid: Int)
    case setAllReaded(uid: Int)
    case setReaded(uid: Int)
}

extension CommonApi {
    var path: String {
        switch self {
        case .unreadMsgCount:
            return "/common/pushMsg/unreadCount"
        case .pushMsgs:
            return "/common/getCmnPushMsg/page"
        case .setAllReaded, .setReaded:
            return "/common/pushMsg/updateIsLook"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .unreadMsgCount(uid: uid):
            params["uid"] = uid
        case let .pushMsgs(uid: uid):
            params["clientType"] = uid
            params["pageNum"] = 1
            params["pageSize"] = 1000
            params["uid"] = uid
        case let .setAllReaded(uid: uid):
            params["toUid"] = uid
        case let .setReaded(uid: uid):
            params["id"] = uid
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}