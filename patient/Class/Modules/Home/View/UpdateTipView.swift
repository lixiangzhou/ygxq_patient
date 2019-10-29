//
//  UpdateTipView.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/25.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import SwiftyJSON

class UpdateTipView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    let txtView = UITextView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width - 120, height: 200))
    let packageSizeLabel = UILabel(font: .size(13), textColor: .c6)
}

// MARK: - UI
extension UpdateTipView {
    private func setUI() {
        backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        let contentView = zz_add(subview: UIView())
        contentView.backgroundColor = .cf
        contentView.zz_setCorner(radius: 8, masksToBounds: true)
        
        let bgView = zz_add(subview: UIImageView(image: UIImage(named: "home_update_header_img")))
        let titleLabel = contentView.zz_add(subview: UILabel(text: "发现新版本了！", font: .boldSize(18), textColor: .c3))
        
        txtView.isEditable = false
        txtView.isSelectable = false
        txtView.isScrollEnabled = true
//        txtView.showsVerticalScrollIndicator = 
        txtView.showsHorizontalScrollIndicator = false
        
        contentView.addSubview(txtView)
        contentView.addSubview(packageSizeLabel)
        
        let updateBtn = contentView.zz_add(subview: UIButton(title: "立即升级", font: .boldSize(17), titleColor: .cf, backgroundColor: .c407cec, target: self, action: #selector(updateAction)))
        updateBtn.zz_setCorner(radius: 5, masksToBounds: true)
        
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.center.equalToSuperview()
        }
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(-30)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView).offset(0.5)
            make.height.equalTo(UIScreen.zz_width * 5 / 11)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        txtView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(200)
        }
        
        packageSizeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(txtView.snp.bottom).offset(20)
            make.left.equalTo(txtView)
        }
        
        updateBtn.snp.makeConstraints { (make) in
            make.top.equalTo(packageSizeLabel.snp.bottom).offset(20)
            make.left.right.equalTo(txtView)
            make.height.equalTo(45)
            make.bottom.equalTo(-20)
        }
    }
}

// MARK: - Action
extension UpdateTipView {
    @objc private func updateAction() {
        UIApplication.shared.zz_launchAppStore("1280316516")
    }
}

// MARK: - Helper
extension UpdateTipView {
    static func update() {
        let view = UpdateTipView()
        UIApplication.shared.zz_lookupAppInfo { (data, _, _) in
            if let data = data, let json = try? JSON(data: data) {
                let version = json["results"][0]["version"].stringValue
                let currentVersion = UIApplication.shared.zz_appVersion

                if version > currentVersion {
                    // 有更新
                    CommonApi.appInfo.rac_responseModel(UpdateInfoModel.self).skipNil().startWithValues { (model) in
                        if model.isForcedUpdate == "Y" && model.isPassed == "Y" {
                            let content = model.appNotes.replacingOccurrences(of: ";", with: "\n")
                            view.show(info: content, size: model.packetSize.description)
                        }
                    }
                }
            }
        }
    }
    
    func show(info: String, size: String) {
        frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(self)
        
        packageSizeLabel.text = "安装包大小：\(size)MB"
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let attributes = [NSAttributedString.Key.font: UIFont.size(15),
                          NSAttributedString.Key.foregroundColor : UIColor.c3,
                          NSAttributedString.Key.paragraphStyle: style] as [NSAttributedString.Key : Any]
        txtView.attributedText = NSAttributedString(string: info, attributes: attributes)
        txtView.sizeToFit()
        let height = min(txtView.zz_height, 90)
        
        txtView.snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
    }
}

// MARK: - Other
extension UpdateTipView {
    
}

// MARK: - Public
extension UpdateTipView {
    
}
