//
//  PayResultController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/29.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class PayResultController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "支付结果"
        setUI()
    }

    // MARK: - Public Property
    var resultAction: PayViewModel.ResultAction?
    // MARK: - Private Property
    
}

// MARK: - UI
extension PayResultController {
    override func setUI() {
        let contentView = view.zz_add(subview: UIView())
        contentView.backgroundColor = .cf
        
        let iconView = contentView.zz_add(subview: UIImageView(image: UIImage(named: "pay_ok")))
        let titleLabel = contentView.zz_add(subview: UILabel(text: "支付成功", font: .boldSize(18), textColor: .c3))
        let descLabel = contentView.zz_add(subview: UILabel(text: "感谢您使用阳光客户端，我们在五分钟内给你反馈", font: .size(14), textColor: .c6))
        let lookOrderBtn = contentView.zz_add(subview: UIButton(title: "查看订单", font: .size(16), titleColor: .c407cec, target: self, action: #selector(lookOrderAction)))
        lookOrderBtn.zz_setBorder(color: .c407cec, width: 1)
        lookOrderBtn.zz_setCorner(radius: 15, masksToBounds: true)
        
        contentView.snp.makeConstraints { (make) in
            make.topOffsetFrom(self)
            make.left.right.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        lookOrderBtn.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.bottom.equalTo(-40)
        }
    }
}

// MARK: - Action
extension PayResultController {
    @objc private func lookOrderAction() {
        let vc = OrderController()
        vc.selectIndex = 1
        push(vc)
    }
    
    override func backAction() {
        if let backName = resultAction?.backClassName {
            popToViewController(backName)
        } else {
            super.backAction()
        }
    }
}
