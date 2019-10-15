//
//  HealthDataController.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/8.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "健康数据"
        setUI()
        setBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getData()
    }
    // MARK: - Public Property
    
    // MARK: - Private Property
    private let viewModel = HealthDataViewModel()
    
    private let tableView = UITableView()
}

// MARK: - UI
extension HealthDataController {
    override func setUI() {
        tableView.backgroundColor = .cf0efef
        tableView.set(dataSource: self, delegate: self, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: HealthDataCell.self)
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
// MARK: - UITableViewDataSource, UITableViewDelegate
extension HealthDataController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: HealthDataCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        cell.iconView.image = viewModel.getIcon(model: model)
        cell.nameLabel.text = model.description
        cell.dataLabel.attributedText = viewModel.getValue(model: model)
        cell.timeLabel.text = model.createTime?.toTime(format: "MM-dd HH:mm") ?? "暂无数据"
        
        let isXD = model.healthLogType == "HLR_HLG_T_11"
        cell.imgView.isHidden = !isXD
        cell.dataLabel.isHidden = isXD
        
        if isXD {
            let hasValue = model.healthLogValues != nil
            cell.imgView.isHidden = !hasValue
            cell.dataLabel.isHidden = hasValue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        switch model.healthLogType {
        case "HLR_HLG_T_11":
            let vc = HealthDataECGShowController()
            push(vc)
        default:
            let vc = HealthDataShowController()
            vc.viewModel.type = model.healthLogType
            push(vc)
        }
    }
}
