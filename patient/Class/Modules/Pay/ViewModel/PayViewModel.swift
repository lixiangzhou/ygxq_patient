//
//  PayViewModel.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class PayViewModel: BaseViewModel {
    var orderId = 0
    
    let dataSourceProperty = MutableProperty<[Model]>([.list(name: "  ", price: "  "), .method, .tip])
    
    let orderProperty = MutableProperty<OrderModel?>(nil)
    
    let payInfoProperty = MutableProperty<WXPayInfoModel?>(nil)
    
    var resultAction: ResultAction?
    
    func getData() {
        OrderApi.detail(orderId: orderId).rac_response(OrderModel.self).startWithValues { [weak self] (resp) in
            guard let self = self else { return }
            HUD.showError(BoolString(resp))
            
            if let model = resp.content {
                self.orderProperty.value = model
                var values = self.dataSourceProperty.value
                values.replaceSubrange(0...0, with: [.list(name: model.productName, price: "￥\(model.payAmount)")])
                self.dataSourceProperty.value = values
            }
        }
    }
    
    func getPayInfo() {
        PayApi.wxPayInfo(tradeNo: orderId.description).rac_response(WXPayInfoModel.self).startWithValues { [weak self] (resp) in
            let result = BoolString(resp)
            HUD.showError(result)
            if result.isSuccess {
                self?.payInfoProperty.value = resp.content
            }
        }
    }
    
    func addProtocol(_ img: UIImage) {
        HUD.showLoding()
        UploadApi.upload(datas: [FileData(data: img.zz_resetToSize(200, maxWidth: 800, maxHeight: 800), name: "sign.jpg")]).rac_response([String].self).startWithValues { [weak self] (resp) in
            HUD.showError(BoolString(resp))
            if resp.isSuccess, let url = resp.content?.first {
                OrderApi.addProtocol(imgUrl: url, pid: patientId).rac_response(String.self).startWithValues { resp in
                    HUD.hideLoding()
                    HUD.showError(BoolString(resp))
                    if resp.isSuccess {
                        var value = self?.orderProperty.value
                        value?.isProtocol = true
                        self?.orderProperty.value = value
                    }
                }
            } else {
                HUD.hideLoding()
            }
        }
    }
}

extension PayViewModel {
    struct ResultAction {
        var backClassName: String
        var type: ResultType
        
        enum ResultType {
            case longSer
            case singleVideoConsult
            case singleSunnyDrug
        }
    }
    
    enum Model {
        case list(name: String, price: String)
        case method
        case tip
    }
}
