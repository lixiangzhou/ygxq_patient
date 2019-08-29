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
    }
    
    // MARK: - Properties
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

        let leftView = ImageTitleView()
        leftView.imgView.contentMode = .center
        leftView.config = config
        leftView.titleLabel.text = "扫一扫"
        leftView.imgView.image = UIImage(named: "home_scan")
        view.addSubview(leftView)
        
        leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scanAction)))
        
        let rightView = ImageTitleView()
        rightView.imgView.contentMode = .center
        rightView.config = config
        rightView.titleLabel.text = "消息"
        rightView.imgView.image = UIImage(named: "mine_nav_notice")
        view.addSubview(rightView)
        
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noticeAction)))
        
        leftView.snp.makeConstraints { (make) in
            make.top.equalTo(25 + UIScreen.zz_statusBar_additionHeight)
            make.left.equalTo(10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        rightView.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(leftView)
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
                self?.headerView.taskView.textLabel.text = model.content
                self?.headerView.layoutHeight()
                self?.tableView.tableHeaderView = self?.headerView
                
                switch model.subType {
                case "CMN_MSG_T_05_01", "CMN_MSG_T_05_02", "CMN_MSG_T_05_06":
                    self?.headerView.taskView.btn.setTitle("去填写", for: .normal)
                case "CMN_MSG_T_05_03", "CMN_MSG_T_05_04", "CMN_MSG_T_05_07":
                    self?.headerView.taskView.btn.setTitle("去完善", for: .normal)
                case "CMN_MSG_T_05_05":
                    self?.headerView.taskView.btn.setTitle("去购药", for: .normal)
                default: self?.headerView.taskView.btn.setTitle("", for: .normal)
                }
            }
        }
    }
}

// MARK: - Action
extension HomeController {
    @objc private func scanAction() {
        let vc = QRCodeScanController()
        push(vc)
    }

    @objc private func noticeAction() {
        print(#function)
        let vc = PayResultController()
        push(vc)
    }
    
    private func setActions() {
        // 复诊购药
        headerView.actionsView.item1Closure = { [weak self] in
            let vc = BindedDoctorsController()
            self?.push(vc)
        }
        
        // 随访计划
        headerView.actionsView.item2Closure = { [weak self] in
            print("随访计划")
        }
        
        // 上传
        headerView.caseView.uploadClosure = { [weak self] in
            print("上传")
        }
        
        // 查看
        headerView.caseView.lookClosure = { [weak self] in
            print("查看")
        }
        
        // 更多
        headerView.taskView.moreClosure = { [weak self] in
            print("更多")
        }
        
        // 按钮
        headerView.taskView.btnClosure = { [weak self] in
            print("按钮")
        }
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
