//
//  HomeController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import Moya

class HomeController: BaseController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setBinding()
        viewModel.getBanners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getTasks()
        viewModel.getUnReadMsgCount()
        RCManager.shared.connect(nil)
    }
    
    // MARK: - Properties
    private var noticeItem: ImageTitleView!
    private let headerView = HomeHeaderView()
    private let tableView = UITableView()
    
    private let viewModel = HomeViewModel()
}

// MARK: - UI
extension HomeController {
    override func setUI() {
        hideNavigation = true
        
        headerView.pagerView.dataSource = self
        headerView.pagerView.delegate = self
        
        tableView.set(dataSource: self, delegate: self, separatorStyle: .none, rowHeight: UITableView.automaticDimension)
        tableView.register(cell: UITableViewCell.self)
        tableView.backgroundColor = .cf0efef
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
        
        addNavigationItem(position: .left, title: "扫一扫", imgName: "home_scan", action: #selector(scanAction))
        noticeItem = addNavigationItem(position: .right, title: "消息", imgName: "mine_nav_notice", action: #selector(noticeAction))
        
        setActions()
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(-UIScreen.zz_nav_statusHeight)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    override func setBinding() {
        viewModel.bannerListProperty.signal.observeValues { [weak self] (list) in
            self?.headerView.pagerView.reloadData()
            self?.headerView.pageControl.numberOfPages = list.count
        }
        
        viewModel.taskListProperty.signal.observeValues { [weak self] (list) in
            if let model = list.first {
                self?.headerView.taskView.showEmpty = false
                self?.headerView.taskView.textLabel.text = model.content
                self?.headerView.layoutHeight()
                self?.tableView.tableHeaderView = self?.headerView
                
                self?.headerView.taskView.btn.setTitle(model.taskActionTitle, for: .normal)
            } else {
                self?.headerView.taskView.showEmpty = true
            }
        }
        
        viewModel.unReadMsgCountProperty.signal.skipRepeats().observeValues { [weak self] (value) in
            if value > 0 {
                self?.noticeItem.imgView.showBadge(with: .redDot, value: value, animationType: .none)
                self?.noticeItem.imgView.badgeCenterOffset = CGPoint(x: -5, y: 5)
            } else {
                self?.noticeItem.imgView.clearBadge()
            }
        }
        
        viewModel.taskTipViewModel.drugOrderProperty.signal.skipNil().observeValues { [weak self] result in
            if let order = result.1 {
                let vc = PayController()
                vc.viewModel.orderId = order.orderId
                vc.viewModel.resultAction = PayViewModel.ResultAction(backClassName: self?.zz_className ?? "HomeController", type: .singleSunnyDrug)
                self?.push(vc)
            } else {
                let vc = SunnyDrugBuyController()
                vc.viewModel.did = result.0.gotoJsonDuid
                vc.viewModel.serType = result.0.serType
                self?.push(vc)
            }
        }
    }
}

// MARK: - Action
extension HomeController {
    @objc private func scanAction() {
        push(QRCodeScanController())
    }

    @objc private func noticeAction() {
        push(SystemMsgController())
    }
    
    private func setActions() {
        // 复诊购药
        headerView.actionsView.item1Closure = { [weak self] in
            self?.push(BindedDoctorsController())
        }
        
        // 随访计划
        headerView.actionsView.item2Closure = { [weak self] in
            self?.push(FUVisitPlanController())
        }
        
        // 上传
        headerView.caseView.uploadClosure = { [weak self] in
            self?.toUploadResource()
        }
        
        // 查看
        headerView.caseView.lookClosure = { [weak self] in
            self?.push(ProfileController())
        }
        
        // 更多
        headerView.taskView.moreClosure = { [weak self] in
            self?.push(TaskTipListController())
        }
        
        // 按钮
        headerView.taskView.btnClosure = { [weak self] in
            if let model = self?.viewModel.taskListProperty.value.first {
                guard let self = self else { return }
                switch model.actionType {
                case .buyDrug:
                    self.viewModel.taskTipViewModel.queryBrugOrderInfoByTask(model)
                case .finishQuestion:
                    self.viewModel.taskTipViewModel.toFinishExam(model, from: self)
                case .uploadResource:
                    self.viewModel.taskTipViewModel.toUploadResource(model, from: self)
                case .other:
                    break
                }
                
            }
        }
    }
    
    private func toUploadResource() {
        let vc = UploadResourceController()
        vc.title = "完善资料"
        vc.viewModel.type = .default
        push(vc)
    }
}

// MARK: - Delegate Internal

// MARK: -
// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cell: UITableViewCell.self, for: indexPath)
        return cell
    }
}

// MARK: - Delegate External

// MARK: -
extension HomeController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return viewModel.bannerListProperty.value.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.description(), at: index)
        let model = viewModel.bannerListProperty.value[index]
        cell.imageView?.setImage(with: URL(string: model.imgUrl))
        return cell
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        headerView.pageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let model = viewModel.bannerListProperty.value[index]
        
        guard !model.linkUrl.isEmpty else {
            return
        }
        
        let webVC = WebController()
        webVC.url = URL(string: model.linkUrl)
        push(webVC)
    }
}

// MARK: - Helper
extension HomeController {
    private func configRedDotBadge(badgeView: UIView, show:Bool) -> Void {
        if show {
            badgeView.showBadge(with: .redDot, value: 0, animationType: .none)
            badgeView.badgeCenterOffset = CGPoint(x: -5, y: -1)
        } else {
            badgeView.clearBadge()
        }
    }
}
