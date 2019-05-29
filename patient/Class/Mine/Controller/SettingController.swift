//
//  SettingController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

/// 设置
class SettingController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "设置"
        setUI()
    }
    
    // MARK: - Public Property
    
    // MARK: - Private Property
    private let tableView = UITableView()
    private let viewModel = SettingViewModel()
}

// MARK: - UI
extension SettingController {
    private func setUI() {
        view.addSubview(tableView)
        
        tableView.register(cell: TextTableViewCell.self)
        tableView.set(dataSource: self, delegate: self)
        tableView.tableFooterView = getFooterView()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func getFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.zz_width, height: 80))
        let btn = footerView.zz_add(subview: UIButton(title: "退出登录", fontSize: 14, target: self, action: #selector(logoutAction))) as! UIButton
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(40)
            make.right.left.bottom.equalToSuperview()
        }
        return footerView
    }
}

// MARK: - Action
extension SettingController {
    @objc private func logoutAction() {
        
    }
}

// MARK: - Network
extension SettingController {
    
}

// MARK: - Delegate Internal

// MARK: -
extension SettingController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: TextTableViewCell.self, for: indexPath)
        let data = viewModel.dataSource[indexPath.row]
        cell.titleLabel.text = data.type.rawValue
        cell.config = data.config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.dataSource[indexPath.row]
        switch data.type {
        case .modifyPwd:
            let vc = ModifyPwdController()
            push(vc)
        default:
            break
        }
    }
}
