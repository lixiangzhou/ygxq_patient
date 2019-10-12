//
//  SystemMsgController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/20.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class SystemMsgController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "系统消息"
        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = SystemMsgViewModel()

}

// MARK: - UI
extension SystemMsgController {
    override func setUI() {
        setRightBarItem(title: "全部已读", action: #selector(readedAction))
        
        tableView.backgroundColor = .cf0efef
        tableView.set(dataSource: self, delegate: self, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: SystemMsgCell.self)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
        tableView.reactive.emptyDataString <~ viewModel.dataSourceProperty.signal.map { $0.isEmpty ? "暂无数据" : nil }
    }
}

// MARK: - Action
extension SystemMsgController {
    @objc private func readedAction() {
        if viewModel.hasUnRead {
            viewModel.setAllReaded()
        } else {
            HUD.show(toast: "暂无未读的消息")
        }
    }
}

// MARK: - Delegate Internal

// MARK: -
extension SystemMsgController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: SystemMsgCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        cell.msgLabel.text = model.content
        cell.isRead = model.isLook == "Y"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        viewModel.selectModel(model)
    }
}


