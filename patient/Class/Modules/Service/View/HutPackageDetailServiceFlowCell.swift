//
//  HutPackageDetailServiceFlowCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/18.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HutPackageDetailServiceFlowCell: UITableViewCell {
    
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
    var progress: [String]? {
        didSet {
            for v in flowView.subviews {
                v.removeFromSuperview()
            }
            
            guard let progress = progress else {
                return
            }
            
            var lastView: ItemView?
            for (idx, p) in progress.enumerated() {
                let view = ItemView()
                view.txtLabel.text = p
                flowView.addSubview(view)
                
                let isLast = (idx == progress.count - 1)
                if let lastView = lastView {
                    view.snp.makeConstraints { (maker) in
                        maker.right.left.equalToSuperview()
                        maker.top.equalTo(lastView.snp.bottom)
                        if isLast {
                            maker.bottom.equalToSuperview()
                        }
                    }
                    
                    let line = flowView.zz_add(subview: UIView())
                    line.backgroundColor = .cffa84c
                    line.snp.makeConstraints { (make) in
                        make.top.equalTo(lastView.iconView.snp.bottom)
                        make.centerX.equalTo(lastView.iconView.snp.centerX)
                        make.bottom.equalTo(view.iconView.snp.top)
                        make.width.equalTo(1)
                    }
                } else {
                    view.snp.makeConstraints { (maker) in
                        maker.top.right.left.equalToSuperview()
                        if isLast {
                            maker.bottom.equalToSuperview()
                        }
                    }
                }
                lastView = view
            }
            
            
            
        }
    }
    
    // MARK: - Private Property
    let flowView = UIView()
}

// MARK: - UI
extension HutPackageDetailServiceFlowCell {
    private func setUI() {
        backgroundColor = .cf0efef
        
        let whiteView = contentView.zz_add(subview: UIView())
        whiteView.zz_setCorner(radius: 6, masksToBounds: true)
        whiteView.backgroundColor = .cf
        
        let titleLabel = whiteView.zz_add(subview: UILabel(text: "服务流程", font: .boldSize(17), textColor: .c3))
        whiteView.addSubview(flowView)
        
        whiteView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.bottom.equalTo(-15)
            make.right.equalTo(-15)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        flowView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(-15)
        }
    }
}

// MARK: - Action
extension HutPackageDetailServiceFlowCell {
    
}

// MARK: - Helper
extension HutPackageDetailServiceFlowCell {
    
}

// MARK: - Other
extension HutPackageDetailServiceFlowCell {
    class ItemView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(iconView)
            addSubview(txtLabel)
            
            iconView.snp.makeConstraints { (make) in
                make.width.height.equalTo(20)
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
            txtLabel.snp.makeConstraints { (make) in
                make.top.equalTo(10)
                make.left.equalTo(iconView.snp.right).offset(15)
                make.right.equalToSuperview()
                make.bottom.lessThanOrEqualTo(-10)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let iconView = UIImageView(image: UIImage(named: "hutdetail_flow"))
        let txtLabel = UILabel(font: .size(16), textColor: .c3)
    }
}

// MARK: - Public
extension HutPackageDetailServiceFlowCell {
    
}
