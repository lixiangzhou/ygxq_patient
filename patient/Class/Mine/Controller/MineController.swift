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
        
        setNav()
        setNavigationStyle(.transparency)
    }

    // MARK: - Properties
    private let tableView = UITableView()
    private let viewModel = MineViewModel()
}

// MARK: - UI
extension MineController {
    private func setUI() {
        setBody()
    }
    
    private func setNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIButton(title: "编辑", font: .size(14), titleColor: .red, target: self, action: #selector(editAction)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIButton(title: "消息", font: .size(14), titleColor: .red, target: self, action: #selector(msgAction)))
    }
    
    private func setBody() {
        view.addSubview(tableView)
        
        tableView.register(cell: TextTableViewCell.self)
        tableView.set(dataSource: self, delegate: self)
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
    @objc private func editAction() {
        
    }
    
    @objc private func msgAction() {
        
    }
}

extension MineController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: TextTableViewCell.self, for: indexPath)
        cell.titleLabel.text = viewModel.dataSource[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = viewModel.dataSource[indexPath.row]
        switch type {
        case .setting:
            let vc = SettingController()
            push(vc)
        default:
            break
        }
    }
}
