//
//  AddressShowView.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/9.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class AddressShowView: BaseView {
    
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
    let viewModel = AddressShowViewModel()
    
    var hasRemark = true
    
    let titleLabel = UILabel(text: "收货地址", font: .size(15), textColor: .c6)
    
    let addView = UIButton(title: "  创建地址", font: .size(18), titleColor: .c407cec, imageName: "sunny_drug_add_addr")
    let addressView = UIView()
    
    let nameView = TextLeftGrowTextRightView()
    let mobileView = TextLeftGrowTextRightView()
    let addrView = TextLeftGrowTextRightView()
    
    let remarkView = UIView()
    let remarkInputView = NextGrowingTextView()
    
}

// MARK: - UI
extension AddressShowView {
    private func setUI() {
        addSubview(titleLabel)
        
        let changeBtn = zz_add(subview: UIButton(title: "更换地址", font: .size(13), titleColor: .c407cec, target: self, action: #selector(changeAddressAction)))
        
        let contentView = zz_add(subview: UIView())
        contentView.zz_setCorner(radius: 6, masksToBounds: true)
        contentView.backgroundColor = .cf
        
        addView.addTarget(self, action: #selector(addAddressAction), for: .touchUpInside)
        addView.addBottomLine()
        contentView.addSubview(addView)
        
        contentView.addSubview(addressView)
        
        let config = TextLeftGrowTextRightViewConfig(leftTopPadding: 15, leftBottomPadding: 15, leftWidth: 70, leftFont: .size(15), leftTextColor: .c3, leftAlignment: .center, rightPadding: 15, rightTopPadding: 15, rightBottomPadding: 15, rightFont: .size(15), rightTextColor: .c3, rightAlignment: .left, leftToRightMargin: 0, bottomLineLeftPadding: 15, bottomLineRightPadding: 15)
        
        nameView.config = config
        nameView.leftLabel.text = "姓名"
        
        mobileView.config = config
        mobileView.leftLabel.text = "手机号"
        
        addrView.config = config
        addrView.leftLabel.text = "收货地址"
        
        addressView.addSubview(nameView)
        addressView.addSubview(mobileView)
        addressView.addSubview(addrView)
        
        contentView.addSubview(remarkView)
        let remarkLabel = remarkView.zz_add(subview: UILabel(text: "备注", font: .size(15), textColor: .c3))
        
        remarkInputView.textView.textColor = .c3
        remarkInputView.textView.font = .size(15)
        remarkInputView.minNumberOfLines = 1
        remarkInputView.maxNumberOfLines = 4
        remarkInputView.inputLimit = 100
        remarkInputView.textView.keyboardDismissMode = .onDrag
        remarkInputView.textView.showsVerticalScrollIndicator = false
        let attrString = NSMutableAttributedString(string: "可输入特殊要求", attributes: [NSAttributedString.Key.foregroundColor: UIColor.fieldDefaultColor, NSAttributedString.Key.font: UIFont.size(15)])
        remarkInputView.placeholderAttributedText = attrString
        remarkView.addSubview(remarkInputView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(45)
        }
        
        changeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.height.equalTo(titleLabel)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalToSuperview()
        }
        
        addressView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
        }
        
        nameView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        mobileView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        addrView.snp.makeConstraints { (make) in
            make.top.equalTo(mobileView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        addView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        
        remarkView.snp.makeConstraints { (make) in
            make.top.equalTo(addressView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        remarkLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(43)
        }
        
        remarkInputView.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(remarkLabel.snp.right)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
    }
    
    private func setBinding() {
        viewModel.addressModelProperty.producer.startWithValues { [weak self] (addressModel) in
            guard let self = self else { return }
            
            self.remarkView.isHidden = !self.hasRemark
            
            if let model = addressModel {
                self.addressView.isHidden = false
                self.addView.isHidden = true
                
                self.nameView.rightLabel.text = model.consignee.isEmpty ? "  " : model.consignee
                self.mobileView.rightLabel.text = model.mobile.isEmpty ? "  " : model.mobile.mobileSecrectString
                let addr = model.district + model.address
                self.addrView.rightLabel.text = addr.isEmpty ? "  " : addr
                
                self.remarkView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.addressView.snp.bottom)
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                    if !self.hasRemark {
                        make.height.equalTo(0)
                    }
                }
            } else {
                self.addressView.isHidden = true
                self.addView.isHidden = false
                
                self.remarkView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.addView.snp.bottom)
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                    if !self.hasRemark {
                        make.height.equalTo(0)
                    }
                }
            }
        }
    }
}

// MARK: - Action
extension AddressShowView {
    @objc private func changeAddressAction() {
        let vc = AddressListController()
        vc.didSelectAddressClosure = { [weak self] model in
            if model == nil {
                self?.viewModel.getDefaultAddress()
            } else {
                self?.viewModel.addressModelProperty.value = model
            }
        }
        zz_controller?.push(vc)
    }
    
    @objc private func addAddressAction() {
        let vc = AddressEditController()
        vc.completionClosure = { [weak self] in
            self?.viewModel.getDefaultAddress()
        }
        zz_controller?.push(vc)
    }
}
