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
    
    private let selectDistrictView = SelectDistrictView()
    
    private let arrowOpt = "请选择"
    
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
        birthView.rightLabel.text = arrowOpt
        birthView.config = viewModel.arrowConfig
        
        sexView.leftLabel.text = "性别"
        sexView.rightLabel.text = arrowOpt
        sexView.config = viewModel.arrowConfig
        
        heightView.leftLabel.text = "身高"
        heightView.rightLabel.text = arrowOpt
        heightView.config = viewModel.arrowConfig
        
        weightView.leftLabel.text = "体重"
        weightView.rightLabel.text = arrowOpt
        weightView.config = viewModel.arrowConfig
        
        nationView.leftLabel.text = "民族"
        nationView.rightField.placeholder = "请输入民族"
        nationView.rightField.textAlignment = .right
        nationView.config = viewModel.inputConfig
        
        addressView.leftLabel.text = "地址"
        addressView.rightLabel.text = arrowOpt
        addressView.config = viewModel.arrowConfig
        
        diseaseView.leftLabel.text = "疾病"
        diseaseView.rightLabel.text = arrowOpt
        diseaseView.config = viewModel.arrowConfig
        diseaseView.bottomLine.isHidden = true
        
        birthView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(birthAction)))
        sexView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sexAction)))
        heightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(heightAction)))
        weightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(weightAction)))
        
        addressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addressAction)))
        diseaseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(diseaseAction)))
        
        selectDistrictView.completion = { [weak self] model in
            self?.addressView.rightLabel.text = model.fullName
        }
        
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
    
    @objc private func birthAction() {
        view.endEditing(true)
        
        let picker = DatePicker.show()
        picker.finishClosure = { [weak self] _, date in
            self?.birthView.rightLabel.text = date.zz_string(withDateFormat: "yyyy-MM-dd")
        }
    }
    
    @objc private func sexAction() {
        view.endEditing(true)
        
        let picker = CommonPicker.show()
        picker.dataSource = viewModel.sexDataSource
        picker.selectOne(selectSex)
        picker.finishClosure = { [weak self] picker in
            guard let self = self else { return }
            let row = picker.commmonPicker.selectedRow(inComponent: 0)
            switch self.viewModel.sexDataSource {
            case let .one(ds):
                self.sexView.rightLabel.text = ds[row]
            default:
                break
            }
        }
    }
    
    @objc private func heightAction() {
        view.endEditing(true)
        
        let picker = CommonPicker.show()
        picker.dataSource = viewModel.heightDataSource
        picker.selectOne(selectHeight)
        picker.finishClosure = { [weak self] picker in
            guard let self = self else { return }
            let row = picker.commmonPicker.selectedRow(inComponent: 0)
            switch self.viewModel.heightDataSource {
            case let .two(ds):
                self.heightView.rightLabel.text = ds[row].title + "cm"
            default:
                break
            }
        }
    }
    
    @objc private func weightAction() {
        view.endEditing(true)
        
        let picker = CommonPicker.show()
        picker.dataSource = viewModel.weightDataSource
        picker.selectOne(selectWeight)
        picker.finishClosure = { [weak self] picker in
            guard let self = self else { return }
            let row = picker.commmonPicker.selectedRow(inComponent: 0)
            switch self.viewModel.weightDataSource {
            case let .two(ds):
                self.weightView.rightLabel.text = ds[row].title + "kg"
            default:
                break
            }
        }
    }
    
    @objc private func addressAction() {
        view.endEditing(true)
        
        selectDistrictView.show()
    }
    
    @objc private func diseaseAction() {
        view.endEditing(true)
        
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
    var selectBirth: String? {
        if birthView.rightLabel.text == arrowOpt {
            return nil
        } else {
            return birthView.rightLabel.text
        }
    }
    
    var selectSex: String? {
        if sexView.rightLabel.text == arrowOpt {
            return nil
        } else {
            return sexView.rightLabel.text
        }
    }
    
    var selectHeight: String? {
        if heightView.rightLabel.text == arrowOpt {
            return nil
        } else {
            return heightView.rightLabel.text?.replacingOccurrences(of: "cm", with: "")
        }
    }
    
    var selectWeight: String? {
        if weightView.rightLabel.text == arrowOpt {
            return nil
        } else {
            return weightView.rightLabel.text?.replacingOccurrences(of: "kg", with: "")
        }
    }
    
    var selectDisease: String? {
        if diseaseView.rightLabel.text == arrowOpt {
            return nil
        } else {
            return diseaseView.rightLabel.text
        }
    }
}

// MARK: - Other
extension PersonInfoEditController {
    
}

// MARK: - Public
extension PersonInfoEditController {
    
}

