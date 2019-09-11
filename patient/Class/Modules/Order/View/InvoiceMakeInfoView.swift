//
//  InvoiceMakeInfoView.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/9.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class InvoiceMakeInfoView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let titleLabel = UILabel(text: "发票详情", font: .size(15), textColor: .c6)
    
    let titleView = UIView()
    let invoiceTitleView = TextLeftRightFieldView()
    let invoiceIdentifyNoView = TextLeftRightFieldView()
    let invoiceAmountView = TextLeftRightFieldView()
    
    let companyBtn = UIButton(title: "  公司抬头", font: .size(15), titleColor: .c3, imageName: "order_invoice_info_unsel", selectedImageName: "order_invoice_info_sel")
    let notCompanyBtn = UIButton(title: "  个人/非企业单位", font: .size(15), titleColor: .c3, imageName: "order_invoice_info_unsel", selectedImageName: "order_invoice_info_sel")
    
    var contentClosure: (() -> Void)?
    
    let viewModel = InvoiceMakeInfoViewModel()
    
    var infoEnabledProducer: SignalProducer<Bool, NoError>!
    // MARK: - Private Property
    
}

// MARK: - UI
extension InvoiceMakeInfoView {
    private func setUI() {
        backgroundColor = .cf
        titleView.backgroundColor = .cf0efef
        titleView.addSubview(titleLabel)
        addSubview(titleView)
        
        let detailView = LeftRightConfigView()
        detailView.config = LeftRightConfigViewConfig(leftPaddingRight: 0, leftFont: .size(15), rightView: UIImageView.defaultRightArrow(), hasBottomLine: false)
        detailView.leftLabel.text = "具体内容"
        detailView.isUserInteractionEnabled = true
        detailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contentAction)))

        let titleString = "发票抬头"
        let idNoString = "纳税人识别号"
        
        invoiceAmountView.leftLabel.text = "发票金额"
        invoiceAmountView.rightField.isUserInteractionEnabled = false
        
        invoiceTitleView.config = TextLeftRightFieldViewConfig(leftFont: .size(15), rightWidth: UIScreen.zz_width - 30 - titleString.zz_size(withLimitWidth: 1000, fontSize: 15).width - 15, rightLimit: 30)
        
        invoiceIdentifyNoView.config = TextLeftRightFieldViewConfig(leftFont: .size(15), rightWidth: UIScreen.zz_width - 30 - idNoString.zz_size(withLimitWidth: 1000, fontSize: 15).width - 15, rightLimit: 20)
        
        invoiceAmountView.config = TextLeftRightFieldViewConfig(leftFont: .size(15), rightWidth: UIScreen.zz_width - 30 - invoiceAmountView.leftLabel.text!.zz_size(withLimitWidth: 1000, fontSize: 15).width - 15, rightLimit: 20)
        
        invoiceTitleView.leftLabel.attributedText = "发票抬头".needed(with: .size(15), color: .c3)
        invoiceTitleView.rightField.placeholder = "请填写发票抬头"
        
        invoiceIdentifyNoView.leftLabel.attributedText = "纳税人识别号".needed(with: .size(15), color: .c3)
        invoiceIdentifyNoView.rightField.placeholder = "请填写纳税人识别号"
        
        invoiceAmountView.rightField.textColor = .cf25555

        addSubview(titleView)
        let selView = addSelectView()
        addSubview(invoiceTitleView)
        addSubview(invoiceIdentifyNoView)
        addSubview(invoiceAmountView)
        addSubview(detailView)
        
        titleView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(45)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        selView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        invoiceTitleView.snp.makeConstraints { (make) in
            make.top.equalTo(selView.snp.bottom)
            make.left.right.height.equalTo(selView)
        }
        
        invoiceIdentifyNoView.snp.makeConstraints { (make) in
            make.top.equalTo(invoiceTitleView.snp.bottom)
            make.left.right.height.equalTo(selView)
        }
        
        invoiceAmountView.snp.makeConstraints { (make) in
            make.top.equalTo(invoiceTitleView.snp.bottom).offset(50)
            make.left.right.height.equalTo(selView)
        }
        
        detailView.snp.makeConstraints { (make) in
            make.top.equalTo(invoiceAmountView.snp.bottom)
            make.left.right.height.equalTo(selView)
            make.bottom.equalToSuperview()
        }
    }
    
    func setBinding() {
        viewModel.invoiceModelProperty.signal.observeValues { [weak self] (model) in
            self?.invoiceTitleView.rightField.text = model?.invoiceTitle
            self?.invoiceIdentifyNoView.rightField.text = model?.taxpayerNum
            
            self?.invoiceTitleView.rightField.sendActions(for: .editingChanged)
            self?.invoiceIdentifyNoView.rightField.sendActions(for: .editingChanged)
            switch model?.invoiceType {
            case "PAY_INV_T_01":
                self?.viewModel.selectTypeProperty.value = .company
            case "PAY_INV_T_02":
                self?.viewModel.selectTypeProperty.value = .notCompany
            default: break
            }
        }
        
        viewModel.selectTypeProperty.producer.startWithValues { [weak self] (type) in
            guard let self = self else { return }
            switch type {
            case .company:
                self.companyBtn.isSelected = true
                self.notCompanyBtn.isSelected = false
                self.invoiceIdentifyNoView.isHidden = false
                
                self.invoiceAmountView.snp.updateConstraints { (make) in
                    make.top.equalTo(self.invoiceTitleView.snp.bottom).offset(50)
                }
            case .notCompany:
                self.companyBtn.isSelected = false
                self.notCompanyBtn.isSelected = true
                self.invoiceIdentifyNoView.isHidden = true
                
                self.invoiceAmountView.snp.updateConstraints { (make) in
                    make.top.equalTo(self.invoiceTitleView.snp.bottom).offset(0)
                }
            }
        }
        
        
        let selectCompanyEnabledProducer = viewModel.selectTypeProperty.producer.map { $0 == .company }
        let selectUnCompanyEnabledProducer = viewModel.selectTypeProperty.producer.map { $0 == .notCompany }
        
        let titleEnabledProducer = invoiceTitleView.rightField.reactive.continuousTextValues.map { !$0.isEmpty }
        
        let idNoEnabledProducer = invoiceIdentifyNoView.rightField.reactive.continuousTextValues.map { $0.count >= 16 }
        
        let companyEnabledProducer = selectCompanyEnabledProducer.and(titleEnabledProducer).and(idNoEnabledProducer)
        let notCompanyEnabledProducer = selectUnCompanyEnabledProducer.and(titleEnabledProducer)
        
        infoEnabledProducer = companyEnabledProducer.or(notCompanyEnabledProducer)
    }
    
    private func addSelectView() -> UIView {
        let selView = zz_add(subview: UIView())
        
        let leftLabel = selView.zz_add(subview: UILabel(font: .size(15), textColor: .c3)) as! UILabel
        leftLabel.attributedText = "抬头类型".needed(with: leftLabel.font, color: leftLabel.textColor)
        selView.addSubview(companyBtn)
        selView.addSubview(notCompanyBtn)
        selView.addBottomLine()
        
        companyBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (btn) in
            self?.viewModel.selectTypeProperty.value = .company
        }
        
        notCompanyBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (btn) in
            self?.viewModel.selectTypeProperty.value = .notCompany
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        companyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
        
        notCompanyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(companyBtn.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
        
        return selView
    }
}

// MARK: - Action
extension InvoiceMakeInfoView {
    @objc private func contentAction() {
        contentClosure?()
    }
}

// MARK: - Helper
extension InvoiceMakeInfoView {
    var identifyNo: String {
        switch viewModel.selectTypeProperty.value {
        case .company:
            return invoiceIdentifyNoView.rightField.text ?? ""
        case .notCompany:
            return ""
        }
    }
}
