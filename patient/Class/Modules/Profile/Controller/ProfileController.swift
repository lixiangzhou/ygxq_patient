//
//  ProfileController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class ProfileController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的档案"
        setUI()
        setBinding()
        PatientManager.shared.getPatientInfo()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 245))
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
        
        headerView.uploadClosure = { [unowned self] in
            self.uploadAction()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        patientInfoProperty.producer.skipNil().startWithValues { [weak self] (pinfo) in
            self?.headerView.nameLabel.text = pinfo.realName
            self?.headerView.mobileLabel.text = pinfo.mobile
            self?.headerView.ageLabel.text = pinfo.age.description
            self?.headerView.sexLabel.text = pinfo.sex.description
            self?.headerView.diseaseLabel.text = pinfo.diseaseName
            
            self?.headerView.layoutHeight()
            self?.tableView.tableHeaderView = self?.headerView
        }
    }
}

// MARK: - Action
extension ProfileController {
    private func uploadAction() {
        let vc = UploadResourceController()
        vc.title = "上传资料"
        push(vc)
    }
}

// MARK: - Network
extension ProfileController {
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
        cell.titleLabel.text = model.type.rawValue
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

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension ProfileController {
    
}

// MARK: - Other
extension ProfileController {
    
}

// MARK: - Public
extension ProfileController {
    
}

