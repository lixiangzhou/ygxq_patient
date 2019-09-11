//
//  AddressApi.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/2.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

enum AddressApi: TargetType {
    case list(uid: Int)
    case add(id: Int, uid: Int, name: String, mobile: String, districtId: Int, district: String, address: String, isDefault: Bool)
    case update(id: Int, uid: Int, name: String, mobile: String, districtId: Int, district: String, address: String, isDefault: Bool)
    case delete(id: Int)
    case provinces
    case areasByFid(id: Int)
    case payDeaultAddress(pid: Int)
}

extension AddressApi {
    var path: String {
        switch self {
        case .list:
            return "/payAddressManage/queryList"
        case .add:
            return "/payAddressManage/add"
        case .update:
            return "/payAddressManage/update"
        case .delete:
            return "/payAddressManage/delete"
        case .provinces:
            return "/common/getProviceList"
        case .areasByFid:
            return "/common/getareaListByFid"
        case .payDeaultAddress:
            return "/payAddressManage/queryDefault"
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        switch self {
        case let .list(uid: uid):
            params["puid"] = uid
        case let .add(id: id, uid: uid, name: name, mobile: mobile, districtId: districtId, district: district, address: address, isDefault: isDefault):
            params["uid"] = uid
            params["mobile"] = mobile
            params["consignee"] = name
            params["address"] = address
            params["cmnDistrictId"] = districtId
            params["district"] = district
            params["isDefault"] = isDefault
            params["id"] = id
        case let .update(id: id, uid: uid, name: name, mobile: mobile, districtId: districtId, district: district, address: address, isDefault: isDefault):
            params["uid"] = uid
            params["mobile"] = mobile
            params["consignee"] = name
            params["address"] = address
            params["cmnDistrictId"] = districtId
            params["district"] = district
            params["isDefault"] = isDefault
            params["id"] = id
        case let .delete(id: id):
            params["id"] = id
        case .provinces:
            break
        case let .areasByFid(id: id):
            params["id"] = id
        case let .payDeaultAddress(pid: pid):
            params["puid"] = pid
        }
        
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
