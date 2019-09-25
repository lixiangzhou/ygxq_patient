//
//  ApplyForRefundViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/20.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift

class ApplyForRefundViewModel: BaseViewModel {
    override init() {
        super.init()
    }
    
    func refundApply(_ order: OrderModel, reason: String) -> SignalProducer<BoolString, NoError> {
        return OrderApi.refundApply(pid: patientId, orderId: order.id, reason: reason).rac_response(String.self).map { BoolString($0) }
    }
    
    func getMoneyString(_ money: Double) -> NSAttributedString {
        let smallFont = [NSAttributedString.Key.font : UIFont.size(14), NSAttributedString.Key.foregroundColor: UIColor.cf25555]
        let largeFont = [NSAttributedString.Key.font : UIFont.boldSize(16), NSAttributedString.Key.foregroundColor: UIColor.cf25555]
        
        let attr = NSMutableAttributedString(string: "¥", attributes: smallFont)
        attr.append(NSAttributedString(string: "\(Int(money))", attributes: largeFont))
        
        let point = (Int(money * 100) % 100).description
        let pointString = point.count == 1 ? "0\(point)" : point.description
        
        attr.append(NSAttributedString(string: ".\(pointString)", attributes: smallFont))
        return attr
    }
    
    func getGrayConfig() -> TextLeftRightViewConfig {
        return TextLeftRightViewConfig()
    }
    
    func getRedConfig() -> TextLeftRightViewConfig {
        return TextLeftRightViewConfig(rightTextColor: .cf25555)
    }
}
