//
//  OrderListController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class OrderListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }

    // MARK: - Public Property
    
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
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Action
extension OrderListController {
    
}

// MARK: - Network
extension OrderListController {
    
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension OrderListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: OrderListCell.self, for: indexPath)
        
        cell.orderNoLabel.text = "463817497901"
        cell.orderCreateTimeLabel.text = "2018-1-2 08:32"
        cell.orderTypeLabel.text = "视频咨询"
        cell.orderPriceLabel.text = "¥200.00"
        cell.orderStateLabel.text = "已支付"
        cell.orderCancelTimeLabel.text = "12:30后自动取消订单"
        
        return cell
    }
}


// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension OrderListController {
    
}

// MARK: - Other
extension OrderListController {
    
}

// MARK: - Public
extension OrderListController {
    
}

