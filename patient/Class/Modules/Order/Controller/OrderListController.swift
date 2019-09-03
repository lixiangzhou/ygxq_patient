//
//  OrderListController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import EmptyDataSet_Swift

class OrderListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    let viewModel = OrderListViewModel()
    // MARK: - Private Property
    private let tableView = UITableView()
}

// MARK: - UI
extension OrderListController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self, rowHeight: 210)
        tableView.register(cell: OrderListCell.self)
        tableView.backgroundColor = .cf0efef
        view.addSubview(tableView)
        
        tableView.emptyDataSetView { (emptyView) in
            emptyView.titleLabelString(NSMutableAttributedString(string:"暂无数据"))
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.skipRepeats().map(value: ())
    }
}

// MARK: - Action
extension OrderListController {
    /// 取消订单
    func cancelOrderAction(_ cell: OrderListCell?, _ model: OrderModel) {
        viewModel.cancelOrder(order: model)
    }
    
    /// 去支付
    func payOrderAction(_ cell: OrderListCell?, _ model: OrderModel) {
        let vc = PayController()
        vc.viewModel.orderId = model.id
        var type: PayViewModel.ResultAction.ResultType?
        switch model.productName {
        case "阳光续药":
            type = .singleSunnyDrug
        case "视频咨询":
            type = .singleVideoConsult
        default:
            break
        }
        if let type = type {
            vc.viewModel.resultAction = PayViewModel.ResultAction(backClassName: className, type: type)
        }
        push(vc)
    }
    
    /// 删除订单
    func deleteOrderAction(_ cell: OrderListCell?, _ model: OrderModel) {
        viewModel.deleteOrder(order: model)
    }
    
    /// 退款
    func refundOrderAction(_ cell: OrderListCell?, _ model: OrderModel) {
        viewModel.refundIsApply(orderId: model.id).startWithValues { [unowned self] (result) in
            HUD.showError(result)
            if result.isSuccess {
                let vc = ApplyForRefundController()
                vc.orderModel = model
                vc.submitCompleteClosure = { order in
                    self.viewModel.getData()
                }
                self.push(vc)
            }
        }
    }
    
    /// 订单详情
    func orderDetailAction(_ cell: OrderListCell?, _ model: OrderModel) {
        
    }
    
    /// 退款详情
    func refundDetailAction(_ cell: OrderListCell?, _ model: OrderModel) {
        let vc = RefundDetailController()
        vc.viewModel.orderModel = model
        push(vc)
    }
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
        configCellInfo(cell, model: model)
        configCellTimer(cell, model: model)
        addCellActions(cell, model: model)
    }
    
    private func configCellTimer(_ cell: OrderListCell, model: OrderModel) {
        switch viewModel.state {
        case .payed:
            cell.payedView.hideRefund = model.serCode == "UTOPIA13"
        case .toPay:
            let closed = model.status == "PAY_ORD_S_CLO"
            cell.toPayView.payedView.isHidden = closed
            cell.toPayView.deleteBtn.isHidden = !closed
           
            viewModel.removeTimer(cell.hash)
            
            if viewModel.showTimer(model: model) {
                cell.orderCancelTimeLabel.text = self.viewModel.timerString(model: model)
                let timer = Timer(timeInterval: 1, repeats: true) { [weak cell, weak self] (timer) in
                    guard let cell = cell, let self = self else { timer.invalidate(); return }
                    if self.viewModel.showTimer(model: model) {
                        cell.orderCancelTimeLabel.text = self.viewModel.timerString(model: model)
                    } else {
                        cell.orderCancelTimeLabel.text = nil
                        self.viewModel.removeTimer(cell.hash)
                        var m = model
                        m.status = "PAY_ORD_S_CLO"
                        self.viewModel.updateModel(model: m)
                    }
                }
                RunLoop.current.add(timer, forMode: .common)
                viewModel.saveTimer(cell.hash, timer: timer)
            } else {
                cell.orderCancelTimeLabel.text = nil
            }
            
            
        case .refund:
            break
        }

    }
    
    private func configCellInfo(_ cell: OrderListCell, model: OrderModel) {
        cell.orderNoLabel.text = model.id.description
        cell.orderCreateTimeLabel.text = Date(timeIntervalSince1970: model.orderTime / 1000).zz_string(withDateFormat: "yyyy-MM-dd HH:mm")
        
        cell.orderTypeLabel.text = model.productName
        cell.orderPriceLabel.text = "¥\(model.payAmount)"
        
        cell.orderStateDescLabel.text = viewModel.state != .refund ? "订单状态：" : "退款状态："
        cell.orderStateLabel.text = viewModel.getStateString(model: model)
        cell.orderCancelTimeLabel.text = ""
        
        cell.payedView.isHidden = viewModel.state != .payed
        cell.toPayView.isHidden = viewModel.state != .toPay
        cell.refundView.isHidden = viewModel.state != .refund
    }
    
    private func addCellActions(_ cell: OrderListCell, model: OrderModel) {
        cell.cancelOrderClosure = { [weak self, weak cell] in
            self?.cancelOrderAction(cell, model)
        }
        
        cell.payOrderClosure = { [weak self, weak cell] in
            self?.payOrderAction(cell, model)
        }
        
        cell.deleteOrderClosure = { [weak self, weak cell] in
            self?.deleteOrderAction(cell, model)
        }
        
        cell.refundOrderClosure = { [weak self, weak cell] in
            self?.refundOrderAction(cell, model)
        }
        
        cell.orderDetailClosure = { [weak self, weak cell] in
            self?.orderDetailAction(cell, model)
        }
        
        cell.refundDetailClosure = { [weak self, weak cell] in
            self?.refundDetailAction(cell, model)
        }
    }
}
