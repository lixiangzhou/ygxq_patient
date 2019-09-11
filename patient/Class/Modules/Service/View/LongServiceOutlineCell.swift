//
//  LongServiceOutlineCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/17.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class LongServiceOutlineCell: UITableViewCell {
    
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
    let titleLabel = UILabel(font: .boldSize(17), textColor: .c3, textAlignment: .center)
    let featureLabel = UILabel(font: .size(16), textColor: .c3)
    let contentDescLabel = UILabel(font: .size(16), textColor: .c3)
    
    /// 此属性必须设置
    var showFeature = true {
        didSet {
            featureView.isHidden = !showFeature
            if showFeature {
                featureView.snp.remakeConstraints { (make) in
                    make.top.equalTo(titleLabel.snp.bottom).offset(14)
                    make.left.equalTo(12)
                    make.right.equalTo(-12)
                }
                
                contentDescView.snp.remakeConstraints { (make) in
                    make.top.equalTo(featureView.snp.bottom).offset(14)
                    make.left.right.equalTo(featureView)
                    make.bottom.equalTo(-12)
                }
            } else {
                contentDescView.snp.remakeConstraints { (make) in
                    make.top.equalTo(titleLabel.snp.bottom).offset(14)
                    make.left.equalTo(12)
                    make.right.equalTo(-12)
                    make.bottom.equalTo(-12)
                }
            }
        }
    }
    // MARK: - Private Property
    private let featureView = UIView()
    private let contentDescView = UIView()
    
}

// MARK: - UI
extension LongServiceOutlineCell {
    private func setUI() {
        contentView.backgroundColor = .cf0efef
        
        let view = contentView.zz_add(subview: UIView())
        view.backgroundColor = .cf
        view.zz_setCorner(radius: 8, masksToBounds: true)
        
        let featureTitleLabel = featureView.zz_add(subview: UILabel(text: "商品特色", font: .boldSize(17), textColor: .c3))
        featureView.addSubview(featureLabel)
        
        let contentTitleLabel = contentDescView.zz_add(subview: UILabel(text: "商品内容描述", font: .boldSize(17), textColor: .c3))
        contentDescView.addSubview(contentDescLabel)
        
        view.addSubview(titleLabel)
        view.addSubview(featureView)
        view.addSubview(contentDescView)
        
        view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-12)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(14)
        }
        
        featureTitleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        
        featureLabel.snp.makeConstraints { (make) in
            make.top.equalTo(featureTitleLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentTitleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        
        contentDescLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentTitleLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Action
extension LongServiceOutlineCell {
    
}

// MARK: - Helper
extension LongServiceOutlineCell {
    
}

// MARK: - Other
extension LongServiceOutlineCell {
    
}

// MARK: - Public
extension LongServiceOutlineCell {
    
}
