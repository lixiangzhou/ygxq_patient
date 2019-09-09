//
//  InvoiceDetailController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class InvoiceDetailController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "开票详情"
        setUI()
        setBinding()
    }

    // MARK: - Public Property
    let viewModel = InvoiceDetailViewModel()
    // MARK: - Private Property
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let infoView = InvoiceDetailInfoView()
    
}

// MARK: - UI
extension InvoiceDetailController {
    override func setUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "具体内容", titleColor: .cf, target: self, action: #selector(invoiceDetailAction))
        
        scrollView.backgroundColor = .cf0efef
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        
        contentView.backgroundColor = .cf0efef
        scrollView.addSubview(contentView)
        
        contentView.addSubview(infoView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(UIScreen.zz_width)
            make.height.equalTo(UIScreen.zz_height)
        }
        
        infoView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
    }
    
    override func setBinding() {
        viewModel.modelProperty.producer.startWithValues { [weak self] (model) in
            guard let self = self, let model = model else { return }
            self.infoView.stateLabel.text = model.invoiceStatus == 1 ? "开票中" : "已开票"
            if model.finishedTime > 0 {
                self.infoView.finishTimeLabel.text = model.finishedTime.toTime(format: "yyyy-MM-dd HH:mm")
            }
            self.infoView.titleView.rightLabel.text = model.invoiceTitle
            self.infoView.idNoView.rightLabel.text = model.taxpayerNum
            self.infoView.amountView.rightLabel.text = String(format: "￥%.2f", model.invoiceAmount)
            self.infoView.createTimeView.rightLabel.text = model.createTime.toTime(format: "yyyy-MM-dd HH:mm")
            
            self.infoView.idNoView.isHidden = model.taxpayerNum.isEmpty
            self.infoView.amountView.snp.updateConstraints { (make) in
                make.top.equalTo(self.infoView.titleView.snp.bottom).offset(model.taxpayerNum.isEmpty ? 0 : 50)
            }
        }
    }
}

// MARK: - Action
extension InvoiceDetailController {
    @objc private func invoiceDetailAction() {
        let vc = InvoiceContentController()
        vc.viewModel.id = viewModel.modelProperty.value?.id ?? 0
        push(vc)
    }
}
