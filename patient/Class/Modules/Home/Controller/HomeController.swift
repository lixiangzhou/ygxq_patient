//
//  HomeController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HomeController: BaseController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getBanners()
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
        tableView.tableFooterView = getFooterView()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        
        addNavigationItem(position: .left, title: "扫医生", imgName: "home_scan", action: #selector(scanAction))
        noticeItem = addNavigationItem(position: .right, title: "消息", imgName: "home_msg", action: #selector(noticeAction))
        
        let titleLabel = view.zz_add(subview: UILabel(text: "阳光客户端", font: .boldSize(20), textColor: .cf))
        
        setActions()
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(38 + UIScreen.zz_statusBar_additionHeight)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setBinding() {
        viewModel.bannerListProperty.signal.observeValues { [weak self] (list) in
            self?.headerView.pagerView.reloadData()
            self?.headerView.pageControl.numberOfPages = list.count
        }
        
        viewModel.taskListProperty.signal.observeValues { [weak self] (list) in
            guard let self = self else { return }
            if let model = list.first {
                self.headerView.taskView.showEmpty = false
                self.headerView.taskView.textLabel.text = model.content
                
                self.headerView.taskView.taskActionLabel.text = model.taskActionTitle
            } else {
                self.headerView.taskView.showEmpty = true
            }
            
            self.headerView.layoutHeight()
            self.tableView.tableHeaderView = self.headerView
            let height = self.headerView.zz_height + self.tableView.tableFooterView!.zz_height
            self.tableView.contentSize = CGSize(width: 0, height: height + 50)
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
        headerView.taskView.taskClosure = { [weak self] in
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
        cell.backgroundColor = .cf0efef
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
    func getFooterView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 44))
        let label = view.zz_add(subview: UILabel(text: "让人人拥有健康变的更简单", font: .size(14), textColor: .c6))
        
        let line1 = view.zz_add(subview: UIView())
        line1.backgroundColor = .c9
        let line2 = view.zz_add(subview: UIView())
        line2.backgroundColor = .c9
        
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        line1.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
            make.height.equalTo(1)
            make.right.equalTo(label.snp.left).offset(-10)
        }
        
        line2.snp.makeConstraints { (make) in
            make.centerY.width.height.equalTo(line1)
            make.left.equalTo(label.snp.right).offset(10)
        }
        return view
    }
}
