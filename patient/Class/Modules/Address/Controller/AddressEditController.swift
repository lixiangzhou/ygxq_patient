//
//  AddressEditController.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/2.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class AddressEditController: BaseController {
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch mode {
        case .add:
            title = "新建地址"
        case .update:
            title = "编辑地址"
        }
        
        viewModel.mode = mode
        
        setUI()
        setBinding()
        setData()
    }
    
    // MARK: - Public Property
    var mode = Mode.add
    var addressModel: AddressModel?
    
    var completionClosure: (() -> Void)?
    // MARK: - Private Property
    private var nameField: UITextField!
    private var mobileField: UITextField!
    private var districtField: UITextField!
    private var addressTxtView: NextGrowingTextView!
    private var switchView: UISwitch!
    private let saveBtn = UIButton(title: "保存", font: .size(18), titleColor: .cf, backgroundColor: .cdcdcdc, target: self, action: #selector(saveAction))
    
    private let selectDistrictView = SelectDistrictView()
    
    private let viewModel = AddressEditViewModel()
}

// MARK: - UI
extension AddressEditController {
    override func setUI() {
        if mode == .update {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "删除", titleColor: .cf, target: self, action: #selector(deleteAction))
        }
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .cf0efef
        view.addSubview(scrollView)
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        
        let (nameView, nameField) = addRow(title: "收货人")
        let (mobileView, mobileField) = addRow(title: "手机号码")
        let (districtView, districtField) = addRow(title: "所在地区")
        let (addressView, addressTxtView) = addDetailAddress()
        let (defaultView, switchView) = addDefault()
        
        self.nameField = nameField
        self.mobileField = mobileField
        self.districtField = districtField
        self.addressTxtView = addressTxtView
        self.switchView = switchView
        
        districtField.placeholder = "请选择所在地区"
        
        nameField.delegate = self
        mobileField.delegate = self
        districtField.delegate = self
        
        contentView.addSubview(nameView)
        contentView.addSubview(mobileView)
        contentView.addSubview(districtView)
        contentView.addSubview(addressView)
        contentView.addSubview(defaultView)
        
        saveBtn.zz_setCorner(radius: 5, masksToBounds: true)
        contentView.addSubview(saveBtn)
        
        selectDistrictView.completion = { [unowned self] in
            self.viewModel.selectAreaModel.value = $0
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(UIScreen.zz_width)
            make.height.equalTo(UIScreen.zz_height)
        }
        
        nameView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        mobileView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        districtView.snp.makeConstraints { (make) in
            make.top.equalTo(mobileView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        addressView.snp.makeConstraints { (make) in
            make.top.equalTo(districtView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        defaultView.snp.makeConstraints { (make) in
            make.top.equalTo(addressView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        saveBtn.snp.makeConstraints { (make) in
            make.top.equalTo(defaultView.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        
        contentView.layoutHeight()
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(contentView.zz_height)
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.zz_width, height: max(contentView.zz_maxY, UIScreen.zz_height))
    }
    
    private func setData() {
        if mode == .update {
            nameField.text = addressModel?.consignee
            mobileField.text = addressModel?.mobile
            districtField.text = addressModel?.district
            addressTxtView.textView.text = addressModel?.address
            switchView.isOn = addressModel?.isDefault ?? false
        }
    }
    
    override func setBinding() {
        districtField.reactive.text <~ viewModel.selectAreaModel.map { $0?.fullName.replacingOccurrences(of: "-", with: "") }
        
        let nameEnabledSignal = nameField.reactive.continuousTextValues.map { !$0.isEmpty }
        let mobileEnabledSignal = mobileField.reactive.continuousTextValues.map { $0.count == 11 }
        let areaEnabledSignal = viewModel.selectAreaModel.map { $0 != nil }.signal
        let addressEnabledSignal = addressTxtView.textView.reactive.continuousTextValues.map { !$0.isEmpty }
        
        var nameEnabledProducer: SignalProducer<Bool, NoError>!
        var mobileEnabledProducer: SignalProducer<Bool, NoError>!
        var areaEnabledProducer: SignalProducer<Bool, NoError>!
        var addressEnabledProducer: SignalProducer<Bool, NoError>!
        
        if mode == .add {
            nameEnabledProducer = SignalProducer<Bool, NoError>(value: false).concat(nameEnabledSignal)
            mobileEnabledProducer = SignalProducer<Bool, NoError>(value: false).concat(mobileEnabledSignal)
            areaEnabledProducer = SignalProducer<Bool, NoError>(value: false).concat(areaEnabledSignal)
            addressEnabledProducer = SignalProducer<Bool, NoError>(value: false).concat(addressEnabledSignal)
        } else if mode == .update {
            nameEnabledProducer = SignalProducer<Bool, NoError>(value: true).concat(nameEnabledSignal)
            mobileEnabledProducer = SignalProducer<Bool, NoError>(value: true).concat(mobileEnabledSignal)
            areaEnabledProducer = SignalProducer<Bool, NoError>(value: true).concat(areaEnabledSignal)
            addressEnabledProducer = SignalProducer<Bool, NoError>(value: true).concat(addressEnabledSignal)
        }
        let producer = nameEnabledProducer.and(mobileEnabledProducer).and(areaEnabledProducer).and(addressEnabledProducer)
        
        saveBtn.reactive.isUserInteractionEnabled <~ producer
        saveBtn.reactive.backgroundColor <~ producer.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
    }
    
    private func addRow(title: String) -> (UIView, UITextField) {
        let view = UIView()
        view.backgroundColor = .cf
        let titleLabel = view.zz_add(subview: UILabel(text: title, font: .size(16), textColor: .c3))
        let field = view.zz_add(subview: UITextField()) as! UITextField
        field.font = .boldSize(16)
        field.textColor = .c3
        field.placeholder = "请输入\(title)"
        
        view.addBottomLine(left: 15)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.bottom.equalTo(-15)
            make.width.equalTo(80)
        }
        
        field.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalTo(-15)
        }
        
        return (view, field)
    }
    
    private func addDetailAddress() -> (UIView, NextGrowingTextView) {
        let view = UIView()
        view.backgroundColor = .cf
        let titleLabel = view.zz_add(subview: UILabel(text: "详细地址", font: .size(16), textColor: .c3))
        let inputView = view.zz_add(subview: NextGrowingTextView()) as! NextGrowingTextView
        inputView.textView.font = .boldSize(16)
        inputView.placeholderAttributedText = NSAttributedString(string: "请输入详细地址", attributes: [NSAttributedString.Key.font: inputView.textView.font!, NSAttributedString.Key.foregroundColor: UIColor.fieldDefaultColor])
        inputView.minNumberOfLines = 1
        inputView.maxNumberOfLines = 3
        
        view.addBottomLine(left: 15)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.bottom.lessThanOrEqualTo(-15)
            make.width.equalTo(80)
        }
        
        inputView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel).offset(-2)
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
        
        return (view, inputView)
    }
    
    private func addDefault() -> (UIView, UISwitch) {
        let view = UIView()
        view.backgroundColor = .cf
        let titleLabel = view.zz_add(subview: UILabel(text: "设为默认", font: .size(16), textColor: .c3))
        let switchView = view.zz_add(subview: UISwitch()) as! UISwitch
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.bottom.equalTo(-15)
            make.width.equalTo(80)
        }
        
        switchView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        return (view, switchView)
    }
}

// MARK: - Action
extension AddressEditController {
    @objc private func saveAction() {
        let name = nameField.text ?? ""
        let mobile = mobileField.text ?? ""
        let districtId = viewModel.selectAreaModel.value?.id ?? (addressModel?.cmnDistrictId ?? 0)
        let district = districtField.text ?? ""
        let address = addressTxtView.textView.text ?? ""
        let isDefault = switchView.isOn
        let id = addressModel?.id ?? 0
        
        viewModel.update(mode: mode, id: id, uid: patientId, name: name, mobile: mobile, districtId: districtId, district: district, address: address, isDefault: isDefault).startWithValues { [unowned self] (result) in
            HUD.show(result)
            if result.isSuccess {
                DispatchQueue.main.zz_after(0.25) {
                    self.pop()
                    self.completionClosure?()
                }
            }
        }
    }
    
    @objc private func deleteAction() {
        if mode == .update, let id = addressModel?.id {
            viewModel.delete(id: id).startWithValues { [unowned self] (result) in
                HUD.show(result)
                if result.isSuccess {
                    DispatchQueue.main.zz_after(0.25) {
                        self.pop()
                        self.completionClosure?()
                    }
                }
            }
        }
    }
    
    private func selectDistrictAction() {
        selectDistrictView.show()
    }
}

// MARK: - Delegate Internal

// MARK: -
extension AddressEditController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == districtField {
            selectDistrictAction()
            return false
        } else {
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileField {
            if string.isEmpty {
                return true
            } else {
                return textField.text!.count < 11
            }
        } else {
            return true
        }
    }
}

extension AddressEditController {
    enum Mode {
        case add
        case update
    }
}
