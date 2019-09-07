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
    }

    // MARK: - Public Property
    let viewModel = InvoiceDetailViewModel()
    // MARK: - Private Property
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let infoView = InvoiceDetailInfoView()
    private let expressView = InvoiceDetailExpressView()
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
        contentView.addSubview(expressView)
        
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
        
        expressView.snp.makeConstraints { (make) in
            make.top.equalTo(infoView.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
    
    override func setBinding() {
        
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

// MARK: - Network
extension InvoiceDetailController {
    
}

// MARK: - Delegate Internal

// MARK: -

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension InvoiceDetailController {
    
}

// MARK: - Other
extension InvoiceDetailController {
    
}

// MARK: - Public
extension InvoiceDetailController {
    
}

