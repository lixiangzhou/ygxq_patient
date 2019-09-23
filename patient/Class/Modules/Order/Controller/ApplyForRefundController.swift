//
//  ApplyForRefundController.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/20.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import ReactiveSwift

class ApplyForRefundController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "申请退款"
        setUI()
        setBinding()
        setData()
    }

    // MARK: - Public Property
    var orderModel: OrderModel!
    var submitCompleteClosure: ((OrderModel) -> Void)?
    
    // MARK: - Private Property
    private let viewModel = ApplyForRefundViewModel()
    private var orderNoLabel: UILabel!
    private var orderNameLabel: UILabel!
    private var orderAmountLabel: UILabel!
    private var refundAmountLabel: UILabel!
    private let txtView = KMPlaceholderTextView()
    private let submitBtn = UIButton(title: "提交", font: .size(18), titleColor: .cf, target: self, action: #selector(submitAction))
}

// MARK: - UI
extension ApplyForRefundController {
    override func setUI() {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .cf0efef
        let contentView = UIView()
        contentView.backgroundColor = .cf
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        submitBtn.backgroundColor = .cdcdcdc
        submitBtn.isEnabled = false
        view.addSubview(submitBtn)
        
        let orderNoView = contentView.zz_add(subview: TextLeftRightView(viewModel.getGrayConfig())) as! TextLeftRightView
        let orderNameView = contentView.zz_add(subview: TextLeftRightView(viewModel.getGrayConfig())) as! TextLeftRightView
        let orderAmountView = contentView.zz_add(subview: TextLeftRightView(viewModel.getRedConfig())) as! TextLeftRightView
        let orderStateView = contentView.zz_add(subview: TextLeftRightView(viewModel.getGrayConfig())) as! TextLeftRightView
        let reasonTitleView = contentView.zz_add(subview: TextLeftRightView(viewModel.getRedConfig())) as! TextLeftRightView
        
        txtView.placeholder = "请填写您的退款原因"
        txtView.placeholderFont = .size(16)
        txtView.font = .size(16)
        txtView.placeholderColor = .c9
        txtView.keyboardDismissMode = .onDrag
        contentView.addSubview(txtView)
        
        orderNoView.leftLabel.text = "订单号"
        orderNameView.leftLabel.text = "名称"
        orderAmountView.leftLabel.text = "订单价格"
        orderStateView.leftLabel.text = "订单状态"
        reasonTitleView.leftLabel.text = "退款原因"
        
        orderNoLabel = orderNoView.rightLabel
        orderNameLabel = orderNameView.rightLabel
        orderAmountLabel = orderAmountView.rightLabel
        refundAmountLabel = orderStateView.rightLabel
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(UIScreen.zz_width)
            make.height.equalTo(UIScreen.zz_height)
        }
        
        orderNoView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        orderNameView.snp.makeConstraints { (make) in
            make.top.equalTo(orderNoView.snp.bottom)
            make.height.left.right.equalTo(orderNoView)
        }
        
        orderAmountView.snp.makeConstraints { (make) in
            make.top.equalTo(orderNameView.snp.bottom)
            make.height.left.right.equalTo(orderNoView)
        }
        
        orderStateView.snp.makeConstraints { (make) in
            make.top.equalTo(orderAmountView.snp.bottom)
            make.height.left.right.equalTo(orderNoView)
        }

        reasonTitleView.snp.makeConstraints { (make) in
            make.top.equalTo(orderStateView.snp.bottom)
            make.height.left.right.equalTo(orderNoView)
        }

        
        txtView.snp.makeConstraints { (make) in
            make.top.equalTo(reasonTitleView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(80)
        }
        
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottomOffsetFrom(self)
        }
        
        view.layoutIfNeeded()
        
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(txtView.zz_maxY)
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.zz_width, height: txtView.zz_maxY)
    }
    
    override func setBinding() {
        let submintEnabledSignal = txtView.reactive.continuousTextValues.map { !$0.isEmpty }
        submitBtn.reactive.isEnabled <~ submintEnabledSignal
        submitBtn.reactive.backgroundColor <~ submintEnabledSignal.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
    }
}

// MARK: - Action
extension ApplyForRefundController {
    @objc private func submitAction() {
        viewModel.refundApply(orderModel, reason: txtView.text).startWithValues { [weak self] result in
            guard let self = self else { return }
            HUD.show(result)
            if result.isSuccess {
                self.submitCompleteClosure?(self.orderModel)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - Other
extension ApplyForRefundController {
    private func setData() {
        orderNoLabel.text = orderModel.id.description
        orderNameLabel.text = orderModel.productName
        orderAmountLabel.attributedText = viewModel.getMoneyString(orderModel.refundAmount)
        refundAmountLabel.text = "已支付"
    }
}
