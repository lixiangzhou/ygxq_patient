//
//  HealthDataMemberListController.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataMemberListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "选择成员"
        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.queryPatientConsultantList()
    }

    // MARK: - Public Property
    let tableView = UITableView()
    let viewModel = HealthDataMemberListViewModel()
    var selectClosure: ((HealthDataECGPatientModel) -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension HealthDataMemberListController {
    override func setUI() {
        setRightBarItem(title: "添加成员", action: #selector(addAction))
        
        tableView.set(dataSource: self, delegate: self, rowHeight: 60)
        tableView.register(cell: HealthDataMemberListCell.self)
        tableView.backgroundColor = .cf0efef
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        tableView.reactive.reloadData <~ viewModel.dataSourceProperty.signal.map(value: ())
        viewModel.dataSourceProperty.signal.observeValues { [weak self] (models) in
            if models.isEmpty {
                self?.pop()
            }
        }
    }
}

// MARK: - Action
extension HealthDataMemberListController {
    @objc private func addAction() {
        let vc = HealthDataMemberEditController()
        push(vc)
    }
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension HealthDataMemberListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: HealthDataMemberListCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        cell.model = model
        cell.editClosure = { [weak self] m in
            let vc = HealthDataMemberEditController()
            vc.viewModel.mode = .edit
            vc.viewModel.model = m
            self?.push(vc)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectClosure?(viewModel.dataSourceProperty.value[indexPath.row])
        pop()
    }
}

