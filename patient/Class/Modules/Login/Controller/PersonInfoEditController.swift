//
//  PersonInfoEditController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/5.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class PersonInfoEditController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "个人信息"
        setUI()
        setBinding()
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    private let nameView = TextLeftRightFieldView()
    private let birthView = LeftRightConfigView()
    private let sexView = LeftRightConfigView()
    private let heightView = LeftRightConfigView()
    private let weightView = LeftRightConfigView()
    private let nationView = TextLeftRightFieldView()
    private let addressView = LeftRightConfigView()
    private let diseaseView = LeftRightConfigView()
    
    
    private let viewModel = PersonInfoEditViewModel()
}

// MARK: - UI
extension PersonInfoEditController {
    override func setUI() {
        view.backgroundColor = .cf0efef
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "跳过", style: .plain, target: self, action: #selector(skipAction))
        
        let tipLabel = UILabel(text: "请您完善信息，方便为您提供更好的服务", font: .size(13), textColor: .c9)
        view.addSubview(tipLabel)
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.backgroundColor = .cf
        scrollView.addSubview(contentView)
        
        nameView.leftLabel.text = "真实姓名"
        nameView.rightField.placeholder = "请输入真实姓名"
        nameView.rightField.textAlignment = .right
        nameView.config = viewModel.inputConfig
        
        birthView.leftLabel.text = "出生日期"
        birthView.rightLabel.text = "请选择"
        birthView.config = viewModel.arrowConfig
        
        sexView.leftLabel.text = "性别"
        sexView.rightLabel.text = "请选择"
        sexView.config = viewModel.arrowConfig
        
        heightView.leftLabel.text = "身高"
        heightView.rightLabel.text = "请选择"
        heightView.config = viewModel.arrowConfig
        
        weightView.leftLabel.text = "体重"
        weightView.rightLabel.text = "请选择"
        weightView.config = viewModel.arrowConfig
        
        nationView.leftLabel.text = "民族"
        nationView.rightField.placeholder = "请输入民族"
        nationView.rightField.textAlignment = .right
        nationView.config = viewModel.inputConfig
        
        addressView.leftLabel.text = "地址"
        addressView.rightLabel.text = "请选择"
        addressView.config = viewModel.arrowConfig
        
        diseaseView.leftLabel.text = "疾病"
        diseaseView.rightLabel.text = "请选择"
        diseaseView.config = viewModel.arrowConfig
        diseaseView.bottomLine.isHidden = true
        
        contentView.addSubview(nameView)
        contentView.addSubview(birthView)
        contentView.addSubview(sexView)
        contentView.addSubview(heightView)
        contentView.addSubview(weightView)
        contentView.addSubview(nationView)
        contentView.addSubview(addressView)
        contentView.addSubview(diseaseView)
        
        let finishBtn = UIButton(title: "完成", font: .boldSize(18), titleColor: .cf, backgroundColor: UIColor.cdcdcdc, target: self, action: #selector(finishAction))
        finishBtn.isEnabled = false
        view.addSubview(finishBtn)
        
        tipLabel.snp.makeConstraints { (make) in
            make.topOffsetFrom(self)
            make.left.equalTo(15)
            make.height.equalTo(44)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom)
            make.right.left.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalTo(view)
            make.height.equalTo(400)
        }
        
        nameView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        birthView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        sexView.snp.makeConstraints { (make) in
            make.top.equalTo(birthView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        heightView.snp.makeConstraints { (make) in
            make.top.equalTo(sexView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        weightView.snp.makeConstraints { (make) in
            make.top.equalTo(heightView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        nationView.snp.makeConstraints { (make) in
            make.top.equalTo(weightView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        addressView.snp.makeConstraints { (make) in
            make.top.equalTo(nationView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        diseaseView.snp.makeConstraints { (make) in
            make.top.equalTo(addressView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        contentView.layoutHeight()
        scrollView.contentSize = CGSize(width: 0, height: contentView.zz_height)
        
        finishBtn.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottomOffsetFrom(self)
        }
    }
    
    override func setBinding() {
        
    }
}

// MARK: - Action
extension PersonInfoEditController {
    @objc private func skipAction() {
        
    }
    
    @objc private func finishAction() {
        
    }
}

// MARK: - Network
extension PersonInfoEditController {
    
}

// MARK: - Delegate Internal

// MARK: -

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension PersonInfoEditController {
    
}

// MARK: - Other
extension PersonInfoEditController {
    
}

// MARK: - Public
extension PersonInfoEditController {
    
}

