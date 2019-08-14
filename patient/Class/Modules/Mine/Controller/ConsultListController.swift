//
//  ConsultListController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/14.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class ConsultListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
        viewModel.state = state
        viewModel.getData()
    }

    // MARK: - Public Property
    var state = ConsultState.ing
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = ConsultListViewModel()
}

// MARK: - UI
extension ConsultListController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: ConsultListCell.self)
        tableView.backgroundColor = .cf0efef
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.skipRepeats().map(value: ())
    }
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension ConsultListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: ConsultListCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.nameLabel.text = model.serName
        cell.timeLabel.text = model.createTime.toTime()
        cell.descLabel.text = model.consultContent
        cell.lookClosure = {
            
        }
        return cell
    }
}


// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension OrderListController {
    func config(cell: ConsultListCell, with model: ConsultModel) {
        cell.nameLabel.text = model.serName
        cell.timeLabel.text = model.createTime.toTime()
        cell.descLabel.text = model.consultContent
        cell.lookClosure = {
            
        }
    }
}
