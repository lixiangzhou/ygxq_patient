//
//  OrderController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//  Copyright © 2019 sphr. All rights reserved.
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let idx = selectIndex {
            selected(at: idx, animation: true)
        }
    }

    // MARK: - Public Property
    var selectIndex: Int?
    var resultAction: PayViewModel.ResultAction?
    // MARK: - Private Property
    
}

// MARK: - UI
extension OrderController {
    override func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "开发票", titleColor: .cf, target: self, action: #selector(getInvoiceAction))
        
        loadSegmentedConfig()
    }
    
    
    override func loadCtls() {
        let toPayVC = OrderListController()
        toPayVC.title = "待支付"
        toPayVC.viewModel.state = .toPay
        
        let payedVC = OrderListController()
        payedVC.title = "已支付"
        payedVC.viewModel.state = .payed
        
        let refundVC = OrderListController()
        refundVC.title = "退款"
        refundVC.viewModel.state = .refund
        
        reloadViewControllers(ctls:[toPayVC, payedVC, refundVC])
    }
}

// MARK: - Action
extension OrderController {
    @objc private func getInvoiceAction() {
        push(InvoiceSelectController())
    }
    
    override func backAction() {
        if let backName = resultAction?.backClassName {
            popToViewController(backName)
        } else {
            super.backAction()
        }
    }
}

// MARK: -
extension OrderController {
    /// 解决在iPhone X上滑动联动的BUG，子View 不随着滑动
    override func scrollView(scrollView: LLContainerScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        return false
    }
}
