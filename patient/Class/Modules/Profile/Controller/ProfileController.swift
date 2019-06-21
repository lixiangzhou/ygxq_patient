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
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 234))
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
            self?.headerView.mobileLabel.text = pinfo.mobile
            self?.headerView.ageLabel.text = (Date().zz_year - pinfo.birth.date.zz_year).description
            self?.headerView.sexLabel.text = pinfo.sex.description
            self?.headerView.diseaseLabel.text = pinfo.diseaseName
        }
    }
}

// MARK: - Action
extension ProfileController {
    
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
            let vc = HistoryProfileDataController()
            push(vc)
        case .drugRecord:
            break
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

