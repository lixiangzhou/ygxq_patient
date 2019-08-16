//
//  OrderController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

enum OrderState {
    case toPay
    case payed
    case refund
}

class OrderController: LLSegmentViewController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的订单"
        setUI()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension OrderController {
    override func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "开发票", titleColor: .cf, target: self, action: #selector(getTicketAction))
        
        loadSegmentedConfig()
    }
    
    
    override func loadCtls() {
        let toPayVC = OrderListController()
        toPayVC.title = "待支付"
        toPayVC.state = .toPay
        
        let payedVC = OrderListController()
        payedVC.title = "已支付"
        payedVC.state = .payed
        
        let refundVC = OrderListController()
        refundVC.title = "退款"
        refundVC.state = .refund
        
        reloadViewControllers(ctls:[toPayVC, payedVC, refundVC])
    }
}

// MARK: - Action
extension OrderController {
    @objc private func getTicketAction() {
        
    }
}

// MARK: -
extension OrderController {
    /// 解决在iPhone X上滑动联动的BUG，子View 不随着滑动
    override func scrollView(scrollView: LLContainerScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        return false
    }
}
