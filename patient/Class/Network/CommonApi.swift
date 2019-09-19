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
    case pushMsgs(uid: Int, type: String?)
    case setAllReaded(uid: Int)
    case setReaded(uid: Int)
    case updateTaskState(id: Int)
    case videoExamAndPics(linkId: Int, puid: Int)
    case getFinishTaskMsgInfos(linkId: Int, puid: Int)
}

extension CommonApi {
    var path: String {
        switch self {
        case .unreadMsgCount:
            return "/common/pushMsg/unreadCount"
        case .pushMsgs:
            return "/common/getCmnPushMsg/page"
        case .setAllReaded, .setReaded, .updateTaskState:
            return "/common/pushMsg/updateIsLook"
        case .videoExamAndPics:
            return "/pushMsg/getVideoFinishTaskMsgInfos"
        case .getFinishTaskMsgInfos:
            return "/pushMsg/getFinishTaskMsgInfos"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .unreadMsgCount(uid: uid):
            params["uid"] = uid
        case let .pushMsgs(uid: uid, type: type):
            params["clientType"] = "PT"
            params["pageNum"] = 1
            params["pageSize"] = 1000
            params["uid"] = uid
            if let type = type {
                params["type"] = type
            }
        case let .setAllReaded(uid: uid):
            params["toUid"] = uid
        case let .setReaded(uid: uid):
            params["id"] = uid
        case let .updateTaskState(id: id):
            params["id"] = id
        case let .videoExamAndPics(linkId: linkId, puid: pid):
            params["linkId"] = linkId
            params["toUid"] = pid
        case let .getFinishTaskMsgInfos(linkId: linkId, puid: pid):
            params["linkId"] = linkId
            params["toUid"] = pid
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
