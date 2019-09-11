//
//  ProfileHeaderView.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/18.
//  Copyright © 2019 sphr. All rights reserved.
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

    // MARK: - Public Property
    var nameLabel: UILabel!
    var mobileLabel: UILabel!
    var sexLabel: UILabel!
    var ageLabel: UILabel!
    var diseaseLabel: UILabel!
    
    // MARK: - Private Property
}

// MARK: - UI
extension ProfileHeaderView {
    private func setUI() {
        backgroundColor = .clear
        
        let nameView = getRowView("姓名")
        let mobileView = getRowView("手机号")
        let sexView = getRowView("性别")
        let ageView = getRowView("年龄")
        let diseaseView = getRowView("疾病")
        
        self.nameLabel = nameView.rightLabel
        self.mobileLabel = mobileView.rightLabel
        self.sexLabel = sexView.rightLabel
        self.ageLabel = ageView.rightLabel
        self.diseaseLabel = diseaseView.rightLabel
        
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
        
    }
    
    private func getRowView(_ title: String) -> TextLeftGrowTextRightView {
        let view = TextLeftGrowTextRightView()
        view.backgroundColor = .cf
        view.leftLabel.text = title
        view.config = TextLeftGrowTextRightViewConfig()
        addSubview(view)
        return view
    }
}

