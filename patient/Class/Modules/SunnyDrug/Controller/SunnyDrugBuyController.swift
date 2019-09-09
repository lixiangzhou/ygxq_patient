//
//  SunnyDrugBuyController.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/2.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import TZImagePickerController
import ReactiveSwift
import Result

class SunnyDrugBuyController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "请填写购药信息"
        setUI()
        setBinding()
        addressView.viewModel.getDefaultAddress()
        viewModel.getPrivateDoctor()
    }

    // MARK: - Public Property
    let viewModel = SunnyDrugBuyViewModel()
    
    // MARK: - Private Property
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let idView = SunnyDrugBuyIdView()
    private let addressView = AddressShowView()
    private let buyBtn = UIButton(title: "购买", font: .size(18), titleColor: .cf, backgroundColor: .c407cec)
}

// MARK: - UI
extension SunnyDrugBuyController {
    override func setUI() {
        scrollView.backgroundColor = .cf0efef
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        contentView.backgroundColor = .cf0efef
        scrollView.addSubview(contentView)
        
        contentView.addSubview(idView)
        contentView.addSubview(addressView)
        let tipString = "温馨提示：我们的购药服务将为您购买医生开具处方里的药品，以快递的方式寄送给您，请务必填写详细的收货地址。药品费需要您添加我们指定医助的微信进行转账（药品费支付后，不予退款）。除药品费用外，您需要在平台上额外支付我们购药的服务费用（包含挂号费：50元；服务费：50元），共100元。"
        let tipLabel = contentView.zz_add(subview: UILabel(text: tipString, font: .size(14), textColor: .c9)) as! UILabel
        
        scrollView.contentInset.bottom = 50
        buyBtn.addTarget(self, action: #selector(buyAction), for: .touchUpInside)
        view.addSubview(buyBtn)
        
        addActions()
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(UIScreen.zz_width)
            make.height.equalTo(UIScreen.zz_height)
        }
        
        idView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        addressView.snp.makeConstraints { (make) in
            make.top.equalTo(idView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        let height = tipString.zz_size(withLimitWidth: UIScreen.zz_width - 30, fontSize: tipLabel.font.pointSize).height
        
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addressView.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(height)
        }
        
        buyBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottomOffsetFrom(self)
        }
    }
    
    override func setBinding() {
        addressView.viewModel.addressModelProperty.producer.startWithValues { [weak self] (model) in
            self?.updateContentHeight()
        }
        
        viewModel.orderIdProperty.signal.filter { $0 > 0 }.observeValues { [weak self] (orderId) in
            let vc = PayController()
            vc.viewModel.orderId = orderId
            vc.viewModel.resultAction = PayViewModel.ResultAction(backClassName: "DoctorDetailController", type: .singleSunnyDrug)
            self?.push(vc)
        }
        
        viewModel.buyFromLongServiceSuccessProperty.signal.observeValues { (isSuccess) in
            if isSuccess {
                self.pop()
            }
        }
        
        let imgEnabled = SignalProducer<Bool, NoError>(value: false).concat(viewModel.selectImageProperty.producer.skipNil().map(value: true))
        let addressEnabled = SignalProducer<Bool, NoError>(value: false).concat(addressView.viewModel.addressModelProperty.producer.skipNil().map(value: true))
        let buyEnabled = imgEnabled.and(addressEnabled)
        
        buyBtn.reactive.isUserInteractionEnabled <~ buyEnabled
        buyBtn.reactive.backgroundColor <~ buyEnabled.map { $0 ? UIColor.c407cec : UIColor.cdcdcdc }
    }
}

// MARK: - Action
extension SunnyDrugBuyController {
    private func addActions() {
        idView.picClosure = { [weak self] in
            let vc = TZImagePickerController(maxImagesCount: 1, delegate: self)!
            vc.showPhotoCannotSelectLayer = true
            vc.allowTakeVideo = false
            vc.allowPickingVideo = false
            vc.photoPreviewPageUIConfigBlock = { _, _, _, _, _, _, originalPhotoButton, originalPhotoLabel, _, _, _ in
                originalPhotoButton?.alpha = 0
            }
            vc.photoPickerPageUIConfigBlock = { _, _, previewButton, originalPhotoButton, originalPhotoLabel, _ , _, _, _ in
                previewButton?.isHidden = true
                originalPhotoButton?.isHidden = true
                originalPhotoLabel?.isHidden = true
            }
            self?.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc private func buyAction() {
        guard let model = addressView.viewModel.addressModelProperty.value else { return }
        
        var params: [String: Any] = [
            "address": model.district + model.address,
            "duid": viewModel.did,
            "mobile": model.mobile,
            "puid": patientId,
            "realName": model.consignee,
        ]
        
        if let orderModel = viewModel.myPrivateDoctorOrderProperty.value {
            params["keyObject"] = "阳光续药"
            params["orderId"] = orderModel.orderId
            params["productItmId"] = orderModel.productItemId
            params["productName"] = orderModel.product_name
            params["serCode"] = orderModel.ser_code
            params["workType"] = "TSK_WORK_T_20"
            params["consultContent"] = addressView.remarkInputView.textView.text!
            params["fromWhere"] = 1
        } else {
            params["remark"] = addressView.remarkInputView.textView.text!
        }
        
        viewModel.buySunnyDrug(params: params)
    }
}
// MARK: - Delegate External

// MARK: -

extension SunnyDrugBuyController: TZImagePickerControllerDelegate {    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        viewModel.selectImageProperty.value = photos.first
        idView.picView.image = photos.first
    }
}

// MARK: - Helper
extension SunnyDrugBuyController {
    func updateContentHeight() {
        print(#function)
        contentView.layoutHeight()
        contentView.snp.updateConstraints { (make) in
            make.height.equalTo(contentView.zz_height)
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.zz_width, height: max(contentView.zz_height, UIScreen.zz_safeFrameUnderNavigation.height) + 10)
    }
}
