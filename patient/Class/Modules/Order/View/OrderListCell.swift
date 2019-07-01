//
//  OrderListCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell, IDView {

    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("OrderListCell deinit")
    }
    
    // MARK: -
    /// 订单号
    let orderNoLabel = UILabel(font: .size(15), textColor: .c6)
    /// 订单创建时间
    let orderCreateTimeLabel = UILabel(font: .size(15), textColor: .c6)
    /// 订单状态：
    let orderStateDescLabel = UILabel(font: .size(15), textColor: .c6)
    /// 订单状态
    let orderStateLabel = UILabel(font: .size(15), textColor: .c6)
    /// 订单取消剩余时间
    let orderCancelTimeLabel = UILabel(font: .size(15), textColor: .c6)
    /// 订单类型
    let orderTypeLabel = UILabel(font: .size(17), textColor: .c3)
    /// 订单价格
    let orderPriceLabel = UILabel(font: .size(16), textColor: .cf25555)
    
    var cancelOrderClosure: (() -> Void)?
    var payOrderClosure: (() -> Void)?
    
    var deleteOrderClosure: (() -> Void)?
    var refundOrderClosure: (() -> Void)?
    var orderDetailClosure: (() -> Void)?
    
    var refundDetailClosure: (() -> Void)?
    
    let toPayView = OrderToPayOpView()
    let payedView = OrderPayedOpView()
    let refundView = OrderRefundOpView()
}

// MARK: - UI
extension OrderListCell {
    private func setUI() {
        backgroundColor = .white
        
        let orderNoView = contentView.zz_add(subview: UIView())
        let orderNoDescLabel = orderNoView.zz_add(subview: UILabel(text: "订单编号:", font: .size(15), textColor: .c6))
        orderNoView.addSubview(orderNoLabel)
        orderNoView.addSubview(orderCreateTimeLabel)
        
        let orderTypeView = contentView.zz_add(subview: UIView())
        orderTypeView.addSubview(orderTypeLabel)
        orderTypeView.addSubview(orderPriceLabel)
        
        let orderStateView = contentView.zz_add(subview: UIView())
        orderStateView.addSubview(orderStateDescLabel)
        orderStateView.addSubview(orderStateLabel)
        orderStateView.addSubview(orderCancelTimeLabel)
        
        let orderOpView = contentView.zz_add(subview: UIView())
        orderOpView.addSubview(toPayView)
        orderOpView.addSubview(payedView)
        orderOpView.addSubview(refundView)
        
        toPayView.cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        toPayView.payBtn.addTarget(self, action: #selector(payAction), for: .touchUpInside)
        
        payedView.deleteBtn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        payedView.refundBtn.addTarget(self, action: #selector(refundAction), for: .touchUpInside)
        payedView.detailBtn.addTarget(self, action: #selector(detailAction), for: .touchUpInside)
        
        refundView.detailBtn.addTarget(self, action: #selector(refundDetailAction), for: .touchUpInside)
        refundView.deleteBtn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        
        let bottomSepView = contentView.zz_add(subview: UIView.sepLine(color: .cf0efef))
        
        orderNoView.addBottomLine(left: 15, right: 15)
        orderTypeView.addBottomLine(left: 15, right: 15)
        orderStateView.addBottomLine(left: 15, right: 15)
        
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
        
        toPayView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        payedView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        refundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        bottomSepView.snp.makeConstraints { (make) in
            make.top.equalTo(orderOpView.snp.bottom)
            make.height.equalTo(10)
            make.bottom.left.right.equalToSuperview()
        }
    }
}

// MARK: - Action
extension OrderListCell {
    @objc private func cancelAction() {
        cancelOrderClosure?()
    }
    
    @objc private func payAction() {
        payOrderClosure?()
    }
    
    @objc private func deleteAction() {
        deleteOrderClosure?()
    }
    
    @objc private func refundAction() {
        refundOrderClosure?()
    }
    
    @objc private func detailAction() {
        orderDetailClosure?()
    }
    
    @objc private func refundDetailAction() {
        refundDetailClosure?()
    }
}

// MARK: - Helper
extension OrderListCell {
    class OrderToPayOpView: UIView {
        // MARK: - LifeCycle
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            cancelBtn.zz_setCorner(radius: 15, masksToBounds: true)
            cancelBtn.zz_setBorder(color: .cdcdcdc, width: 1)
            
            payBtn.zz_setCorner(radius: 15, masksToBounds: true)
            payBtn.zz_setBorder(color: .c407cec, width: 1)
            
            addSubview(cancelBtn)
            addSubview(payBtn)
            
            cancelBtn.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 90, height: 30))
            }
            
            payBtn.snp.makeConstraints { (make) in
                make.size.centerY.equalTo(cancelBtn)
                make.left.equalTo(cancelBtn.snp.right).offset(10)
                make.right.equalTo(-15)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let cancelBtn = UIButton(title: "取消订单", font: .size(16), titleColor: .c9)
        let payBtn = UIButton(title: "去支付", font: .size(16), titleColor: .c407cec)
    }
    
    class OrderPayedOpView: UIView {
        // MARK: - LifeCycle
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            deleteBtn.zz_setCorner(radius: 15, masksToBounds: true)
            deleteBtn.zz_setBorder(color: .cdcdcdc, width: 1)
            
            refundBtn.zz_setCorner(radius: 15, masksToBounds: true)
            refundBtn.zz_setBorder(color: .c407cec, width: 1)
            
            detailBtn.zz_setCorner(radius: 15, masksToBounds: true)
            detailBtn.zz_setBorder(color: .c407cec, width: 1)
            
            addSubview(deleteBtn)
            addSubview(refundBtn)
            addSubview(detailBtn)
            
            deleteBtn.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 90, height: 30))
            }
            
            refundBtn.snp.makeConstraints { (make) in
                make.size.centerY.equalTo(deleteBtn)
                make.left.equalTo(deleteBtn.snp.right).offset(10)
                make.right.equalTo(detailBtn).offset(-100)
            }
            
            detailBtn.snp.makeConstraints { (make) in
                make.size.centerY.equalTo(deleteBtn)
                make.right.equalTo(-15)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setShowDetail(_ show: Bool) {
            detailBtn.isHidden = !show
            refundBtn.snp.updateConstraints { (make) in
                make.right.equalTo(detailBtn).offset(show ? -100 : 0)
            }
        }
        
        let deleteBtn = UIButton(title: "删除订单", font: .size(16), titleColor: .c9)
        let refundBtn = UIButton(title: "退款", font: .size(16), titleColor: .c407cec)
        let detailBtn = UIButton(title: "订单详情", font: .size(16), titleColor: .c407cec)
    }
    
    
    class OrderRefundOpView: UIView {
        // MARK: - LifeCycle
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            deleteBtn.zz_setCorner(radius: 15, masksToBounds: true)
            deleteBtn.zz_setBorder(color: .cdcdcdc, width: 1)
            
            detailBtn.zz_setCorner(radius: 15, masksToBounds: true)
            detailBtn.zz_setBorder(color: .c407cec, width: 1)
            
            addSubview(deleteBtn)
            addSubview(detailBtn)
            
            deleteBtn.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 90, height: 30))
            }
            
            detailBtn.snp.makeConstraints { (make) in
                make.size.centerY.equalTo(deleteBtn)
                make.left.equalTo(deleteBtn.snp.right).offset(10)
                make.right.equalTo(-15)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let deleteBtn = UIButton(title: "删除订单", font: .size(16), titleColor: .c9)
        let detailBtn = UIButton(title: "退款详情", font: .size(16), titleColor: .c407cec)
    }
}
