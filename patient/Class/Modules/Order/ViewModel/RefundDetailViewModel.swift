//
//  RefundDetailViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/26.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class RefundDetailViewModel: BaseViewModel {
    var orderModel: OrderModel!
    
    func getMoneyString(_ money: Double) -> NSAttributedString {
        let smallFont = [NSAttributedString.Key.font : UIFont.size(14), NSAttributedString.Key.foregroundColor: UIColor.cf25555]
        let largeFont = [NSAttributedString.Key.font : UIFont.boldSize(16), NSAttributedString.Key.foregroundColor: UIColor.cf25555]
        
        let attr = NSMutableAttributedString(string: "¥", attributes: smallFont)
        attr.append(NSAttributedString(string: "\(Int(money))", attributes: largeFont))
        
        let point = (Int(money * 100) % 100).description
        let pointString = point.count == 1 ? "\(point)0" : point.description
        
        attr.append(NSAttributedString(string: ".\(pointString)", attributes: smallFont))
        return attr
    }
    
    func getStatus() -> String {
        switch orderModel.status {
        case "PAY_ORD_S_REF_IN":
            return "退款中"
        case "PAY_ORD_S_REF_SUC":
            return "退款成功"
        case "PAY_ORD_S_REF_FAL":
            return "退款失败"
        default:
            return ""
        }
    }
}
