//
//  ProfileController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class ProfileController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的病历"
        setUI()
        setBinding()
        PatientManager.shared.getPatientInfo()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 225))
    private let viewModel = ProfileViewModel()
}

// MARK: - UI
extension ProfileController {
    override func setUI() {
        tableView.backgroundColor = .cf0efef
        tableView.set(dataSource: self, delegate: self)
        tableView.register(cell: TextTableViewCell.self)
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        patientInfoProperty.producer.skipNil().startWithValues { [weak self] (pinfo) in
            self?.headerView.nameLabel.text = pinfo.realName
            self?.headerView.mobileLabel.text = pinfo.mobile.mobileSecrectString
            self?.headerView.ageLabel.text = pinfo.age?.description ?? "未知"
            self?.headerView.sexLabel.text = pinfo.sex.description
            self?.headerView.diseaseLabel.text = pinfo.diseaseName.isEmpty ? "无" : pinfo.diseaseName
            
            self?.headerView.layoutHeight()
            self?.headerView.zz_height += 10
            self?.tableView.tableHeaderView = self?.headerView
        }
    }
}

// MARK: - Delegate Internal

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProfileController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: TextTableViewCell.self, for: indexPath)
        let model = viewModel.dataSource[indexPath.row]
        
        cell.config = model.config
        cell.leftIconView?.image = UIImage(named: model.img)
        cell.leftLabel.text = model.type.rawValue
        cell.leftIconView?.backgroundColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSource[indexPath.row]
        switch model.type {
        case .historyData:
            push(HistoryProfileDataController())
        case .drugRecord:
            push(DrugUsedController())
        }
    }
}
