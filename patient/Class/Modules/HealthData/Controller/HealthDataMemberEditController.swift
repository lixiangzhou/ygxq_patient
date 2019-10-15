//
//  HealthDataMemberEditController.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataMemberEditController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        setUI()
        setData()
        setBinding()
    }

    // MARK: - Public Property
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let nameView = TextLeftRightFieldView()
    private let sexView = LeftRightConfigView()
    private let birthView = LeftRightConfigView()
    private let defaultView = LeftRightConfigView()
    private let switchView = UISwitch()
    
    private let arrowOpt = "请选择"
    
    let viewModel = HealthDataMemberEditViewModel()
    // MARK: - Private Property
}

// MARK: - UI
extension HealthDataMemberEditController {
    override func setUI() {
        setRightBarItem(title: "保存", action: #selector(saveAction))
        
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        nameView.config = TextLeftRightFieldViewConfig(leftFont: .size(14), leftTextColor: .c3, rightFont: .size(14), rightTextColor: .c3, rightWidth: 200, rightLimit: 100)
        nameView.backgroundColor = .cf
        nameView.leftLabel.attributedText = viewModel.nameAttr
        nameView.rightField.placeHolderString = "请输入"
        nameView.rightField.textAlignment = .right
        nameView.inputLimitClosure = { string in
            return string.isMatchNameInputValidate
        }
        
        birthView.config = LeftRightConfigViewConfig(leftPaddingRight: 0, leftFont: .size(14), rightFont: .size(14), rightTextColor: viewModel.defaultArrowTextColor, rightPaddingLeft: 5)
        birthView.backgroundColor = .cf
        birthView.leftLabel.attributedText = viewModel.birthAttr
        birthView.rightLabel.text = arrowOpt
        
        sexView.config = LeftRightConfigViewConfig(leftPaddingRight: 0, leftFont: .size(14), rightFont: .size(14), rightTextColor: viewModel.defaultArrowTextColor, rightPaddingLeft: 5)
        sexView.backgroundColor = .cf
        sexView.leftLabel.attributedText = viewModel.sexAttr
        sexView.rightLabel.text = arrowOpt
        
        switchView.tintColor = .c407cec
        switchView.onTintColor = .c407cec
        defaultView.config = LeftRightConfigViewConfig(leftPaddingRight: 0, leftFont: .size(14), rightView: switchView)
        defaultView.backgroundColor = .cf
        defaultView.leftLabel.text = "设为默认"
        
        birthView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(birthAction)))
        sexView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sexAction)))
        
        contentView.addSubview(nameView)
        contentView.addSubview(sexView)
        contentView.addSubview(birthView)
        contentView.addSubview(defaultView)
        
        if case .edit = viewModel.mode {
            let delBtn = contentView.zz_add(subview: UIButton(title: "删除成员", font: .size(14), titleColor: .cf25555, backgroundColor: .cf)) as! UIButton
            delBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
                self?.viewModel.delete()
            }
            
            delBtn.snp.makeConstraints { (make) in
                make.top.equalTo(defaultView.snp.bottom).offset(10)
                make.left.right.height.equalTo(nameView)
            }
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalTo(UIScreen.zz_width)
            make.height.equalTo(UIScreen.zz_height)
        }
        
        nameView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        sexView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        birthView.snp.makeConstraints { (make) in
            make.top.equalTo(sexView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        defaultView.snp.makeConstraints { (make) in
            make.top.equalTo(birthView.snp.bottom).offset(10)
            make.left.right.height.equalTo(nameView)
        }
    }
    
    override func setBinding() {
        viewModel.saveResultProperty.signal.observeValues { [weak self] (isSuccess) in
            if isSuccess {
                self?.pop()
            }
        }
    }
    
    private func setData() {
        if let model = viewModel.model {
            nameView.rightField.text = model.realName
            sexView.rightLabel.text = model.sex == 1 ? "男" : "女"
            birthView.rightLabel.text = model.birth!.toTime(format: "yyyy-MM-dd")
            
            switchView.isOn = model.isDefault == "Y"
        }
    }
}

// MARK: - Action
extension HealthDataMemberEditController {
    @objc private func saveAction() {
        let name = nameView.rightField.text ?? ""
        
        if name.isEmpty || sexView.rightLabel.text == arrowOpt || birthView.rightLabel.text == arrowOpt {
            HUD.show(toast: "请完整填写信息")
            return
        }
        
        if name.count < 2 {
            HUD.show(toast: "姓名不能少于2个字符")
            return
        }
        
        if name.count > 20 {
            HUD.show(toast: "姓名不能超过20个字符")
            return
        }
        
        let sex = sexView.rightLabel.text! == "男" ? 1 : 2
        let birth = birthView.rightLabel.text!.zz_date(withDateFormat: "yyyy-MM-dd")!.timeIntervalSince1970 * 1000
        
        viewModel.save(name: name, sex: sex, birth: birth, isDefault: switchView.isOn ? "Y" : "N")
    }
    
    @objc private func birthAction() {
        view.endEditing(true)
        
        let picker = DatePicker.show()
        picker.datePicker.setDate(selectBirth?.zz_date(withDateFormat: "yyyy-MM-dd") ?? Date(), animated: false)
        picker.finishClosure = { [weak self] _, date in
            self?.birthView.rightLabel.textColor = .c3
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
                self.sexView.rightLabel.textColor = .c3
                self.sexView.rightLabel.text = ds[row]
            default:
                break
            }
        }
    }
}

// MARK: - Helper
extension HealthDataMemberEditController {
    var selectBirth: String? {
        if birthView.rightLabel.text == arrowOpt {
            birthView.rightLabel.textColor = .c3
            return Date().zz_date(byAdding: .year, value: -30)?.zz_string(withDateFormat: "yyyy-MM-dd")
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
}
