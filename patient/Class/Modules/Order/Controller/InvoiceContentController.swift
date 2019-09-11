//
//  InvoiceContentController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class InvoiceContentController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "具体内容"
        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    let viewModel = InvoiceContentViewModel()
    // MARK: - Private Property
    let tableView = UITableView()
}

// MARK: - UI
extension InvoiceContentController {
    override func setUI() {
        tableView.backgroundColor = .cf0efef
        
        tableView.set(dataSource: self, rowHeight: 90)
        tableView.register(cell: InvoiceContentCell.self)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
    }
}

// MARK: - Delegate Internal

// MARK: -
extension InvoiceContentController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: InvoiceContentCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.orderNoLabel.text = "订单编号：\(model.id)"
        cell.timeLabel.text = model.orderTime.toTime(format: "yyyy-MM-dd HH:mm")
        cell.nameLabel.text = model.productName
        cell.priceLabel.text = String(format: "￥%.2f", model.payAmount)
        
        cell.priceLabel.snp.updateConstraints { (make) in
            make.width.equalTo(ceil(cell.priceLabel.text!.zz_size(withLimitWidth: 200, fontSize: cell.priceLabel.font.pointSize).width))
        }
        
        return cell
    }
}
