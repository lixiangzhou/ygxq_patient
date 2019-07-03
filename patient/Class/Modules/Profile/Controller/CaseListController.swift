//
//  CaseListController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/21.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import SwiftDate
import ReactiveSwift

class CaseListController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
        viewModel.getData()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let viewModel = CaseListViewModel()
    private let tableView = UITableView()
}

// MARK: - UI
extension CaseListController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self)
        tableView.register(cell: CaseListCell.self)
        tableView.backgroundColor = .cf0efef
        tableView.rowHeight = UITableView.automaticDimension
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
extension CaseListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: CaseListCell.self, for: indexPath)
        
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.createTimeLabel.text = model.createTime.toTime(format: "yyyy-MM-dd")
        cell.hospitalLabel.text = "就诊医院：" + model.clinicHospital
        cell.clinicTimeLabel.text = "入院时间：" + model.clinicTime.toTime(format: "yyyy-MM-dd")
        
        cell.typeLabel.text = viewModel.getTypeString(model)
        cell.typeLabel.isHidden = viewModel.getTypeString(model).isEmpty
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        let vc = CaseDetailController()
        vc.id = model.id
        push(vc)
    }
}

