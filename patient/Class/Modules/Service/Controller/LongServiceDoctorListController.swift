//
//  LongServiceDoctorListController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class LongServiceDoctorListController: BaseController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "长期服务"
        setUI()
        setBinding()
        viewModel.getData()
    }
    
    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = LongServiceDoctorListViewModel()
}

// MARK: - UI
extension LongServiceDoctorListController {
    override func setUI() {
        tableView.set(dataSource: self, delegate: self, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: LongServiceDoctorListCell.self)
        tableView.backgroundColor = .cf0efef
        view.addSubview(tableView)
        
        tableView.emptyDataSetView { (emptyView) in
            emptyView.titleLabelString(NSMutableAttributedString(string:"暂无数据"))
        }
        
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
extension LongServiceDoctorListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: LongServiceDoctorListCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.iconView.kf.setImage(with: URL(string: model.imgUrl), placeholder: UIImage(named: "doctor_avator"))
        cell.nameLabel.text = model.realName.isEmpty ? " " : model.realName
        cell.professionLabel.text = model.titleName
        cell.hospitalLabel.text = model.hospitalName
        cell.professionLabel.snpUpdateWidth()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        let vc = LongServicesController()
        vc.did = model.duid
        push(vc)
    }
}
