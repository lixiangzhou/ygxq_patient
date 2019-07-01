//
//  ProfileHeaderView.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class ProfileHeaderView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ProfileHeaderView deinit")
    }

    // MARK: - Public Property
    var nameLabel: UILabel!
    var mobileLabel: UILabel!
    var sexLabel: UILabel!
    var ageLabel: UILabel!
    var diseaseLabel: UILabel!
    
    var uploadClosure: (() -> Void)?
    // MARK: - Private Property
}

// MARK: - UI
extension ProfileHeaderView {
    private func setUI() {
        backgroundColor = .clear
        
        let (nameView, nameLabel) = getRowView("姓名")
        let (mobileView, mobileLabel) = getRowView("手机号")
        let (sexView, sexLabel) = getRowView("性别")
        let (ageView, ageLabel) = getRowView("年龄")
        let (diseaseView, diseaseLabel) = getRowView("疾病")
        
        self.nameLabel = nameLabel
        self.mobileLabel = mobileLabel
        self.sexLabel = sexLabel
        self.ageLabel = ageLabel
        self.diseaseLabel = diseaseLabel
        
        let bottomView = zz_add(subview: UIView())
        let uploadBtn = bottomView.zz_add(subview: UIButton(title: "上传资料", font: .size(15), titleColor: .c6, backgroundColor: .cf, target: self, action: #selector(uploadAction)))
        
        nameView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        mobileView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom)
            make.left.right.equalTo(nameView)
        }
        
        sexView.snp.makeConstraints { (make) in
            make.top.equalTo(mobileView.snp.bottom)
            make.left.right.equalTo(nameView)
        }
        
        ageView.snp.makeConstraints { (make) in
            make.top.equalTo(sexView.snp.bottom)
            make.left.right.equalTo(nameView)
        }
        
        diseaseView.snp.makeConstraints { (make) in
            make.top.equalTo(ageView.snp.bottom)
            make.left.right.equalTo(nameView)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(diseaseView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        uploadBtn.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(-10)
        }
    }
    
    private func getRowView(_ title: String) -> (UIView, UILabel) {
        let view = UIView()
        view.backgroundColor = .cf
        addSubview(view)
        
        let titleLabel = view.zz_add(subview: UILabel(text: title, font: .size(16), textColor: .c6)) as! UILabel
        let txtLabel = view.zz_add(subview: UILabel(font: .size(16), textColor: .c6, textAlignment: .right)) as! UILabel
        view.addBottomLine()
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
        }
        
        txtLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.top.equalTo(10)
            make.right.equalTo(-15)
            make.bottom.equalTo(-10)
        }
        
        return (view, txtLabel)
    }
}

// MARK: - Action
extension ProfileHeaderView {
    @objc private func uploadAction() {
        uploadClosure?()
    }
}
