//
//  HutPackageDetailViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/10.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HutPackageDetailViewModel: BaseViewModel {
    let hutModelProperty = MutableProperty<SunShineHutModel?>(nil)
    
    let dataSourceProperty = MutableProperty<[RowModel]>([])
    
    let addressModelProperty = MutableProperty<AddressModel?>(nil)
    
    override init() {
        super.init()
        
        hutModelProperty.producer.skipNil().startWithValues { [weak self] (model) in
            var dataSource = [RowModel]()
            dataSource.append(.outline(name: model.serName, time: model.indate.description, feature: model.serFeatures))
            
            var detailString = ""
            for (idx, detail) in model.serDetailList.enumerated() {
                detailString += "\(idx + 1).\(detail)"
                if idx < model.serDetailList.count - 1 {
                    detailString += "\n"
                }
            }
            dataSource.append(.content(contents: model.serContentList, detail: detailString, pic: model.equipmentImg))
            
            var audienceList = [TargetAudienceModel]()
            for item in model.targetAudiencList {
                let data = item.split(separator: ";").map { String($0) }
                if data.count == 1 {
                    audienceList.append(TargetAudienceModel(pic: data[0], title: ""))
                } else if data.count == 2 {
                    audienceList.append(TargetAudienceModel(pic: data[0], title: data[1]))
                }
            }
            dataSource.append(.targetAudience(models: audienceList))
            
            var procesList = [String]()
            for item in model.serProcesList {
                let data = item.split(separator: ";").map { String($0) }
                if data.count == 2 {
                    procesList.append(data[1])
                }
            }
            dataSource.append(.serviceFlow(progress: procesList))
            
            dataSource.append(.address)
            dataSource.append(.tip)
            
            self?.dataSourceProperty.value = dataSource
        }
    }
    
    func getOrder(_ completion: @escaping (Int?) -> Void) {
        guard let model = hutModelProperty.value, let address = addressModelProperty.value else { return }
        let params: [String: Any] = [
            "equipmentName": model.equipmentName,
            "price": model.serPrice,
            "serCode": model.serCode,
            "serName": model.serName,
            "surplusNum": 0,
            "puid": patientId,
            "address": address.district + address.address,
            "mobile": address.mobile,
            "realName": address.consignee
        ]
        ServiceApi.addSerSunshineHut(params: params).rac_response(Int.self).startWithValues { (resp) in
            HUD.showError(BoolString(resp))
            completion(resp.content)
        }
    }
}

extension HutPackageDetailViewModel {
    enum RowModel {
        case outline(name: String, time: String, feature: String)
        case content(contents: [String], detail: String, pic: String)
        case targetAudience(models: [TargetAudienceModel])
        case serviceFlow(progress: [String])
        case address
        case tip
    }
    
    struct TargetAudienceModel {
        let pic: String
        let title: String
    }
}
