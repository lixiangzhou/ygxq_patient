//
//  SunnyDrugBuyAddressView.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/2.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SunnyDrugBuyAddressView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    var addressModel: AddressModel? {
        didSet {
            if let model = addressModel {
                addressView.isHidden = false
                addView.isHidden = true
                
                nameView.rightLabel.text = model.consignee.isEmpty ? "  " : model.consignee
                mobileView.rightLabel.text = model.mobile.isEmpty ? "  " : model.mobile.mobileSecrectString
                let addr = model.district + model.address
                addrView.rightLabel.text = addr.isEmpty ? "  " : addr
                
                remarkView.snp.remakeConstraints { (make) in
                    make.top.equalTo(addressView.snp.bottom)
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            } else {
                addressView.isHidden = true
                addView.isHidden = false
                
                remarkView.snp.remakeConstraints { (make) in
                    make.top.equalTo(addView.snp.bottom)
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            }
        }
    }
    var addressChangeClosure: (() -> Void)?
    var addressAddClosure: (() -> Void)?
    
    let addView = UIButton(title: "  创建地址", font: .size(18), titleColor: .c407cec, imageName: "sunny_drug_add_addr")
    let addressView = UIView()
    
    let nameView = TextLeftGrowTextRightView()
    let mobileView = TextLeftGrowTextRightView()
    let addrView = TextLeftGrowTextRightView()
    
    let remarkView = UIView()
    let remarkInputView = NextGrowingTextView()
    
}

// MARK: - UI
extension SunnyDrugBuyAddressView {
    private func setUI() {
        let titleLabel = UILabel(text: "您的收货地址", font: .size(15), textColor: .c6)
        addSubview(titleLabel)
        
        let changeBtn = zz_add(subview: UIButton(title: "更换地址", font: .size(14), titleColor: .c407cec, target: self, action: #selector(changeAddressAction)))
        
        let contentView = zz_add(subview: UIView())
        contentView.zz_setCorner(radius: 6, masksToBounds: true)
        contentView.backgroundColor = .cf
        
        addView.addTarget(self, action: #selector(addAddressAction), for: .touchUpInside)
        addView.addBottomLine()
        contentView.addSubview(addView)
        
        contentView.addSubview(addressView)
        
        let config = TextLeftGrowTextRightViewConfig(leftWidth: 45, leftFont: .boldSize(15), leftTextColor: .c3, leftAlignment: .center, rightPadding: 15, rightFont: .size(15), rightTextColor: .c3, rightAlignment: .left, leftToRightMargin: 0, bottomLineLeftPadding: 15, bottomLineRightPadding: 15)
        
        nameView.config = config
        nameView.leftLabel.text = "姓名"
        
        mobileView.config = config
        mobileView.leftLabel.text = "电话"
        
        addrView.config = config
        addrView.leftLabel.text = "地址"
        
        addressView.addSubview(nameView)
        addressView.addSubview(mobileView)
        addressView.addSubview(addrView)
        
        contentView.addSubview(remarkView)
        let remarkLabel = remarkView.zz_add(subview: UILabel(text: "备注", font: .boldSize(15), textColor: .c3))

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
            make.width.equalTo(45)
        }
        
        remarkInputView.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(remarkLabel.snp.right)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
    }
    
    private func addBackupView() {
        
    }
}

// MARK: - Action
extension SunnyDrugBuyAddressView {
    @objc private func changeAddressAction() {
        addressChangeClosure?()
    }
    
    @objc private func addAddressAction() {
        addressAddClosure?()
    }

}

// MARK: - Helper
extension SunnyDrugBuyAddressView {
    
}

// MARK: - Other
extension SunnyDrugBuyAddressView {
    
}

// MARK: - Public
extension SunnyDrugBuyAddressView {
    
}
