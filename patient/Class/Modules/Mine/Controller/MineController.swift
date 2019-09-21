//
//  MineController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import Kingfisher
import WZLBadge

/// 我的
class MineController: BaseController {

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = nil
        tabBarItem.title = "我的"
        
        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationStyle(.transparency)
        
        viewModel.getInfo()
        viewModel.getUnReadMsgCount()
    }

    // MARK: - Properties
    private let viewModel = MineViewModel()
    private let headerView = MineHeaderView()
    var noticeBtn: UIButton!

    private let tableView = UITableView()
}

// MARK: - UI
extension MineController {
    override func setUI() {
        hideNavigation = true
        
        view.addSubview(tableView)
        addNavigationItem(position: .right, title: "编辑", imgName: "mine_nav_edit", action: #selector(editAction))
        
        tableView.register(cell: TextTableViewCell.self)
        tableView.set(dataSource: self, delegate: self)
        tableView.backgroundColor = .cf0efef
        
        headerView.tapClosure = { [unowned self] in
            self.editAction()
        }
        
        tableView.tableHeaderView = headerView
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(-UIScreen.zz_nav_statusHeight)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    override func setBinding() {
        patientInfoProperty.producer.startWithValues { [weak self](pinfo) in
            if let pinfo = pinfo {
                self?.headerView.iconView.kf.setImage(with: URL(string: pinfo.imgUrl), placeholder: UIImage(named: "mine_avator_default"))
                self?.headerView.nameLabel.text = pinfo.realName.isEmpty ? "未填写姓名" : pinfo.realName
            } else {
                self?.headerView.iconView.image = UIImage(named: "mine_avator_default")
                self?.headerView.nameLabel.text = nil
            }
        }
        
        viewModel.unReadMsgCountProperty.signal.skipRepeats().observeValues { [weak self] (value) in
            if value > 0 {
                self?.noticeBtn?.showBadge(with: .redDot, value: value, animationType: .none)
                self?.noticeBtn?.badgeCenterOffset = CGPoint(x: -5, y: 5)
            } else {
                self?.noticeBtn?.clearBadge()
            }
        }
    }
}

// MARK: - Action
extension MineController {
    @objc private func editAction() {
        let vc = PersonInfoEditController()
        vc.hasIcon = true
        push(vc)
    }
    
    @objc private func noticeAction() {
        push(SystemMsgController())
    }
}

// MARK: -
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
        cell.leftLabel.text = model.type.rawValue
        
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
        case .consult:
            let vc = ConsultController()
            push(vc)
        case .sunnyDrug:
            let vc = SunnyDrugOrderController()
            push(vc)
        case .order:
            let vc = OrderController()
            push(vc)
        case .longService:
            let vc = LongServiceDoctorListController()
            push(vc)
        case .setting:
            let vc = SettingController()
            push(vc)
        }
    }
}
