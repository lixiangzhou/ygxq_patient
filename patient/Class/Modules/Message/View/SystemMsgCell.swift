//
//  SystemMsgCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/20.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class SystemMsgCell: UITableViewCell {
    
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
    let msgLabel = UILabel(font: .size(14), textColor: .c3)
    var isRead = true {
        didSet {
            msgLabel.textColor = isRead ? .c6 : .c3
            
            let value = isRead ? 0 : 15
            unReadLabel.text = isRead ? nil : "未读"
            unReadLabel.snp.updateConstraints { (make) in
                make.top.equalTo(msgLabel.snp.bottom).offset(value)
            }
        }
    }
    // MARK: - Private Property
    private let unReadLabel = UILabel(text: "未读", font: .size(13), textColor: .cf25555)
}

// MARK: - UI
extension SystemMsgCell {
    private func setUI() {
        contentView.backgroundColor = .cf
        
        contentView.addSubview(msgLabel)
        contentView.addSubview(unReadLabel)
        contentView.addBottomLine()
        
        msgLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        unReadLabel.snp.makeConstraints { (make) in
            make.top.equalTo(msgLabel.snp.bottom).offset(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
    }
}
