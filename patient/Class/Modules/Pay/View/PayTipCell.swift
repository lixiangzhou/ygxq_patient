//
//  PayTipCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class PayTipCell: UITableViewCell {
    
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
    var serviceClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension PayTipCell {
    private func setUI() {
        backgroundColor = .cf0efef
        
        let titleLabel = UILabel(text: "温馨提示", font: .size(13), textColor: .c6)
        let tipLabel = LinkedLabel(text: "请在18分钟内完成付款，否则将自动取消该订单，签字既同意《\(appService)》", font: .size(13), textColor: .c6)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(tipLabel)
        
        tipLabel.addLinks([(string: "《\(appService)》", attributes: [NSAttributedString.Key.foregroundColor: UIColor.c407cec], action: { [weak self] _ in
            self?.serviceClosure?()
        })])

        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.right.bottom.equalTo(-15)
        }
    }
}
