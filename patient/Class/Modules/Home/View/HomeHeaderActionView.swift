//
//  HomeHeaderActionView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HomeHeaderActionView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    var item1Closure: (() -> Void)?
    var item2Closure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension HomeHeaderActionView {
    private func setUI() {
        backgroundColor = .cf
        
        let item1View = getItemView(title: "复诊/购药", subTitle: "足不出户 找医生", icon: "home_consult", action: #selector(item1Action))
        let item2View = getItemView(title: "随访计划", subTitle: "随访计划一键查看", icon: "home_plan", action: #selector(item2Action))
        
        addSubview(item1View)
        addSubview(item2View)
        
        let line = zz_add(subview: UIView())
        line.backgroundColor = .cdcdcdc
        
        item1View.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        
        item2View.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(item1View.snp.right)
            make.width.equalTo(item1View)
        }
        
        line.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(80)
        }
    }
    
    func getItemView(title: String, subTitle: String, icon: String, action: Selector) -> ItemView {
        let itemView = ItemView()
        itemView.titleLabel.text = title
        itemView.subTitleLabel.text = subTitle
        itemView.iconView.image = UIImage(named: icon)
        itemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
        return itemView
    }
}

// MARK: - Action
extension HomeHeaderActionView {
    @objc private func item1Action() {
        item1Closure?()
    }
    
    @objc private func item2Action() {
        item2Closure?()
    }
}

// MARK: - Other
extension HomeHeaderActionView {
    class ItemView: BaseView {
        let titleLabel = UILabel(font: .boldSize(18), textColor: .c3)
        let subTitleLabel = UILabel(font: .size(14), textColor: .c6)
        let iconView = UIImageView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            let contentView = zz_add(subview: UIView())
            
            contentView.addSubview(titleLabel)
            contentView.addSubview(subTitleLabel)
            contentView.addSubview(iconView)
            
            contentView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(20)
                make.right.equalTo(-15)
            }
            
            titleLabel.snp.makeConstraints { (make) in
                make.left.top.equalToSuperview()
                make.left.lessThanOrEqualTo(iconView).offset(10)
            }
            
            subTitleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.left.bottom.equalToSuperview()
                make.left.lessThanOrEqualTo(iconView).offset(-5)
            }
            
            iconView.snp.makeConstraints { (make) in
                make.centerY.right.equalToSuperview()
                make.width.equalTo(35)
                make.height.equalTo(35)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
