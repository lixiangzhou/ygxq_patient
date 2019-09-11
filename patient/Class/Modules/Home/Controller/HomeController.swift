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
    }
    
    // MARK: - Properties
    private let scanItem = ImageTitleView()
    private let noticeItem = ImageTitleView()
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
        
        addNavigationItems()
        
        setActions()
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(-UIScreen.zz_nav_statusHeight)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    private func addNavigationItems() {
        let config = ImageTitleView.Config(imageSize: CGSize(width: 25, height: 25), verticalHeight1: 0, verticalHeight2: 5, titleLeft: 0, titleRight: 0, titleFont: .size(14), titleColor: .cf)

        scanItem.imgView.contentMode = .center
        scanItem.config = config
        scanItem.titleLabel.text = "扫一扫"
        scanItem.imgView.image = UIImage(named: "home_scan")
        view.addSubview(scanItem)
        
        scanItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scanAction)))
        
        noticeItem.imgView.contentMode = .center
        noticeItem.config = config
        noticeItem.titleLabel.text = "消息"
        noticeItem.imgView.image = UIImage(named: "mine_nav_notice")
        view.addSubview(noticeItem)
        
        noticeItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noticeAction)))
        
        scanItem.snp.makeConstraints { (make) in
            make.top.equalTo(25 + UIScreen.zz_statusBar_additionHeight)
            make.left.equalTo(10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        noticeItem.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(scanItem)
            make.right.equalTo(-10)
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
        
        viewModel.drugOrderProperty.signal.skipNil().observeValues { [weak self] result in
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
                switch model.actionType {
                case .buyDrug:
                    self?.viewModel.queryBrugOrderInfoByTask(model)
                case .finishQuestion:
                    break
                case .uploadResource:
                    self?.toUploadResource()
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
        cell.imageView?.kf.setImage(with: URL(string: model.imgUrl))
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
