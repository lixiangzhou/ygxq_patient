//
//  SunnyDrugOrderListController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class SunnyDrugOrderListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    let viewModel = SunnyDrugOrderListViewModel()
    
    // MARK: - Private Property
    private let tableView = UITableView()
}

// MARK: - UI
extension SunnyDrugOrderListController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: SunnyDrugOrderCell.self)
        tableView.backgroundColor = .cf0efef
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.skipRepeats().map(value: ())
        tableView.reactive.emptyDataString <~ viewModel.dataSourceProperty.signal.map { $0.isEmpty ? "暂无数据" : nil }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SunnyDrugOrderListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: SunnyDrugOrderCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.nameLabel.text = "阳光续药"
        cell.timeLabel.text = model.createTime.toTime()
        cell.descLabel.text = model.drugName.isEmpty ? "发起了阳光续药服务" : "购买药品：\(model.drugName)"
        cell.lookClosure = { [weak self] in
            let vc = SunnyDrugOrderDetailController()
            vc.viewModel.id = model.id
            self?.push(vc)
        }
        return cell
    }
}

