//
//  SunnyDrugOrderAssistWxInfoCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import Photos

class SunnyDrugOrderAssistWxInfoCell: UITableViewCell {
    
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
    let codeView = UIImageView()
    let wxLabel = UILabel(font: .size(16), textColor: .c3)
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension SunnyDrugOrderAssistWxInfoCell {
    private func setUI() {
        contentView.backgroundColor = .cf
        
        let topSepView = contentView.zz_add(subview: UIView())
        topSepView.backgroundColor = .cf0efef
        
        let titleView = TextLeftRightView()
        titleView.config = TextLeftRightViewConfig(leftFont: .boldSize(17), leftTextColor: .c3, hasBottomLine: false)
        titleView.leftLabel.text = "医助微信二维码"
        contentView.addSubview(titleView)
        
        let saveCodeBtn = UIButton(title: "保存到相册", font: .boldSize(16), titleColor: .c407cec, target: self, action: #selector(saveAction))
        
        contentView.addSubview(codeView)
        contentView.addSubview(saveCodeBtn)
        saveCodeBtn.zz_setBorder(color: .c407cec, width: 1)
        saveCodeBtn.zz_setCorner(radius: 15, masksToBounds: true)
        
        let titleView2 = TextLeftRightView()
        titleView2.config = TextLeftRightViewConfig(leftFont: .boldSize(17), leftTextColor: .c3, hasBottomLine: false)
        titleView2.leftLabel.text = "医助微信号"
        contentView.addSubview(titleView2)
        
        let copyWxBtn = UIButton(title: "复制微信号", font: .boldSize(16), titleColor: .c407cec, target: self, action: #selector(copyAction))
        
        contentView.addSubview(wxLabel)
        contentView.addSubview(copyWxBtn)
        copyWxBtn.zz_setBorder(color: .c407cec, width: 1)
        copyWxBtn.zz_setCorner(radius: 15, masksToBounds: true)
        
        topSepView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(12)
        }
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(topSepView.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        
        codeView.snp.makeConstraints { (make) in
            make.width.height.equalTo(110)
            make.top.equalTo(titleView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        saveCodeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(codeView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(105)
            make.height.equalTo(30)
        }
        
        titleView2.snp.makeConstraints { (make) in
            make.top.equalTo(saveCodeBtn.snp.bottom)
            make.right.left.height.equalTo(titleView)
        }
        
        wxLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleView2.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        copyWxBtn.snp.makeConstraints { (make) in
            make.top.equalTo(wxLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(105)
            make.height.equalTo(30)
            make.bottom.equalTo(-15)
        }
    }
}

// MARK: - Action
extension SunnyDrugOrderAssistWxInfoCell {
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
    
}
