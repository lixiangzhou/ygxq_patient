//
//  TaskTipListController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/5.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class TaskTipListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "任务提醒"
        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getTasks()
    }

    // MARK: - Public Property
    let viewModel = TaskTipListViewModel()
    
    // MARK: - Private Property
    private let tableView = UITableView()
}

// MARK: - UI
extension TaskTipListController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self, separatorStyle: .none, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: TaskTipListCell.self)
        tableView.backgroundColor = .cf
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
        
        viewModel.drugOrderProperty.signal.skipNil().observeValues { [weak self] result in
            if let order = result.1 {
                let vc = PayController()
                vc.viewModel.orderId = order.orderId
                vc.viewModel.resultAction = PayViewModel.ResultAction(backClassName: self?.zz_className ?? "TaskTipListController", type: .singleSunnyDrug)
                self?.push(vc)
            } else {
                let vc = SunnyDrugBuyController()
                vc.viewModel.did = result.0.gotoJsonDuid
                vc.viewModel.serType = result.0.serType
                vc.viewModel.serVideoId = result.0.linkId
                vc.viewModel.backAction = PayViewModel.ResultAction(backClassName: self?.zz_className ?? "TaskTipListController", type: .singleSunnyDrug)
                self?.push(vc)
            }
        }
        
        tableView.reactive.emptyDataString <~ viewModel.dataSourceProperty.signal.map { $0.isEmpty ? "暂无数据" : nil }
    }
}

// MARK: - Delegate Internal

// MARK: -
extension TaskTipListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: TaskTipListCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        cell.timeLabel.text = model.createTime.toTime(format: "yyyy-MM-dd HH:mm")
        cell.txtLabel.text = model.content
        cell.btn.setTitle(model.taskActionTitle, for: .normal)
        cell.btnClosure = { [weak self] in
            guard let self = self else { return }
            switch model.actionType {
            case .buyDrug:
                self.viewModel.queryBrugOrderInfoByTask(model)
            case .finishQuestion:
                self.viewModel.toFinishExam(model, from: self)
            case .uploadResource:
                self.viewModel.toUploadResource(model, from: self)
            case .other:
                break
            }
        }
        return cell
    }
}
