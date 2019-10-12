//
//  InvoiceSelectController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class InvoiceSelectController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "选择订单"
        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    let viewModel = InvoiceSelectViewModel()
    // MARK: - Private Property
    let tableView = UITableView()
    let bottomView = UIView()
    let selectBtn = UIButton(title: "  全选", font: .size(18), titleColor: .c3, imageName: "pay_unsel", selectedImageName: "pay_sel", backgroundColor: .cf)
    let nextBtn = UIButton(title: "下一步", font: .size(18), titleColor: .cf, backgroundColor: .c407cec)
}

// MARK: - UI
extension InvoiceSelectController {
    override func setUI() {
        setRightBarItem(title: "开票历史", action: #selector(invoiceRecordsAction))

        tableView.backgroundColor = .cf0efef
        
        tableView.set(dataSource: self, delegate: nil, rowHeight: 90)
        tableView.register(cell: InvoiceSelectCell.self)
        view.addSubview(tableView)
        
        selectBtn.addTarget(self, action: #selector(selectAllAction), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        
        bottomView.addSubview(selectBtn)
        bottomView.addSubview(nextBtn)
        view.addSubview(bottomView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottomOffsetFrom(self)
        }
        
        selectBtn.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }
        
        nextBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(selectBtn.snp.width)
            make.left.equalTo(selectBtn.snp.right)
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
        
        tableView.reactive.emptyDataString <~ viewModel.dataSourceProperty.signal.map { $0.isEmpty ? "暂无数据" : nil }
        
        viewModel.dataSourceProperty.signal.observeValues { [weak self] (orders) in
            self?.tableView.contentInset.bottom = orders.isEmpty ? 0 : 50
            self?.bottomView.isHidden = orders.isEmpty
        }
        
        selectBtn.reactive.isSelected <~ viewModel.dataSourceProperty.signal.map { orders -> Bool in
            for o in orders {
                if !o.isSelected {
                    return false
                }
            }
            return true
        }
        
        let nextEnabledSignal = viewModel.dataSourceProperty.producer.map { orders -> Bool in
            for o in orders {
                if o.isSelected {
                    return true
                }
            }
            return false
        }
        
        nextBtn.reactive.isUserInteractionEnabled <~ nextEnabledSignal
        nextBtn.reactive.backgroundColor <~ nextEnabledSignal.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
    }
}

// MARK: - Action
extension InvoiceSelectController {
    @objc private func selectAllAction() {
        viewModel.selectAll(!selectBtn.isSelected)
    }

    @objc private func nextAction() {
        let vc = InvoiceMakeController()
        vc.viewModel.orderModels = viewModel.selectedOrders
        vc.viewModel.submitResultProperty.signal.observeValues { [weak self] (result) in
            if result {
                self?.viewModel.getData()
            }
        }
        push(vc)
    }
    
    @objc private func invoiceRecordsAction() {
        push(InvoiceRecordListController())
    }
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension InvoiceSelectController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: InvoiceSelectCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.orderNoLabel.text = "订单编号：\(model.id)"
        cell.timeLabel.text = model.orderTime.toTime(format: "yyyy-MM-dd HH:mm")
        cell.nameLabel.text = model.productName
        cell.priceLabel.text = String(format: "￥%.2f", model.payAmount)
        cell.selectBtn.isSelected = model.isSelected
        
        cell.selectClosure = { [weak self] in
            self?.viewModel.selectAt(indexPath.row)
        }
        
        cell.priceLabel.snp.updateConstraints { (make) in
            make.width.equalTo(ceil(cell.priceLabel.text!.zz_size(withLimitWidth: 200, fontSize: cell.priceLabel.font.pointSize).width))
        }
        
        return cell
    }
}
