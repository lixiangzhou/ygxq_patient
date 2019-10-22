//
//  CaseDetailCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/22.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class CaseDetailCell: UITableViewCell {
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Properties
    var record: CaseDetailViewModel.Record! {
        didSet {
            titleLabel.text = record.title
            txtLabel.text = record.subTitle
            
            if record.subTitle.zz_size(withLimitWidth: UIScreen.zz_width, fontSize: 16).width <= UIScreen.zz_width - 130 {
                txtLabel.textAlignment = .right
                txtLabel.snp.remakeConstraints { (maker) in
                    maker.centerY.equalTo(titleLabel)
                    maker.right.equalTo(-15)
                    maker.left.equalTo(115)
                }
            } else {
                txtLabel.textAlignment = .left
                txtLabel.snp.remakeConstraints { (maker) in
                    maker.top.equalTo(titleLabel.snp.bottom).offset(15)
                    maker.right.equalTo(-15)
                    maker.left.equalTo(15)
                    maker.bottom.equalTo(-15)
                }
            }
        }
    }
    
    // MARK: - Private Properties
    private let titleLabel = UILabel(font: .size(16), textColor: .c3)
    private let txtLabel = UILabel(font: .boldSize(16), textColor: .c3)
}

// MARK: - UI
extension CaseDetailCell {
    private func setUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(txtLabel)
        
        contentView.addBottomLine()
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(15)
            maker.left.equalTo(15)
            maker.bottom.lessThanOrEqualTo(-15)
        }
        
//        txtLabel.snp.makeConstraints { (maker) in
//            maker.left.equalTo(titleLabel)
//            maker.top.equalTo(titleLabel.snp.bottom).offset(5)
//            maker.right.equalTo(-15)
//        }
    }
}
