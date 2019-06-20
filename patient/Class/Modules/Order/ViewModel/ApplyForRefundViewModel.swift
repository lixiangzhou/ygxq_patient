//
//  ApplyForRefundViewModel.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/20.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class ApplyForRefundViewModel: BaseViewModel {
    override init() {
        super.init()
    }
    
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
    
    func getGrayConfig() -> TextLeftRightViewConfig {
        return TextLeftRightViewConfig()
    }
    
    func getRedConfig() -> TextLeftRightViewConfig {
        return TextLeftRightViewConfig(rightTextColor: .cf25555)
    }
}
