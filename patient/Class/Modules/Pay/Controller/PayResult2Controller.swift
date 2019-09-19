//
//  PayResult2Controller.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/3.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class PayResult2Controller: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
        viewModel.getAssistData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationStyle(.transparency)
    }

    // MARK: - Public Property
    var resultAction: PayViewModel.ResultAction?
    let viewModel = PayResultViewModel()
    
    let codeView = UIImageView()
    let saveCodeBtn = UIButton(title: "保存到相册", font: .size(16), titleColor: .c407cec)
    
    let wxLabel = UILabel(font: .size(15), textColor: .c3)
    let copyWxBtn = UIButton(title: "复制微信号", font: .size(16), titleColor: .c407cec)
}

// MARK: - UI
extension PayResult2Controller {
    override func setUI() {
        let topBgView = view.zz_add(subview: UIImageView(image: UIImage(named: "pay_result_top_bg")))
        topBgView.isUserInteractionEnabled = true
        let statusView = topBgView.zz_add(subview: UIButton(title: " 支付成功", font: .size(18), titleColor: .cf, imageName: "pay_ok2", hilightedImageName: "pay_ok2"))
        let descLabel = topBgView.zz_add(subview: UILabel(text: "感谢您使用阳光客户端，我们在五分钟内给你反馈", font: .size(14), textColor: .cf))
        let lookOrderBtn = topBgView.zz_add(subview: UIButton(title: "查看订单", font: .size(16), titleColor: .cf, target: self, action: #selector(lookOrderAction)))
        lookOrderBtn.zz_setBorder(color: .cf, width: 1)
        lookOrderBtn.zz_setCorner(radius: 15, masksToBounds: true)
        
        let contentView = view.zz_add(subview: UIView())
        contentView.backgroundColor = .cf
        contentView.zz_setCorner(radius: 8, masksToBounds: true)
        
        let tipTitleLabel = contentView.zz_add(subview: UILabel(text: "添加医助微信", font: .boldSize(16), textColor: .c3))
        let tipLabel = contentView.zz_add(subview: UILabel(text: "您好，药品费用需要您添加我们专业的医助人员微信，进行转账支付。如果您不向我们的医助进行转账，则无法为您提供购药服务", font: .size(14), textColor: .c6))
        
        let codeTitleLabel = contentView.zz_add(subview: UILabel(text: "医助微信二维码", font: .boldSize(16), textColor: .c3))
        
        contentView.addSubview(codeView)
        contentView.addSubview(saveCodeBtn)
        saveCodeBtn.zz_setBorder(color: .c407cec, width: 0.5)
        saveCodeBtn.zz_setCorner(radius: 15, masksToBounds: true)
        saveCodeBtn.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        let wxTitleLabel = contentView.zz_add(subview: UILabel(text: "医助微信号", font: .boldSize(16), textColor: .c3))
        contentView.addSubview(wxLabel)
        contentView.addSubview(copyWxBtn)
        copyWxBtn.zz_setBorder(color: .c407cec, width: 0.5)
        copyWxBtn.zz_setCorner(radius: 15, masksToBounds: true)
        copyWxBtn.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        
        topBgView.snp.makeConstraints { (make) in
            make.topOffsetFrom(self, -UIScreen.zz_navHeight)
            make.right.left.equalToSuperview()
        }
        
        statusView.snp.makeConstraints { (make) in
            make.top.equalTo(55 + UIScreen.zz_statusBar_additionHeight)
            make.centerX.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        lookOrderBtn.snp.makeConstraints { (make) in
            make.top.equalTo(descLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.bottom.equalTo(-40)
        }

        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(topBgView.snp.bottom).offset(-20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        tipTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tipTitleLabel.snp.bottom).offset(15)
            make.left.right.equalTo(tipTitleLabel)
        }
        
        codeTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(20)
            make.left.right.equalTo(tipTitleLabel)
        }

        codeView.snp.makeConstraints { (make) in
            make.width.height.equalTo(110)
            make.top.equalTo(codeTitleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        saveCodeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(codeView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(105)
            make.height.equalTo(30)
        }

        wxTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(saveCodeBtn.snp.bottom).offset(20)
            make.right.left.equalTo(tipTitleLabel)
        }

        wxLabel.snp.makeConstraints { (make) in
            make.top.equalTo(wxTitleLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        copyWxBtn.snp.makeConstraints { (make) in
            make.top.equalTo(wxLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(105)
            make.height.equalTo(30)
            make.bottom.equalTo(-20)
        }
    }
    
    override func setBinding() {
        viewModel.assistModelProperty.signal.skipNil().observeValues { [weak self] (model) in
            self?.codeView.kf.setImage(with: URL(string: model.wechatQrCode))
            self?.wxLabel.text = model.wechatId
        }
    }
}

// MARK: - Action
extension PayResult2Controller {
    @objc private func lookOrderAction() {
        let vc = OrderController()
        vc.selectIndex = 1
        vc.resultAction = resultAction
        push(vc)
    }

    @objc private func saveAction() {
        if let img = codeView.image {
            AuthorizationManager.shared.photo(requestSuccess: {
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                HUD.show(toast: "保存成功")
            }, requestDenied: {
                HUD.show(toast: "保存失败")
            }, success: {
                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                HUD.show(toast: "保存成功")
            }) {
                UIAlertController.zz_show(fromController: UIApplication.shared.keyWindow!.rootViewController!, style: .alert, message: "访问相册需要您的权限", actions: [UIAlertAction(title: "同意", style: .default, handler: { (_) in
                    DispatchQueue.main.zz_after(0.2) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    }
                }), UIAlertAction(title: "取消", style: .cancel, handler: nil)], completion: nil)
            }
        } else {
            HUD.show(toast: "保存失败")
        }
    }
    
    @objc private func copyAction() {
        if let txt = wxLabel.text, !txt.isEmpty {
            UIPasteboard.general.string = txt
            HUD.show(toast: "复制成功")
        } else {
            HUD.show(toast: "复制失败")
        }
    }
    
    override func backAction() {
        if let backName = resultAction?.backClassName {
            popToViewController(backName)
        } else {
            super.backAction()
        }
    }
}
