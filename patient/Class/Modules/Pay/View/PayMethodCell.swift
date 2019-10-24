//
//  PayMethodCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class PayMethodCell: UITableViewCell {
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension PayMethodCell {
    private func setUI() {
        contentView.backgroundColor = .cf0efef
        
        let titleLabel = UILabel(text: "选择支付方式", font: .size(15), textColor: .c6)
        
        let wxPayView = LeftRightConfigView()
        wxPayView.backgroundColor = .cf
        wxPayView.config = LeftRightConfigViewConfig(leftView: UIImageView(image: UIImage(named: "pay_wx")), leftViewSize: CGSize(width: 30, height: 30), leftPaddingLeft: 17, leftPaddingRight: 12, leftFont: .size(17), leftTextColor: .c3, rightView: UIButton(backgroundImageName: "pay_sel2", hilightedBackgroundImageName: "pay_sel2"), rightViewSize: CGSize(width: 27, height: 27), rightPadding: 15, hasBottomLine: false)
        wxPayView.leftLabel.text = "微信支付"
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(wxPayView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        wxPayView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(55)
        }
    }
}
