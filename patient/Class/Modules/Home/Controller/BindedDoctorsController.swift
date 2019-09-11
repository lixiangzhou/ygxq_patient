//
//  BindedDoctorsController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class BindedDoctorsController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "复诊/购药"
        setUI()
        setBinding()
        viewModel.getData()
    }
    
    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = BindedDoctorsViewModel()
}

// MARK: - UI
extension BindedDoctorsController {
    override func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "我的咨询", target: self, action: #selector(myConsultAction))
        
        tableView.set(dataSource: self, delegate: self, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: BindedDoctorsCell.self)
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

// MARK: - Action
extension BindedDoctorsController {
    @objc private func myConsultAction() {
        let vc = ConsultController()
        push(vc)
    }
}
// MARK: - Delegate Internal

// MARK: -
extension BindedDoctorsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceProperty.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: BindedDoctorsCell.self, for: indexPath)
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        
        cell.iconView.kf.setImage(with: URL(string: model.imgUrl), placeholder: UIImage(named: "doctor_avator"))
        cell.nameLabel.text = model.realName.isEmpty ? " " : model.realName
        cell.professionLabel.text = model.titleName
        cell.hospitalLabel.text = model.hospitalName
        var sers = [String]()
        for ser in model.doctorSers {
            sers.append(ser.serName)
        }
        cell.servicesLabel.text = sers.isEmpty ? nil : sers.joined(separator: " ")
        cell.professionLabel.snpUpdateWidth()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSourceProperty.value[indexPath.row]
        let vc = DoctorDetailController()
        vc.viewModel.did = model.duid
        push(vc)
    }
}
