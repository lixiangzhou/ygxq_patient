//
//  MediaApi.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/4.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum MediaApi: TargetType {
    case queryById(pid: Int, type: String, createTime: TimeInterval?)
    case listAllMediasByLinkId(linkId: Int, serType: String, imgType: Int)
}

extension MediaApi {
    
    var path: String {
        switch self {
        case .queryById:
            return "/serMediaMore/querySerMediasByPuid"
        case .listAllMediasByLinkId:
            return "/serMediaMore/listAllMediasByLinkId"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .queryById(pid: pid, type: type, createTime: createTime):
            params["puid"] = pid
            params["serType"] = type
            if let createTime = createTime {
                params["createTime"] = createTime
            }
        case let .listAllMediasByLinkId(linkId: linkId, serType: serType, imgType: imgType):
            params["firstUpload"] = false
            params["imgType"] = imgType
            params["linkId"] = linkId
            params["mediaType"] = "img"
            params["serType"] = serType
        }
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}



