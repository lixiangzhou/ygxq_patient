//
//  SettingController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
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
    override func setUI() {
        view.addSubview(tableView)
        
        tableView.register(cell: TextTableViewCell.self)
        tableView.set(dataSource: self, delegate: self)
        tableView.backgroundColor = .cf0efef
        tableView.tableFooterView = getFooterView()
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func getFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.zz_width, height: 54))
        let btn = footerView.zz_add(subview: UIButton(title: "退出登录", font: .size(17), backgroundColor: .white, target: self, action: #selector(logoutAction))) as! UIButton
        btn.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.left.bottom.equalToSuperview()
        }
        return footerView
    }
}

// MARK: - Action
extension SettingController {
    @objc private func logoutAction() {
        viewModel.logout()
        
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
        let model = viewModel.dataSource[indexPath.row]
        cell.config = model.config
        cell.leftLabel.text = model.type.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.dataSource[indexPath.row]
        
        switch data.type {
        case .changePwd:
            let vc = PwdChangeController()
            push(vc)
        case .addressMgr:
            let vc = AddressListController()
            push(vc)
        case .serviceProtocol:
            toServicePrototol()
        default:
            break
        }
    }
}
