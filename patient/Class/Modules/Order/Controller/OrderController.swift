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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let idx = selectIndex {
            selected(at: idx, animation: true)
        }
    }

    // MARK: - Public Property
    var selectIndex: Int?
    var resultAction: PayViewModel.ResultAction?
    // MARK: - Private Property
    let toPayVC = OrderListController()
    let payedVC = OrderListController()
    let refundVC = OrderListController()
}

// MARK: - UI
extension OrderController {
    override func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "开发票", titleColor: .cf, target: self, action: #selector(getInvoiceAction))
        
        loadSegmentedConfig()
        segmentCtlView.delegate = self
    }
    
    
    override func loadCtls() {
        toPayVC.title = "待支付"
        toPayVC.viewModel.state = .toPay
        toPayVC.ordersVC = self
        
        payedVC.title = "已支付"
        payedVC.viewModel.state = .payed
        payedVC.ordersVC = self
        
        refundVC.title = "退款"
        refundVC.viewModel.state = .refund
        refundVC.ordersVC = self
        
        reloadViewControllers(ctls:[toPayVC, payedVC, refundVC])
    }
}

extension OrderController: LLSegmentedControlDelegate {
    func segMegmentCtlView(segMegmentCtlView: LLSegmentedControl, clickItemAt sourceItemView: LLSegmentBaseItemView, to destinationItemView: LLSegmentBaseItemView) {
        switch destinationItemView.index {
        case 0:
            toPayVC.viewModel.getData()
        case 1:
            payedVC.viewModel.getData()
        case 2:
            refundVC.viewModel.getData()
        default:
            break
        }
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
