//
//  OrderListController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class OrderListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
        viewModel.state = state
        viewModel.getOrderList()
    }

    // MARK: - Public Property
    var state: OrderState = .toPay
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = OrderListViewModel()
}

// MARK: - UI
extension OrderListController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self, rowHeight: 210)
        tableView.register(cell: OrderListCell.self)
        tableView.backgroundColor = .cf0efef
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.reloadSignal
    }
}

// MARK: - Action
extension OrderListController {
    /// 取消订单
    func cancelOrderAction(_ cell: OrderListCell, _ model: OrderModel) {
        
    }
    
    /// 去支付
    func payOrderAction(_ cell: OrderListCell, _ model: OrderModel) {
        
    }
    
    /// 删除订单
    func deleteOrderAction(_ cell: OrderListCell, _ model: OrderModel) {
        
    }
    
    /// 退款
    func refundOrderAction(_ cell: OrderListCell, _ model: OrderModel) {
        viewModel.refundIsApply(orderId: model.id).startWithValues { [weak self] (result) in
            if result.isSuccess {
                let vc = ApplyForRefundController()
                vc.orderModel = model
                vc.submitCompleteClosure = { order in
                    self?.viewModel.getOrderList()
                }
                self?.push(vc)
            } else {
                HUD.showError(result)
            }
        }
    }
    
    /// 订单详情
    func orderDetailAction(_ cell: OrderListCell, _ model: OrderModel) {
        
    }
    
    /// 退款详情
    func refundDetailAction(_ cell: OrderListCell, _ model: OrderModel) {
        
    }
}

// MARK: - Network
extension OrderListController {
    
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension OrderListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: OrderListCell.self, for: indexPath)
        config(cell: cell, with: viewModel.dataSourceProperty.value[indexPath.row])
        return cell
    }
}


// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension OrderListController {
    func config(cell: OrderListCell, with model: OrderModel) {
        cell.orderNoLabel.text = model.id.description
        cell.orderCreateTimeLabel.text = Date(timeIntervalSince1970: model.orderTime / 1000).zz_string(withDateFormat: "yyyy-MM-dd HH:mm") //"2018-1-2 08:32"
        
        cell.orderTypeLabel.text = model.productName
        cell.orderPriceLabel.text = "¥\(model.payAmount)"
        
        cell.orderStateDescLabel.text = state != .refund ? "订单状态：" : "退款状态："
        cell.orderStateLabel.text = viewModel.getStateString(model: model)
        cell.orderCancelTimeLabel.text = "TODO"
        
        cell.payedView.isHidden = state != .payed
        cell.toPayView.isHidden = state != .toPay
        cell.refundView.isHidden = state != .refund
        
        cell.cancelOrderClosure = { [weak self] in
            self?.cancelOrderAction(cell, model)
        }
        
        cell.payOrderClosure = { [weak self] in
            self?.payOrderAction(cell, model)
        }
        
        cell.deleteOrderClosure = { [weak self] in
            self?.deleteOrderAction(cell, model)
        }
        
        cell.refundOrderClosure = { [weak self] in
            self?.refundOrderAction(cell, model)
        }
        
        cell.orderDetailClosure = { [weak self] in
            self?.orderDetailAction(cell, model)
        }
        
        cell.refundDetailClosure = { [weak self] in
            self?.refundDetailAction(cell, model)
        }
        
//        cell.toPayView.cancelBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
//            self?.cancelOrderAction(cell, model)
//        }
//
//        cell.toPayView.payBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
//            self?.payOrderAction(cell, model)
//        }
//
//        cell.payedView.deleteBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
//            self?.deleteOrderAction(cell, model)
//        }
//
//        cell.payedView.refundBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
//            self?.refundOrderAction(cell, model)
//        }
//
//        cell.payedView.detailBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
//            self?.orderDetailAction(cell, model)
//        }
//
//        cell.refundView.refundBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
//            self?.refundDetailAction(cell, model)
//        }
//
//        cell.refundView.deleteBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
//            self?.deleteOrderAction(cell, model)
//        }
        
    }
}

// MARK: - Other
extension OrderListController {
    
}

// MARK: - Public
extension OrderListController {
    
}

