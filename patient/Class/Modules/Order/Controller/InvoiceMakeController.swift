//
//  InvoiceMakeController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/7.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class InvoiceMakeController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "填写信息"
        setUI()
        setBinding()
        infoView.viewModel.getData()
        addressView.viewModel.getDefaultAddress()
    }

    // MARK: - Public Property
    let viewModel = InvoiceMakeViewModel()
    // MARK: - Private Property
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let infoView = InvoiceMakeInfoView()
    private let addressView = AddressShowView()
    private let submitBtn = UIButton(title: "提交", font: .size(18), titleColor: .cf, backgroundColor: .c407cec)
}

// MARK: - UI
extension InvoiceMakeController {
    override func setUI() {
        scrollView.backgroundColor = .cf0efef
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        submitBtn.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        view.addSubview(submitBtn)
        
        contentView.backgroundColor = .cf0efef
        scrollView.addSubview(contentView)
        
        infoView.invoiceAmountView.rightField.text = String(format: "￥%.2f", viewModel.amount)
        addressView.hasRemark = false
        
        setActions()
        contentView.addSubview(infoView)
        contentView.addSubview(addressView)
        
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
        
        addressView.snp.makeConstraints { (make) in
            make.top.equalTo(infoView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        submitBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottomOffsetFrom(self)
        }
        
        contentView.layoutHeight()
    }
    
    override func setBinding() {
        viewModel.submitResultProperty.signal.observeValues { [weak self] (result) in
            if result {
                self?.pop()
            }
        }
        
        infoView.viewModel.selectTypeProperty.producer.startWithValues { [weak self] (_) in
            self?.contentView.layoutHeight()
        }
        
        let addressEnabledProducer = addressView.viewModel.addressModelProperty.producer.map { $0 != nil }
        let submitEnabledProducer = infoView.infoEnabledProducer.and(addressEnabledProducer)
        
        submitBtn.reactive.isUserInteractionEnabled <~ submitEnabledProducer
        submitBtn.reactive.backgroundColor <~ submitEnabledProducer.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
    }
}

// MARK: - Action
extension InvoiceMakeController {
    @objc private func submitAction() {
        let addressModel = addressView.viewModel.addressModelProperty.value!
        
        let params: [String: Any] = [
            "address": addressModel.address,
            "district": addressModel.district,
            "mobile": addressModel.mobile,
            "realName": addressModel.consignee,
            "puid": patientId,
            "invoiceAmount": viewModel.amount,
            "invoiceTitle": infoView.invoiceTitleView.rightField.text!,
            "invoiceType": infoView.viewModel.selectType,
            "taxpayerNum": infoView.identifyNo,
            "orderIds": viewModel.orderIds,
        ]
        viewModel.submit(params: params)
    }
    
    private func setActions() {
        infoView.contentClosure = { [weak self] in
            let vc = InvoiceContentController()
            vc.viewModel.dataSourceProperty.value = self?.viewModel.orderModels ?? []
            self?.push(vc)
        }
    }
}
