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

        title = "视频咨询"
        setUI()
        setBinding()
        PatientManager.shared.getPatientInfo()
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
        
        let topTip = contentView.zz_add(subview: UILabel(text: "提示：急重症患者不适合视频咨询，请及时前往医院就医", font: .size(13), textColor: .cf25555))
        
        contentView.addSubview(patientInfoView)
        contentView.addSubview(diseaseView)
        contentView.addSubview(picturesView)
        
        setActions()
        
        let bottomTip = contentView.zz_add(subview: UILabel(text: viewModel.tipString, font: .size(14), textColor: .cf25555))
        
        let telLabel = LinkedLabel(text: "客服电话：400-6251-120", font: .size(14), textColor: .c407cec)
        contentView.addSubview(telLabel)
        telLabel.addLinks([(string: telLabel.text!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.c407cec], action: { _ in
            UIApplication.shared.open(URL(string: "tel://4006251120")!, options: [:], completionHandler: nil)
        })])
        
        scrollView.contentInset.bottom = 50
        appointBtn.addTarget(self, action: #selector(appointAction), for: .touchUpInside)
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
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(40)
        }
        
        patientInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(topTip.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        diseaseView.snp.makeConstraints { (make) in
            make.top.equalTo(patientInfoView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        picturesView.snp.makeConstraints { (make) in
            make.top.equalTo(diseaseView.snp.bottom).offset(10)
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
    }
    
    override func setBinding() {
        reactive.makeBindingTarget { (base, _) in
            base.updateContentHeight()
        } <~ diseaseView.heightProperty.skipRepeats().signal.map(value: ())

        reactive.makeBindingTarget { (base, _) in
            base.updateContentHeight()
            } <~ picturesView.heightProperty.skipRepeats().signal.map(value: ())
        
        // 选择图片
        viewModel.selectedImagesProperty.signal.observeValues { [weak self] (imgs) in
            self?.picturesView.pictureSelectView.viewModel.set(images: imgs)
        }
        
        // 基本信息
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
        
        enabledBinding()
        
        viewModel.orderIdProperty.signal.filter { $0 > 0 }.observeValues { [weak self] (orderId) in
            let vc = PayController()
            vc.viewModel.orderId = orderId
            vc.viewModel.resultAction = PayViewModel.ResultAction(backClassName: "DoctorDetailController", type: .singleVideoConsult)
            self?.push(vc)
        }
        
        viewModel.buyFromLongServiceSuccessProperty.signal.observeValues { (isSuccess) in
            if isSuccess {
                self.pop()
            }
        }
    }
    
    /// 底部按钮状态
    private func enabledBinding() {
        patientInfoProperty.producer.skipNil().startWithValues { [weak self] (model) in
            guard let self = self else { return }
            let nameEnabledProducer: SignalProducer<Bool, NoError>!
            if model.realName.isEmpty {
                nameEnabledProducer = SignalProducer<Bool, NoError>(value: false)
                    .concat(self.patientInfoView.nameView.rightField.reactive.continuousTextValues.map { $0.count >= 2 }.producer)
            } else {
                nameEnabledProducer = SignalProducer<Bool, NoError>(value: true)
            }
            
            let idEnabledProducer: SignalProducer<Bool, NoError>!
            if model.idCardNo.isEmpty {
                idEnabledProducer = SignalProducer<Bool, NoError>(value: false)
                    .concat(self.patientInfoView.idView.rightField.reactive.continuousTextValues.map { $0.isMatchIdNo }.producer)
            } else {
                idEnabledProducer = SignalProducer<Bool, NoError>(value: true)
            }
            
            let diseaseEnabledProducer = SignalProducer<Bool, NoError>(value: false)
                .concat(self.diseaseView.txtView.textView.reactive.continuousTextValues.map { !$0.isEmpty }.producer)
            
            let appointEnabledProducer = nameEnabledProducer.and(idEnabledProducer).and(diseaseEnabledProducer)
            
            self.appointBtn.reactive.isUserInteractionEnabled <~ appointEnabledProducer
            self.appointBtn.reactive.backgroundColor <~ appointEnabledProducer.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
        }
    }
}

// MARK: - Action
extension VideoConsultBuyController {
    private func setActions() {
        let count = 30
        picturesView.pictureSelectView.viewModel.maxCount = count
        picturesView.pictureSelectView.addClosure = { [weak self] in
            guard let self = self else { return }
            if self.viewModel.selectedImagesProperty.value.count < count {
                
                TZImagePickerController.commonPresent(from: self, maxCount: count - self.viewModel.selectedImagesProperty.value.count, selectedModels: self.viewModel.selectedModelsProperty.value, delegate: self)
            } else {
                HUD.show(toast: "最多选择30张图片")
            }
        }
        
        picturesView.pictureSelectView.deleteClosure = { [weak self] idx, data in
            self?.viewModel.removeAt(index: idx)
        }
    }
    
    @objc private func appointAction() {
        guard let model = patientInfoProperty.value else { return }
        
        let needUpdate = model.realName.isEmpty || model.idCardNo.isEmpty
        let realName = model.realName.isEmpty ? patientInfoView.nameView.rightField.text! : model.realName
        let idCardNo = model.idCardNo.isEmpty ? patientInfoView.idView.rightField.text! : model.idCardNo
        let consultContent = diseaseView.txtView.textView.text!
        
        if model.realName.isEmpty {
            if realName.count > 20 {
                HUD.show(toast: "姓名不能超过20个字符")
                return
            }
        }
        
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
        
        if let orderModel = viewModel.myPrivateDoctorOrderProperty.value {
            params["keyObject"] = "视频咨询"
            params["orderId"] = orderModel.orderId
            params["productItmId"] = orderModel.productItemId
            params["productName"] = orderModel.product_name
            params["serCode"] = orderModel.ser_code
            params["workType"] = "TSK_WORK_T_19"
        } else {
            params["hospitalPuid"] = 0
        }
        
        viewModel.buyVideoConsult(params: params)
    }
}


// MARK: - Delegate External

// MARK: -

extension VideoConsultBuyController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        viewModel.selectedModelsProperty.value = picker.selectedModels
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

