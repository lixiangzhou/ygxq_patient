//
//  VideoConsultBuyController.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/29.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result
import TZImagePickerController

class VideoConsultBuyController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        setUI()
        setBinding()
        viewModel.getPatientData()
        viewModel.getPrivateDoctor()
    }

    // MARK: - Public Property
    let viewModel = VideoConsultBuyViewModel()
    // MARK: - Private Property
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let patientInfoView = VideoConsultBuyPatientInfoView()
    private let diseaseView = VideoConsultBuyDiseaseView()
    private let picturesView = VideoConsultBuyPicturesView()
    
    private let appointBtn = UIButton(title: "立即预约", font: .size(18), titleColor: .cf, backgroundColor: .c407cec)
    private let bottomView = PayBottomView()
}

// MARK: - UI
extension VideoConsultBuyController {
    override func setUI() {
        scrollView.backgroundColor = .cf0efef
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)
        
        contentView.backgroundColor = .cf0efef
        scrollView.addSubview(contentView)
        
        let topTip = contentView.zz_add(subview: UILabel(text: viewModel.topTipString, font: .size(15), textColor: .c6)) as! UILabel
        
        contentView.addSubview(patientInfoView)
        contentView.addSubview(diseaseView)
        contentView.addSubview(picturesView)
        
        setActions()
        
        let bottomTip = contentView.zz_add(subview: UILabel(font: .size(15), textColor: .c6)) as! UILabel
        bottomTip.attributedText = viewModel.tipString
        
        let telLabel = LinkedLabel(text: "客服电话：400-6251-120", font: .size(15), textColor: .c6)
        contentView.addSubview(telLabel)
        telLabel.addLinks([(string: telLabel.text!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.c407cec], action: { _ in
            UIApplication.shared.open(URL(string: "tel://4006251120")!, options: [:], completionHandler: nil)
        })])
        
        scrollView.contentInset.bottom = 50
        
        appointBtn.addTarget(self, action: #selector(buyAction), for: .touchUpInside)
        
        bottomView.payClosure = { [weak self] in
            self?.buyAction()
        }
        
        view.addSubview(bottomView)
        view.addSubview(appointBtn)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(UIScreen.zz_width)
            make.height.equalTo(UIScreen.zz_height)
        }
        
        topTip.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(viewModel.topTipString.zz_size(withLimitWidth: UIScreen.zz_width - 30, fontSize: 15))
        }
        
        patientInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(topTip.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        diseaseView.snp.makeConstraints { (make) in
            make.top.equalTo(patientInfoView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        picturesView.snp.makeConstraints { (make) in
            make.top.equalTo(diseaseView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        bottomTip.snp.makeConstraints { (make) in
            make.top.equalTo(picturesView.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        telLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomTip.snp.bottom).offset(15)
            make.left.equalTo(15)
        }
        
        appointBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottomOffsetFrom(self)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.edges.equalTo(appointBtn)
        }
    }
    
    override func setBinding() {
        reactive.makeBindingTarget { (base, _) in
            base.updateContentHeight()
        } <~ diseaseView.heightProperty.skipRepeats().signal.map(value: ())

        reactive.makeBindingTarget { (base, _) in
            base.updateContentHeight()
            } <~ picturesView.heightProperty.skipRepeats().signal.map(value: ())
        
        viewModel.priceProperty.producer.startWithValues { (value) in
            self.bottomView.priceLabel.attributedText = value.bottomPayPriceString
        }
        
        // 选择图片
        viewModel.selectedImagesProperty.signal.observeValues { [weak self] (imgs) in
            self?.picturesView.pictureSelectView.viewModel.set(images: imgs)
        }
        
        setPatientDataBinding()
        
        enabledBinding()
        
        viewModel.orderIdProperty.signal.filter { $0 > 0 }.observeValues { [weak self] (orderId) in
            guard let self = self else { return }
            let vc = PayController()
            vc.viewModel.orderId = orderId
            vc.viewModel.resultAction = PayViewModel.ResultAction(backClassName: "DoctorDetailController", type: self.viewModel.serType == "UTOPIA15" ? .singleVideoConsult : .singleTelConsult)
            self.push(vc)
        }
        
        viewModel.buyFromLongServiceSuccessProperty.signal.observeValues { (isSuccess) in
            if isSuccess {
                self.pop()
            }
        }
    }
    
    /// 基本信息
    private func setPatientDataBinding() {
        if viewModel.serType == "UTOPIA15" {
            bottomView.reactive.isHidden <~ viewModel.myPrivateDoctorOrderProperty.signal.map { !$0.ser_code.isEmpty }
            appointBtn.reactive.isHidden <~ viewModel.myPrivateDoctorOrderProperty.signal.map { $0.ser_code.isEmpty }
            setVideoPatientBinding()
        } else if viewModel.serType == "UTOPIA10" {
            bottomView.isHidden = false
            appointBtn.isHidden = true
            setTelPatientBinding()
        }
    }
    
    private func setTelPatientBinding() {
        viewModel.lastPatientInfoModelProperty.signal.observeValues { [weak self] (model) in
            guard let self = self else { return }
            
            let font = self.patientInfoView.nameView.leftLabel.font!
            let color = self.patientInfoView.nameView.leftLabel.textColor!

            self.patientInfoView.mobileView.leftLabel.attributedText = "手机号".needed(with: font, color: color)
            
            self.patientInfoView.mobileView.rightField.text = model.mobileStr.mobileSecrectString
            
            self.patientInfoView.mobileView.rightField.reactive.controlEvents(.editingDidBegin).observeValues { (field) in
                let txt = field.text ?? ""
                if txt.contains("****") {
                    field.text = model.mobileStr
                }
            }
        }
        
        patientInfoProperty.producer.skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            
            let nameAttr = NSMutableAttributedString(string: "姓名")
            if model.realName.isEmpty {
                nameAttr.append(NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.cf25555]))
            } else {
                self.patientInfoView.nameView.rightField.text = model.realName
                self.patientInfoView.nameView.isUserInteractionEnabled = false
            }
            self.patientInfoView.nameView.leftLabel.attributedText = nameAttr
            
            let idAttr = NSMutableAttributedString(string: "身份证号码")
            if model.idCardNo.isEmpty {
                idAttr.append(NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.cf25555]))
            } else {
                self.patientInfoView.idView.rightField.text = model.idCardNo.idSecrectString
                self.patientInfoView.idView.isUserInteractionEnabled = false
            }
            
            self.patientInfoView.idView.leftLabel.attributedText = idAttr
            
            self.patientInfoView.idView.rightField.reactive.controlEvents(.editingDidBegin).observeValues { (field) in
                let txt = field.text ?? ""
                if txt.contains("****") {
                    field.text = model.idCardNo
                }
            }
        }
    }
    
    private func setVideoPatientBinding() {
        patientInfoProperty.producer.skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            
            let nameAttr = NSMutableAttributedString(string: "姓名")
            if model.realName.isEmpty {
                nameAttr.append(NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.cf25555]))
            } else {
                self.patientInfoView.nameView.rightField.text = model.realName
                self.patientInfoView.nameView.isUserInteractionEnabled = false
            }
            self.patientInfoView.nameView.leftLabel.attributedText = nameAttr
            
            self.patientInfoView.mobileView.rightField.text = model.mobile.mobileSecrectString
            self.patientInfoView.mobileView.isUserInteractionEnabled = false
            
            let idAttr = NSMutableAttributedString(string: "身份证号码")
            if model.idCardNo.isEmpty {
                idAttr.append(NSAttributedString(string: "*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.cf25555]))
            } else {
                self.patientInfoView.idView.rightField.text = model.idCardNo.idSecrectString
                self.patientInfoView.idView.isUserInteractionEnabled = false
            }
            self.patientInfoView.idView.leftLabel.attributedText = idAttr
        }
    }
    
    /// 底部按钮状态
    private func enabledBinding() {
        if viewModel.serType == "UTOPIA15" {
            videoEnabledBinding()
        } else if viewModel.serType == "UTOPIA10" {
            telEnabledBinding()
        }
    }
    
    private func videoEnabledBinding() {
        patientInfoProperty.producer.skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            let nameEnabledProducer = SignalProducer<Bool, NoError>(value: !model.realName.isEmpty)
                    .concat(self.patientInfoView.nameView.rightField.reactive.continuousTextValues.map { $0.count >= 2 }.producer)
            
            let idEnabledProducer = SignalProducer<Bool, NoError>(value: !model.idCardNo.isEmpty)
                    .concat(self.patientInfoView.idView.rightField.reactive.continuousTextValues.map { $0.isMatchIdNo }.producer)
            
            let diseaseEnabledProducer = SignalProducer<Bool, NoError>(value: false)
                .concat(self.diseaseView.txtView.textView.reactive.continuousTextValues.map { !$0.isEmpty }.producer)
            
            let buyEnabled = nameEnabledProducer.and(idEnabledProducer).and(diseaseEnabledProducer)
            
            self.appointBtn.reactive.isUserInteractionEnabled <~ buyEnabled
            self.appointBtn.reactive.backgroundColor <~ buyEnabled.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
            
            self.bottomView.payBtn.reactive.isUserInteractionEnabled <~ buyEnabled
            self.bottomView.payBtn.reactive.backgroundColor <~ buyEnabled.map { $0 ? UIColor.cffa84c : UIColor.cdcdcdc }
        }
    }
    
    private func telEnabledBinding() {
        patientInfoProperty.producer.skipNil().combineLatest(with: viewModel.lastPatientInfoModelProperty.signal).startWithValues { [weak self] (pModel, model) in
            guard let self = self else { return }
            
            let nameEnabledProducer = SignalProducer<Bool, NoError>(value: !pModel.realName.isEmpty).concat(self.patientInfoView.nameView.rightField.reactive.continuousTextValues.map { $0.count >= 2 }.producer)
            
            let idEnabledProducer = SignalProducer<Bool, NoError>(value: !pModel.idCardNo.isEmpty)
                    .concat(self.patientInfoView.idView.rightField.reactive.continuousTextValues.map { $0.isMatchIdNo }.producer)
            
            let telEnabledProducer = SignalProducer<Bool, NoError>(value: !model.mobileStr.isEmpty).concat(self.patientInfoView.mobileView.rightField.reactive.continuousTextValues.map { $0.isMatchMobile }.producer)
            
            let diseaseEnabledProducer = SignalProducer<Bool, NoError>(value: false)
                .concat(self.diseaseView.txtView.textView.reactive.continuousTextValues.map { !$0.isEmpty }.producer)
            
            let buyEnabled = nameEnabledProducer.and(telEnabledProducer).and(idEnabledProducer).and(diseaseEnabledProducer)
            
            nameEnabledProducer.startWithValues { (value) in
                print("nameEnabledProducer", value)
            }
            
            idEnabledProducer.startWithValues { (value) in
                print("idEnabledProducer", value)
            }
            
            telEnabledProducer.startWithValues { (value) in
                print("telEnabledProducer", value)
            }
            
            diseaseEnabledProducer.startWithValues { (value) in
                print("diseaseEnabledProducer", value)
            }
            
            self.appointBtn.reactive.isUserInteractionEnabled <~ buyEnabled
            self.appointBtn.reactive.backgroundColor <~ buyEnabled.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
            
            self.bottomView.payBtn.reactive.isUserInteractionEnabled <~ buyEnabled
            self.bottomView.payBtn.reactive.backgroundColor <~ buyEnabled.map { $0 ? UIColor.cffa84c : UIColor.cdcdcdc }
        }
    }
}

// MARK: - Action
extension VideoConsultBuyController {
    private func setActions() {
        let count = 30
        picturesView.pictureSelectView.addClosure = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.selectedImagesProperty.value.count < count {
                
                TZImagePickerController.commonPresent(from: self, maxCount: count - self.viewModel.selectedImagesProperty.value.count, selectedModels: nil, delegate: self)
            } else {
                HUD.show(toast: "最多选择30张图片")
            }
        }
        
        picturesView.pictureSelectView.deleteClosure = { [weak self] idx, data in
            self?.viewModel.removeAt(index: idx)
        }
    }
    
    @objc private func buyAction() {
        if !viewModel.isToPayWay { // 预约
            ActionCollecter.sendData(lev: "11")
        }
        
        if viewModel.cantBuy {
            if viewModel.isToPayWay {
                AlertView.show(title: nil, msg: viewModel.alertMsg, firstTitle: "是", secondTitle: "否", firstClosure: { [weak self] (alert) in
                    alert.hide()
                    self?._buyAction()
                }) { [weak self] (alert) in
                    alert.hide()
                    self?.pop()
                }
            } else {
                if !viewModel.toastMsg.isEmpty {
                    HUD.show(toast: viewModel.toastMsg)
                }
                return
            }
            
        } else {
            _buyAction()
        }
    }
    
    @objc private func _buyAction() {
        guard let model = patientInfoProperty.value else { return }
        
        let needUpdate = model.realName.isEmpty || model.idCardNo.isEmpty
        
        let realName = patientInfoView.nameView.rightField.text!
        
        var mobile = patientInfoView.mobileView.rightField.text!
        if mobile.contains("****") {
            switch viewModel.serType {
            case "UTOPIA10":
                mobile = viewModel.lastPatientInfoModelProperty.value.mobileStr
            case "UTOPIA15":
                mobile = patientInfoProperty.value?.mobile ?? ""
            default: break
            }
        }
        
        var idCardNo = patientInfoView.idView.rightField.text!
        if idCardNo.contains("****") {
            idCardNo = patientInfoProperty.value?.idCardNo ?? ""
        }
        
        let consultContent = diseaseView.txtView.textView.text!
        
        if model.realName.isEmpty {
            if realName.count > 20 {
                HUD.show(toast: "姓名不能超过20个字符")
                return
            }
        }
        
        switch viewModel.serType {
        case "UTOPIA10":
            let params: [String: Any] = [
                "consultContent": consultContent,
                "duid": viewModel.did,
                "fromWhere": 1,
                "idCardNo": idCardNo,
                "productName": "电话咨询",
                "telNum": mobile,
                "puid": patientId,
                "realName": realName,
                "serCode": viewModel.serType
            ]
            viewModel.buyConsult(params: params)
        case "UTOPIA15":
            var params: [String: Any] = [
                "consultContent": consultContent,
                "duid": viewModel.did,
                "fromWhere": 1,
                "idCardNo": idCardNo,
                "isUpUsrPf": needUpdate,
                "mobile": model.mobile,
                "puid": patientId,
                "realName": realName
            ]
            
            if !viewModel.isToPayWay { // 预约
                let orderModel = viewModel.myPrivateDoctorOrderProperty.value
                params["keyObject"] = "视频咨询"
                params["orderId"] = orderModel.orderId
                params["productItmId"] = orderModel.productItemId
                params["productName"] = orderModel.product_name
                params["serCode"] = viewModel.serType
                params["workType"] = "TSK_WORK_T_19"
            } else { // 购买
                params["hospitalPuid"] = 0
            }
            
            viewModel.buyConsult(params: params)
        default: break
        }
        
        
    }
}


// MARK: - Delegate External

// MARK: -

extension VideoConsultBuyController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
//        viewModel.selectedModelsProperty.value = picker.selectedModels
        addImages(photos)
    }
}

// MARK: - Helper
extension VideoConsultBuyController {
    func updateContentHeight() {
        contentView.layoutHeight()
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(contentView.zz_height)
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.zz_width, height: max(contentView.zz_height, UIScreen.zz_safeFrameUnderNavigation.height) + 10)
    }
    
    private func addImages(_ photos: [UIImage]) {
        var values = [UIImage]()
        HUD.showLoding()
        DispatchQueue.global().async {
            for img in photos {
                if let resizeImage = UIImage(data: img.zz_resetToSize(300, maxWidth: 1000, maxHeight: 1000)) {
                    values.append(resizeImage)
                }
            }
            
            DispatchQueue.main.async {
                HUD.hideLoding()
                self.viewModel.selectedImagesProperty.value += values
            }
        }
    }
}

