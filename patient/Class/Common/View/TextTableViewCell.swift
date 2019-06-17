//
//  TextTableViewCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import SnapKit

class TextTableViewCell: UITableViewCell, IDCell {
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        separatorInset = .zero
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var config: TextTableViewCellConfig? {
        didSet {
            if config == oldValue {
                return
            }
            
            guard let config = config else {
                return
            }
            
            // LeftView
            if let lv = config.leftView {
                leftView.isHidden = false
                leftView.zz_removeAllSubviews()
                
                leftView.addSubview(lv)
                
                leftView.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(config.leftPaddingLeft)
                    make.right.equalTo(titleLabel.snp.left).offset(-config.leftPaddingRight)
                }
                
                if let size = config.leftViewSize {
                    lv.snp.makeConstraints { (make) in
                        make.size.equalTo(size)
                        make.edges.equalToSuperview()
                    }
                } else {
                    lv.sizeToFit()
                    lv.snp.makeConstraints { (make) in
                        make.size.equalTo(lv.zz_size)
                        make.edges.equalToSuperview()
                    }
                }
                
            } else {
                leftView.isHidden = true
                leftView.zz_removeAllSubviews()
                
                leftView.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(config.leftPaddingLeft)
                    make.width.equalTo(0)
                    make.right.equalTo(titleLabel.snp.left).offset(0)
                }
            }
            
            
            // Title
            titleLabel.font = config.font
            titleLabel.textColor = config.textColor
            titleLabel.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
            }
            
            // RightView
            if let rv = config.rightView {
                rightView.isHidden = false
                rightView.zz_removeAllSubviews()
                
                rightView.addSubview(rv)
                
                rightView.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.right.equalTo(-config.rightPadding)
                }
                
                if let size = config.rightViewSize {
                    rv.snp.makeConstraints { (make) in
                        make.size.equalTo(size)
                        make.edges.equalToSuperview()
                    }
                } else {
                    rv.sizeToFit()
                    rv.snp.makeConstraints { (make) in
                        make.edges.equalToSuperview()
                    }
                }
                
            } else {
                rightView.isHidden = true
            }
            
            // BottomLine
            bottomLine.isHidden = !config.hasBottomLine
            bottomLine.backgroundColor = config.bottomLineColor
            bottomLine.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.height.equalTo(config.bottomLineHeight)
                make.left.equalTo(config.bottomLineLeftPadding)
                make.right.equalTo(-config.bottomLineRightPadding)
            }
        }
    }
    
    // MARK: - Public Property
    static let cellHeight: CGFloat = 44
    
    
    // MARK: - Private Property
    let leftView = UIView()
    let titleLabel = UILabel()
    let rightView = UIView()
    let bottomLine = UIView()
}

// MARK: - UI
extension TextTableViewCell {
    fileprivate func setUI() {
        contentView.addSubview(leftView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightView)
        contentView.addSubview(bottomLine)
        
        config = TextTableViewCellConfig()
    }
}


extension TextTableViewCell {
    var leftIconView: UIImageView? {
        return config?.leftView as? UIImageView
    }
}
