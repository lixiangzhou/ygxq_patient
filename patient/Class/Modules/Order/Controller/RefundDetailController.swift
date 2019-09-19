//
//  RefundDetailController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/25.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class RefundDetailController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "退款详情"
        setUI()
        setData()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let stateLabel = UILabel(font: .boldSize(17), textColor: .cf)
    private let timeLabel = UILabel(font: .size(16), textColor: .cf)
    private var refundFailReasonLabel: UILabel!
    private var refundAmountLabel: UILabel!
    private var refundReasonLabel: UILabel!
    private var orderNoLabel: UILabel!
    private var nameLabel: UILabel!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var refundFailReasonView: UIView!
    private let refundAmountView = TextLeftRightView()
    private var refundInfoView: UIView!
    
    let viewModel = RefundDetailViewModel()
}

// MARK: - UI
extension RefundDetailController {
    override func setUI() {
        scrollView.backgroundColor = .cf0efef
        view.addSubview(scrollView)
        
        contentView.backgroundColor = .cf
        scrollView.addSubview(contentView)
        
        let stateView = getStateView()
        contentView.addSubview(stateView)
        
        refundFailReasonView = getFailReasonView()
        contentView.addSubview(refundFailReasonView)
        
        refundAmountView.config = TextLeftRightViewConfig(leftTextColor: .c6, rightTextColor: .cf25555)
        refundAmountView.leftLabel.text = "退款总金额"
        refundAmountLabel = refundAmountView.rightLabel
        contentView.addSubview(refundAmountView)
        
        let refundReasonView = getRefundReasonView()
        contentView.addSubview(refundReasonView)
        
        refundInfoView = getRefundInfoView()
        contentView.addSubview(refundInfoView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(view.snp.width)
            make.height.equalTo(UIScreen.zz_height)
        }
        
        stateView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        refundFailReasonView.snp.makeConstraints { (make) in
            make.top.equalTo(stateView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        refundAmountView.snp.makeConstraints { (make) in
            make.top.equalTo(stateView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        refundReasonView.snp.makeConstraints { (make) in
            make.top.equalTo(refundAmountView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        refundInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(refundReasonView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        updateView()
    }
    
    private func updateView() {
        view.layoutIfNeeded()
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(refundInfoView.zz_maxY)
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.zz_width, height: refundInfoView.zz_maxY)
    }
    
    private func getStateView() -> UIView {
        let stateView = UIView()
        stateView.backgroundColor = .cf
        
        let stateBgView = UIView()
        
        let stateRoundBgView = UIView()
        stateRoundBgView.backgroundColor = .c407cec
        stateRoundBgView.zz_setCorner(radius: 8, masksToBounds: true)
        
        let stateBottomBgView = UIView()
        stateBottomBgView.backgroundColor = .c407cec
        
        stateView.addSubview(stateBgView)
        stateBgView.addSubview(stateRoundBgView)
        stateBgView.addSubview(stateBottomBgView)
        
        let stateDescLabel = stateBgView.zz_add(subview: UILabel(text: "订单状态及下单时间", font: .size(16), textColor: .cf))
        stateBgView.addSubview(stateLabel)
        stateBgView.addSubview(timeLabel)
        
        stateBgView.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalToSuperview()
        }
        
        stateRoundBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        stateBottomBgView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        stateDescLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        stateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(stateDescLabel.snp.bottom).offset(15)
            make.left.equalTo(stateDescLabel)
            make.bottom.equalTo(-15)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.bottom.equalTo(stateLabel)
        }
        
        stateView.addBottomLine()
        
        return stateView
    }
    
    private func getFailReasonView() -> UIView {
        let refundFailReasonView = UIView()
        
        let titleLabel = refundFailReasonView.zz_add(subview: UILabel(text: "失败原因", font: .size(16), textColor: .c6)) as! UILabel
        refundFailReasonLabel = refundFailReasonView.zz_add(subview: UILabel(font: .size(16), textColor: .c3)) as? UILabel
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        refundFailReasonLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(titleLabel)
            make.right.bottom.equalTo(-15)
        }
        
        refundFailReasonView.addBottomLine()
        
        return refundFailReasonView
    }
    
    private func getRefundReasonView() -> UIView {
        let refundReasonView = UIView()
        
        let titleLabel = refundReasonView.zz_add(subview: UILabel(text: "退款原因", font: .size(16), textColor: .c6)) as! UILabel
        refundReasonLabel = refundReasonView.zz_add(subview: UILabel(font: .size(16), textColor: .c3)) as? UILabel
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        refundReasonLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(titleLabel)
            make.right.bottom.equalTo(-15)
        }
        
        refundReasonView.addBottomLine()
        
        return refundReasonView
    }
    
    private func getRefundInfoView() -> UIView {
        let refundInfoView = UIView()
        let titleLabel = refundInfoView.zz_add(subview: UILabel(text: "退款信息", font: .size(16), textColor: .c6)) as! UILabel
        
        let orderView = TextLeftRightView()
        let nameView = TextLeftRightView()
        
        orderView.config = TextLeftRightViewConfig(leftTextColor: .c6, hasBottomLine: false)
        nameView.config = TextLeftRightViewConfig(leftTextColor: .c6, hasBottomLine: false)
        
        orderView.leftLabel.text = "订单号"
        nameView.leftLabel.text = "名称"
        orderNoLabel = orderView.rightLabel
        nameLabel = nameView.rightLabel
        
        refundInfoView.addSubview(orderView)
        refundInfoView.addSubview(nameView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        orderView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.height.equalTo(30)
            make.left.right.equalToSuperview()
        }
        
        nameView.snp.makeConstraints { (make) in
            make.top.equalTo(orderView.snp.bottom).offset(15)
            make.height.equalTo(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-8)
        }
        
        return refundInfoView
    }
    
    private func setData() {
        stateLabel.text = viewModel.getStatus()
        timeLabel.text = viewModel.orderModel.refundTime.toTime(format: "yyyy-MM-dd HH:mm")
        refundAmountLabel.attributedText = viewModel.getMoneyString(viewModel.orderModel.refundAmount)
        refundReasonLabel.text = viewModel.orderModel.refundReason
        orderNoLabel.text = viewModel.orderModel.id.description
        nameLabel.text = viewModel.orderModel.productName
        
        refundFailReasonView.isHidden = viewModel.orderModel.refundApply.isEmpty
        if !viewModel.orderModel.refundApply.isEmpty {
            refundAmountView.snp.remakeConstraints { (make) in
                make.top.equalTo(refundFailReasonView.snp.bottom)
                make.left.right.equalToSuperview()
            }
        }
        
        updateView()
    }
}
