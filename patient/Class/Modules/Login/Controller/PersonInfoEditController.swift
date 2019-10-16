//
//  PersonInfoEditController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/5.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

class PersonInfoEditController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "个人信息"
        setUI()
        setBinding()
        viewModel.getDisease()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }

    // MARK: - Public Property
    /// 是否显示头像
    var hasIcon = false
    
    // MARK: - Private Property
    private let avatorView = UIImageView(image: UIImage(named: "mine_avator_default"))
    private let nameView = TextLeftRightFieldView()
    private let idView = TextLeftRightFieldView()
    private let birthView = LeftRightConfigView()
    private let sexView = LeftRightConfigView()
    private let nationView = TextLeftRightFieldView()
    private let addressView = LeftRightConfigView()
    private let diseaseView = LeftRightConfigView()
    
    var finishBtn: UIButton!
    
    private let selectDistrictView = SelectDistrictView()
    private let arrowOpt = "请选择"

    private let viewModel = PersonInfoEditViewModel()
}

// MARK: - UI
extension PersonInfoEditController {
    override func setUI() {
        finishBtn = setRightBarItem(title: "完成", action: #selector(finishAction))
        
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.backgroundColor = .cf
        scrollView.addSubview(contentView)
        
        if hasIcon {
            let iconView = getIconRow()
            contentView.addSubview(iconView)
            
            iconView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(50)
            }
        } else {
            scrollView.backgroundColor = .cf
            
            let tipLabel = UILabel(text: "请您完善信息，方便为您提供更好的服务", font: .size(13), textColor: .c9)
            view.addSubview(tipLabel)
            
            tipLabel.snp.makeConstraints { (make) in
                make.topOffsetFrom(self)
                make.left.equalTo(15)
                make.height.equalTo(44)
            }
        }
        
        nameView.config = TextLeftRightFieldViewConfig(leftFont: .size(14), leftTextColor: .c3, rightFont: .size(14), rightTextColor: .c6, rightWidth: 200, rightLimit: 100)
        nameView.leftLabel.attributedText = "姓名".needed(with: .size(14), color: .c3)
        nameView.rightField.placeHolderString = "请输入姓名"
        nameView.rightField.textAlignment = .right
        nameView.inputLimitClosure = { string in
            return string.isMatchNameInputValidate
        }
        
        idView.config = viewModel.idConfig
        idView.leftLabel.text = "身份证号码"
        idView.rightField.placeHolderString = "请输入身份证号码"
        idView.rightField.textAlignment = .right
        idView.inputLimitClosure = { string in
            return string.isMatchIdNoInputing
        }

        birthView.config = viewModel.arrowConfig
        birthView.leftLabel.text = "出生日期"
        birthView.rightLabel.text = arrowOpt
        
        sexView.config = viewModel.arrowConfig
        sexView.leftLabel.text = "性别"
        sexView.rightLabel.text = arrowOpt
        
        nationView.config = viewModel.inputConfig
        nationView.leftLabel.text = "民族"
        nationView.rightField.placeHolderString = "请输入民族"
        nationView.rightField.textAlignment = .right
        
        addressView.config = viewModel .arrowConfig
        addressView.leftLabel.text = "地址"
        addressView.rightLabel.text = arrowOpt
        
        diseaseView.config = viewModel.arrowConfig
        diseaseView.leftLabel.text = "病史"
        diseaseView.rightLabel.text = arrowOpt
        diseaseView.bottomLine.isHidden = true
        
        birthView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(birthAction)))
        sexView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sexAction)))
        
        addressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addressAction)))
        diseaseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(diseaseAction)))
        
        selectDistrictView.completion = { [weak self] model in
            self?.addressView.rightLabel.text = model.fullName.replacingOccurrences(of: "-", with: "")
        }
        
        contentView.addSubview(nameView)
        contentView.addSubview(idView)
        contentView.addSubview(birthView)
        contentView.addSubview(sexView)
        contentView.addSubview(nationView)
        contentView.addSubview(addressView)
        contentView.addSubview(diseaseView)
        
        if !hasIcon {
            addLoginBottomView()
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.topOffsetFrom(self, hasIcon ? 0 : 44)
            make.right.left.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalTo(view)
            make.height.equalTo(400)
        }
        
        nameView.snp.makeConstraints { (make) in
            make.top.equalTo(hasIcon ? 50 : 0)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        idView.snp.makeConstraints { (make) in
            make.top.equalTo(nameView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        birthView.snp.makeConstraints { (make) in
            make.top.equalTo(idView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        sexView.snp.makeConstraints { (make) in
            make.top.equalTo(birthView.snp.bottom)
            make.left.right.height.equalTo(nameView)
        }
        
        nationView.snp.makeConstraints { (make) in
            make.top.equalTo(sexView.snp.bottom)
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
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(contentView.zz_height)
        }
        scrollView.contentSize = CGSize(width: 0, height: contentView.zz_height)
    }
    
    private func getIconRow() -> UIView {
        let view = UIView()
        let left = view.zz_add(subview: UILabel(text: "头像", font: .size(14), textColor: .c3))
        avatorView.zz_setCorner(radius: 16, masksToBounds: true)
        view.addSubview(avatorView)
        let arrowView = view.zz_add(subview: UIImageView.defaultRightArrow())
        view.addBottomLine()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatorAction)))
        
        left.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        avatorView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.left.equalTo(avatorView.snp.right).offset(5)
        }
        
        return view
    }
    
    override func setBinding() {
        finishBtn.isEnabled = false
        let nameEnabledSignal = nameView.rightField.reactive.continuousTextValues.producer.map { $0.count >= 2 }
        
        let idEnabledSignal = SignalProducer<Bool, NoError>(value: true).concat(idView.rightField.reactive.continuousTextValues.map { $0.isEmpty || $0.isMatchIdNo })
        
        let finishEnabledSignal = nameEnabledSignal.and(idEnabledSignal)
        
        finishBtn.reactive.isEnabled <~ finishEnabledSignal
        finishBtn.reactive.makeBindingTarget { (btn, color) in
            btn.setTitleColor(color, for: .normal)
            } <~ finishEnabledSignal.map { $0 ? UIColor.cf : UIColor.cdcdcdc.withAlphaComponent(0.6) }
    }
    
    private func setData() {
        patientInfoProperty.producer.startWithValues { [weak self] (info) in
            if let info = info {
                self?.viewModel.imgUrl = info.imgUrl
                self?.avatorView.kf.setImage(with: URL(string: info.imgUrl), placeholder: UIImage(named: "mine_avator_default"))
                self?.nameView.rightField.text = info.realName
                self?.idView.rightField.text = info.idCardNo.idSecrectString
                self?.sexView.rightLabel.text = info.sex == Sex.unknown ? self?.arrowOpt : info.sex.description
                self?.birthView.rightLabel.text = info.birth != nil ? info.birth!.toTime(format: "yyyy-MM-dd") : self?.arrowOpt
                self?.nationView.rightField.text = info.race
                self?.addressView.rightLabel.text = info.address.isEmpty ? self?.arrowOpt : info.address
                self?.diseaseView.rightLabel.text = info.diseaseName.isEmpty ? self?.arrowOpt : info.diseaseName
                
                self?.nameView.rightField.sendActions(for: .allEditingEvents)
                self?.idView.rightField.sendActions(for: .allEditingEvents)
            }
        }
    }
}

// MARK: - Action
extension PersonInfoEditController {
    
    @objc private func avatorAction() {
        UIAlertController.showCameraPhotoSheet(from: self, delegate: self)
    }
    
    @objc private func birthAction() {
        view.endEditing(true)
        
        let picker = DatePicker.show()
        picker.datePicker.setDate(selectBirth?.zz_date(withDateFormat: "yyyy-MM-dd") ?? Date(), animated: false)
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
    
    @objc private func addressAction() {
        view.endEditing(true)
        
        selectDistrictView.show()
    }
    
    @objc private func diseaseAction() {
        view.endEditing(true)
        
        let picker = CommonPicker.show()
        picker.dataSource = viewModel.diseasesDataSource
        picker.selectOne(selectDisease)
        picker.finishClosure = { [weak self] picker in
            guard let self = self else { return }
            let row = picker.commmonPicker.selectedRow(inComponent: 0)
            switch self.viewModel.diseasesDataSource {
            case let .one(ds):
                self.diseaseView.rightLabel.text = ds[row]
            default:
                break
            }
        }
    }

    @objc private func finishAction() {
        var params = [String: Any]()
        
        var idCard = idView.rightField.text ?? ""
        idCard = idCard.contains("*") ? patientInfoProperty.value!.idCardNo : idCard
        
        let name = nameView.rightField.text ?? ""
        params["realName"] = name
        params["birth"] = (selectBirth?.zz_date(withDateFormat: "yyyy-MM-dd")?.timeIntervalSince1970 ?? 0) * 1000
        params["idCardNo"] = idCard
        params["sex"] = Sex.string(selectSex).rawValue
        params["race"] = nationView.rightField.text ?? ""
        params["address"] = addressView.rightLabel.text ?? ""
        params["diseaseCode"] = viewModel.selectDiseaseCodeFrom(selectDisease) ?? "0"
        params["id"] = patientId
        params["fromWhere"] = 1
        params["imgUrl"] = viewModel.imgUrl
        params["height"] = 0
        params["weight"] = 0
        
        if name.count > 20 {
            HUD.show(toast: "姓名不能超过20个字符")
            return
        }
        
        viewModel.saveInfo(params).startWithValues { [weak self] (result) in
            if result.isSuccess {
                if self?.hasIcon == true {
                    HUD.show(result)
                    self?.pop()
                } else {
                    HUD.show(toast: "注册成功")
                    DispatchQueue.main.zz_after(2) {
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                HUD.show(result)
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PersonInfoEditController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            UploadApi.upload(datas: [FileData(data: image.zz_resetToSize(200, maxWidth: 400, maxHeight: 400), name: "avator.jpg")]).rac_response([String].self).startWithValues { [weak self] (result) in
                HUD.show(BoolString(result))
                if let url = result.content?.first {
                    self?.viewModel.imgUrl = url
                    self?.avatorView.image = image
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        setNavigation(navigationController, style: .default)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        setNavigation(navigationController, style: .default)
    }
}

// MARK: - Helper
extension PersonInfoEditController {
    
    var selectBirth: String? {
        if birthView.rightLabel.text == arrowOpt {
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
    
    var selectAddress: String? {
        if addressView.rightLabel.text == arrowOpt {
            return nil
        } else {
            return addressView.rightLabel.text
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
