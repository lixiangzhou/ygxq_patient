//
//  OrderListCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell, IDCell {

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
    
    // MARK: -
    /// 订单号
    let orderNoLabel = UILabel(font: .size(15), textColor: .c9)
    /// 订单创建时间
    let orderCreateTimeLabel = UILabel(font: .size(15), textColor: .c9)
    /// 订单状态
    let orderStateLabel = UILabel(font: .size(15), textColor: .c9)
    /// 订单取消剩余时间
    let orderCancelTimeLabel = UILabel(font: .size(15), textColor: .c9)
    /// 订单类型
    let orderTypeLabel = UILabel(font: .size(17), textColor: .c3)
    /// 订单价格
    let orderPriceLabel = UILabel(font: .size(16), textColor: .cf25555)
}

// MARK: - UI
extension OrderListCell {
    private func setUI() {
        backgroundColor = .white
        
        let orderNoView = contentView.zz_add(subview: UIView())
        let orderNoDescLabel = orderNoView.zz_add(subview: UILabel(text: "订单编号：", font: .size(15), textColor: .c9))
        orderNoView.addSubview(orderNoLabel)
        orderNoView.addSubview(orderCreateTimeLabel)
        
        let orderTypeView = contentView.zz_add(subview: UIView())
        orderTypeView.addSubview(orderTypeLabel)
        orderTypeView.addSubview(orderPriceLabel)
        
        let orderStateView = contentView.zz_add(subview: UIView())
        let orderStateDescLabel = orderStateView.zz_add(subview: UILabel(text: "订单状态：", font: .size(15), textColor: .c9))
        orderStateView.addSubview(orderStateLabel)
        orderStateView.addSubview(orderCancelTimeLabel)
        
        let orderOpView = contentView.zz_add(subview: UIView())
        
        
        let bottomSepView = contentView.zz_add(subview: UIView.sepLine(color: .cf0efef))
        
        addLineTo(orderNoView)
        addLineTo(orderTypeView)
        addLineTo(orderStateView)
        
        // ----------------------------
        orderNoView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        orderNoDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        orderNoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(orderNoDescLabel.snp.right)
            make.centerY.equalToSuperview()
        }
        
        orderCreateTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        // ----------------------------
        orderTypeView.snp.makeConstraints { (make) in
            make.top.equalTo(orderNoView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        orderTypeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(orderNoDescLabel)
            make.centerY.equalToSuperview()
        }
        
        orderPriceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(orderCreateTimeLabel)
            make.centerY.equalToSuperview()
        }
        
        // ----------------------------
        orderStateView.snp.makeConstraints { (make) in
            make.top.equalTo(orderTypeView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        orderStateDescLabel.snp.makeConstraints { (make) in
            make.left.equalTo(orderNoDescLabel)
            make.centerY.equalToSuperview()
        }
        
        orderStateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(orderStateDescLabel.snp.right)
            make.centerY.equalToSuperview()
        }
        
        orderCancelTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(orderCreateTimeLabel)
            make.centerY.equalToSuperview()
        }
        
        // ----------------------------
        orderOpView.snp.makeConstraints { (make) in
            make.top.equalTo(orderStateView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        bottomSepView.snp.makeConstraints { (make) in
            make.top.equalTo(orderOpView.snp.bottom)
            make.height.equalTo(10)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    private func addLineTo(_ view: UIView) {
        let line = view.zz_add(subview: UIView.sepLine())
        line.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Action
extension OrderListCell {
    
}

// MARK: - Network
extension OrderListCell {
    
}

// MARK: - Delegate Internal

// MARK: -

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension OrderListCell {
    
}

// MARK: - Other
extension OrderListCell {
    
}

// MARK: - Public
extension OrderListCell {
    
}

