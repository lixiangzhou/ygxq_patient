//
//  HealthDataECGDetailController.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataECGDetailController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "评估详情"
        setUI()
        setBinding()
    }

    // MARK: - Public Property
    let viewModel = HealthDataECGDetailViewModel()
    // MARK: - Private Property
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let infoView = TextLeftRightView()
    private let evaluateView = TextLeftRightView()
    private let reportLabel = UILabel(font: .size(14), textColor: .c3)
    private let feelView = TextLeftGrowTextRightView()
    private let remarkView = TextLeftGrowTextRightView()
    private let hasView = TextLeftRightView()
}

// MARK: - UI
extension HealthDataECGDetailController {
    override func setUI() {
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        view.addSubview(scrollView)
        contentView.backgroundColor = .cf0efef
        scrollView.addSubview(contentView)
        
        let titleConfig = TextLeftRightViewConfig(leftFont: .boldSize(15), rightFont: .size(14), hasBottomLine: false)
        
        infoView.config = titleConfig
        infoView.leftLabel.text = "个人信息"
        infoView.backgroundColor = .cf
        contentView.addSubview(infoView)
        
        let reportView = contentView.zz_add(subview: UIView())
        reportView.backgroundColor = .cf
        
        let reportTitleView = TextLeftRightView()
        reportTitleView.config = TextLeftRightViewConfig(leftFont: .boldSize(15))
        reportTitleView.leftLabel.text = "报告内容"
        reportView.addSubview(reportTitleView)
        
        reportView.addSubview(reportLabel)
        
        evaluateView.backgroundColor = .cf
        evaluateView.config = titleConfig
        evaluateView.leftLabel.text = "评估分类"
        contentView.addSubview(evaluateView)
        
        let conditionView = contentView.zz_add(subview: UIView())
        conditionView.backgroundColor = .cf
        
        let conditionTitleView = TextLeftRightView()
        conditionTitleView.config = TextLeftRightViewConfig(leftFont: .boldSize(15))
        conditionTitleView.leftLabel.text = "采集前身体状况"
        conditionView.addSubview(conditionTitleView)
        
        let config = TextLeftGrowTextRightViewConfig(leftTopPadding: 15, leftBottomPadding: 15, leftWidth: 100, leftFont: .size(14), leftTextColor: .c6, leftAlignment: .top, rightPadding: 15, rightTopPadding: 15, rightBottomPadding: 15, rightFont: .size(14), rightTextColor: .c3, rightAlignment: .right, leftToRightMargin: 20, hasBottomLine: true)
        
        feelView.config = config
        remarkView.config = config
        feelView.leftLabel.text = "个人感觉"
        remarkView.leftLabel.text = "备注"
        
        conditionView.addSubview(feelView)
        conditionView.addSubview(remarkView)
        
        hasView.config = titleConfig
        hasView.leftLabel.text = "植入心脏起搏器"
        hasView.backgroundColor = .cf
        contentView.addSubview(hasView)
        
        let lookBtn = contentView.zz_add(subview: UIButton(title: "查看心电图报告", font: .size(16), titleColor: .cf, backgroundColor: .c407cec, target: self, action: #selector(lookAction)))
        lookBtn.zz_setCorner(radius: 20, masksToBounds: true)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalTo(UIScreen.zz_width)
            make.height.equalTo(UIScreen.zz_height)
        }
        
        infoView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        reportView.snp.makeConstraints { (make) in
            make.top.equalTo(infoView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        reportTitleView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        reportLabel.snp.makeConstraints { (make) in
            make.top.equalTo(reportTitleView.snp.bottom).offset(15)
            make.left.equalTo(15)
            make.right.bottom.equalTo(-15)
        }
        
        evaluateView.snp.makeConstraints { (make) in
            make.top.equalTo(reportView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        conditionView.snp.makeConstraints { (make) in
            make.top.equalTo(evaluateView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        conditionTitleView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        feelView.snp.makeConstraints { (make) in
            make.top.equalTo(conditionTitleView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        remarkView.snp.makeConstraints { (make) in
            make.top.equalTo(feelView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        hasView.snp.makeConstraints { (make) in
            make.top.equalTo(conditionView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        lookBtn.snp.makeConstraints { (make) in
            make.top.equalTo(hasView.snp.bottom).offset(20)
            make.width.equalTo(140)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
    }
    
    override func setBinding() {
        viewModel.dataProperty.producer.startWithValues { [weak self] (model) in
            let birth = model.birthday.zz_date(withDateFormat: "yyyy-MM-dd")
            let age = birth != nil ? getAge(birth!.timeIntervalSince1970 * 1000) : nil
            self?.infoView.rightLabel.text = "\(model.name)（\(model.sex), \(age ?? 0)）岁"
            self?.reportLabel.text = model.diagnosis
            
            switch model.emergency {
            case "1":
                self?.evaluateView.rightLabel.text = "普通"
            case "2":
                self?.evaluateView.rightLabel.text = "急"
            case "3":
                self?.evaluateView.rightLabel.text = "紧急"
            case "4":
                self?.evaluateView.rightLabel.text = "无法评估"
            default:
                self?.evaluateView.rightLabel.text = "--"
            }
            
            self?.feelView.rightLabel.text = model.physSign
            self?.remarkView.rightLabel.text = model.remark.isEmpty ? "无" : model.remark
            
            switch model.pacemakerInd {
            case -1: self?.hasView.rightLabel.text = "未知"
            case 1: self?.hasView.rightLabel.text = "是"
            case 0: self?.hasView.rightLabel.text = "否"
            default: break
            }
        }
    }
}

// MARK: - Action
extension HealthDataECGDetailController {
    @objc private func lookAction() {
        let model = viewModel.dataProperty.value
        
        let vc = HealthDataECGPicShowController()
        vc.imageView.contentMode = .scaleAspectFit
        HUD.showLoding()
        vc.imageView.kf.setImage(with: URL(string: model.finalEcgReport), placeholder: UIImage(named: "service_placeholder")) { (result) in
            HUD.hideLoding()
            switch result {
            case .failure:
                vc.imageView.image = UIImage(named: "service_neterror")
            case .success:
                vc.imageView.contentMode = .scaleToFill
                
                vc.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                let w = UIScreen.zz_safeFrameUnderNavigation.width
                let h = UIScreen.zz_safeFrameUnderNavigation.height
                vc.imageView.transform = vc.imageView.transform.scaledBy(x: h / w, y: w / h)
            }
        }
        push(vc)
    }
}
