//
//  MineController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import Kingfisher

/// 我的
class MineController: BaseController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = nil
        tabBarItem.title = "我的"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationStyle(.transparency)
    }

    // MARK: - Properties
    private let tableView = UITableView()
    private let viewModel = MineViewModel()
    private let headerView = MineHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 150))
}

// MARK: - UI
extension MineController {
    override func setUI() {
        view.addSubview(tableView)
        
        tableView.register(cell: TextTableViewCell.self)
        tableView.set(dataSource: self, delegate: self)
        tableView.backgroundColor = .cf0efef
        
        headerView.tapClosure = {
            
        }
        tableView.tableHeaderView = headerView
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setBinding() {
        patientInfoProperty.producer.startWithValues { [weak self](pinfo) in
            if let pinfo = pinfo {
                self?.headerView.iconView.kf.setImage(with: URL(string: pinfo.imgUrl), placeholder: UIImage(named: ""))
                self?.headerView.nameLabel.text = pinfo.realName
            } else {
                self?.headerView.iconView.image = UIImage(named: "")
                self?.headerView.nameLabel.text = "登录 / 注册"
            }
        }
    }
}

extension MineController {

}

extension MineController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: TextTableViewCell.self, for: indexPath)
        let model = viewModel.dataSource[indexPath.section][indexPath.row]
        
        cell.config = model.config
        cell.leftIconView?.image = UIImage(named: model.img)
        cell.titleLabel.text = model.type.rawValue
        cell.leftIconView?.backgroundColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.dataSource[indexPath.section][indexPath.row]
        switch model.type {
        case .myDoc:
            let vc = ProfileController()
            push(vc)
        case .setting:
            let vc = SettingController()
            push(vc)
        case .order:
            let vc = OrderController()
            push(vc)
        }
    }
}
