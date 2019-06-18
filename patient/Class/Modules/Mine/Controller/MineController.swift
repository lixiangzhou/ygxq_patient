//
//  MineController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

/// 我的
class MineController: BaseController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = nil
        tabBarItem.title = "我的"
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationStyle(.transparency)
    }

    // MARK: - Properties
    private let tableView = UITableView()
    private let viewModel = MineViewModel()
}

// MARK: - UI
extension MineController {
    private func setUI() {
        view.addSubview(tableView)
        
        tableView.register(cell: TextTableViewCell.self)
        tableView.set(dataSource: self, delegate: self)
        tableView.backgroundColor = .cf0efef
        let header = MineHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 150))
        header.tapClosure = {
            
        }
        tableView.tableHeaderView = header
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
        case .setting:
            let vc = SettingController()
            push(vc)
        default:
            break
        }
    }
}
