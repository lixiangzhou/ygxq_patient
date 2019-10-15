//
//  HealthDataECGBasinInfoController.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataECGBasinInfoController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "采集心电前基本情况"
        
        setUI()
        setBinding()
        viewModel.querySurpluNum()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.queryPatientConsultantList()
    }

    // MARK: - Public Property
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let topView = HealthDataECGBasinInfoTopView()
    let patientView = HealthDataECGBasicInfoPatientView()
    let conditionView = HealthDataECGBasicInfoConditionView()
    let otherView = HealthDataECGBasinInfoOtherView()
    
    let viewModel = HealthDataECGBasinInfoViewModel()
    // MARK: - Private Property
    
}

// MARK: - UI
extension HealthDataECGBasinInfoController {
    override func setUI() {
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topView)
        contentView.addSubview(patientView)
        contentView.addSubview(conditionView)
        contentView.addSubview(otherView)
        
        DispatchQueue.main.async {
            let offset = self.scrollView.contentOffset
            self.scrollView.setContentOffset(CGPoint(x: offset.x, y: offset.y + 0.1), animated: true)
        }
        
        let confirmBtn = UIButton(title: "确定", font: .size(16), titleColor: .cf, backgroundColor: .c407cec, target: self, action: #selector(confirmAction))
        
        view.addSubview(confirmBtn)
        
        patientView.infoClosure = { [weak self] in
            if self?.viewModel.selectPatientInfoProperty.value == nil {
                let vc = HealthDataMemberEditController()
                self?.viewModel.selectMode = .add
                self?.push(vc)
            } else {
                let vc = HealthDataMemberListController()
                self?.viewModel.selectMode = .select
                vc.selectClosure = { [weak self] m in
                    self?.viewModel.selectPatientInfo = m
                }
                self?.push(vc)
            }
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(UIScreen.zz_width)
            make.height.equalTo(UIScreen.zz_height)
        }
        
        topView.snp.makeConstraints { (make) in
            make.right.left.top.equalToSuperview()
            make.height.equalTo(60)
        }
        
        patientView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.right.left.equalToSuperview()
        }
        
        conditionView.snp.makeConstraints { (make) in
            make.top.equalTo(patientView.snp.bottom)
            make.right.left.equalToSuperview()
        }
        
        otherView.snp.makeConstraints { (make) in
            make.top.equalTo(conditionView.snp.bottom)
            make.right.left.equalToSuperview()
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottomOffsetFrom(self)
        }
    }
    
    override func setBinding() {
        topView.infoLabel.reactive.attributedText <~ viewModel.topInfoAttrProperty.producer
        
        viewModel.selectPatientInfoProperty.signal.observeValues { [weak self] (model) in
            if let model = model {
                if model.id == 0 && model.realName.isEmpty {
                    self?.patientView.nameLabel.text = "选择成员"
                    self?.patientView.nameLabel.textColor = .c9
                } else {
                    self?.patientView.nameLabel.text = model.realName
                    self?.patientView.nameLabel.textColor = .c3
                }
            } else {
                self?.patientView.nameLabel.text = "点击完成您的个人信息"
                self?.patientView.nameLabel.textColor = .c9
            }
        }
    }
}

// MARK: - Action
extension HealthDataECGBasinInfoController {
    @objc private func buyAction() {
        viewModel.checkToBuy { [weak self] (model) in
            let vc = HutPackageTimeBuyController()
            vc.viewModel.hutModelProperty.value = model
            self?.push(vc)
        }
    }
    
    @objc private func confirmAction() {
        guard let model = viewModel.selectPatientInfoProperty.value, model.id != 0, !model.realName.isEmpty else {
            HUD.show(toast: "请选择测量人的信息")
            return
        }
        
        var pacemaker_ind = -1
        if let select = patientView.select {
            pacemaker_ind = select ? 1 : 0
        }
        
        var phys_sign = ""
        for btn in conditionView.btns {
            if btn.isSelected {
                phys_sign.append("\(btn.tag) ")
            }
        }
        
        let info: [String: Any] = [
            "user_id": model.id.description,
            "user_name": model.realName,
            "sex": model.sex.description,
            "phone_number": "13333333333",
            "birthday": model.birth!.toTime(format: "yyyy-MM-dd"),
            "id_card": "",
            "app_ecg_id": "\(patientId)\(Int(Date().timeIntervalSince1970 * 1000))",
            "ecg_mode": viewModel.ecgMode,
            "phys_sign": phys_sign,
            "pacemaker_ind": pacemaker_ind.description
        ]
        
        let cardNo = context == .release ? "18435171908657539440" : "29350960875683080269"
        let cardKey = context == .release ? "11235372426" : "18202593751"
        
        let vc = AIEcgCollectViewController(deviceMac: [], ecgInfo: info, ecgCardNo: cardNo, ecgCardKey: cardKey, ecgDataBlock: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
        push(vc)
    }
}
