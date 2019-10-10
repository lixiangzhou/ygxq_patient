//
//  HealthDataShowController.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/9.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataShowController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        setUI()
        setBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        setNavigationStyle(.transparency)
        viewModel.getData()
    }

    // MARK: - Public Property
    
    let viewModel = HealthDataShowViewModel()
    // MARK: - Private Property
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let panelView = HealthDataPanelView()
    let healthLineView = HealthDataLineView()
    
}

// MARK: - UI
extension HealthDataShowController {
    override func setUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(panelView)
        contentView.addSubview(healthLineView)
        
        addLineColorView()
        
        panelView.addClosure = {
            AlertView.show(title: nil, msg: "此功能暂未开通，敬请期待", firstTitle: nil, secondTitle: "我知道了", firstClosure: nil) { (alert) in
                alert.hide()
            }
        }
        
        panelView.inputClosure = { [weak self] in
            let vc = HealthDataInputController()
            vc.viewModel.type = self?.viewModel.type ?? ""
            vc.viewModel.saveResultProperty.signal.observeValues { (isSuccess) in
                if isSuccess {
                    self?.viewModel.selectDate = Date()
                }
            }
            
            self?.push(vc)
        }
        
        healthLineView.titleLabel.text = viewModel.lineTitle
        healthLineView.lineView.selectClosure = { [weak self] idx in
            guard let self = self else { return }
            
            switch self.viewModel.type {
            case "HLR_HLG_T_01":
                let high = self.viewModel.showValues[0][idx]
                let low = self.viewModel.showValues[1][idx]
                self.panelView.valueLabel.text = "\(high)/\(low)"
            default:
                self.panelView.valueLabel.text = String(self.viewModel.showValues.first![idx])
            }
            self.panelView.timeLabel.text = self.viewModel.showTimes[idx].toTime()
        }
        
        healthLineView.selectDateClosure = { [weak self] date in
            self?.viewModel.selectDate = date
            self?.viewModel.getData()
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(-UIScreen.zz_navHeight)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(UIScreen.zz_width)
            make.height.equalTo(UIScreen.zz_height)
        }
        
        panelView.snp.makeConstraints { (make) in
            make.right.left.top.equalToSuperview()
            make.height.equalTo(panelView.zz_height)
        }
        
        healthLineView.snp.makeConstraints { (make) in
            make.top.equalTo(panelView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(healthLineView.zz_height)
        }
    }
    
    private func addLineColorView() {
        switch viewModel.type {
        case "HLR_HLG_T_01":
            let colorView = UIView()
            let v1 = getColorView(title: "低压", color: .cff7b4f)
            let v2 = getColorView(title: "高压", color: .cffa306)
            colorView.addSubview(v1)
            colorView.addSubview(v2)
            healthLineView.addSubview(colorView)
            
            colorView.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.top.bottom.equalTo(healthLineView.titleLabel)
            }
            
            v1.snp.makeConstraints { (make) in
                make.right.equalTo(v2.snp.left).offset(10)
                make.width.equalTo(70)
                make.top.bottom.equalToSuperview()
            }
            
            v2.snp.makeConstraints { (make) in
                make.width.top.bottom.equalTo(v1)
                make.right.equalToSuperview()
            }
        default:
            break
        }
    }
    
    private func getColorView(title: String, color: UIColor) -> UIView {
        let btn = UIButton(title: " " + title, font: .size(13), titleColor: .c6)
        btn.isEnabled = false
        btn.setImage(UIImage.zz_image(withColor: color, imageSize: CGSize(width: 20, height: 10)), for: .normal)
        btn.sizeToFit()
        return btn
    }
    
    override func setBinding() {
        viewModel.dataSourceProperty.signal.observeValues { [weak self] (models) in
            guard let self = self else { return }
            if !models.isEmpty {
                let model = models.last!
                
                switch self.viewModel.type {
                case "HLR_HLG_T_01":
                    self.panelView.valueLabel.text = model.healthLogValues?.description ?? "  "
                default:
                    self.panelView.valueLabel.text = model.healthLogValue?.description ?? "  "
                }
                
                self.panelView.unitLabel.text = model.unit
                self.panelView.timeLabel.text = model.createTime?.toTime() ?? "  "
                
                self.processLineData(models)
                
            } else {
                self.panelView.valueLabel.text = "  "
                self.panelView.unitLabel.text = "  "
                self.panelView.timeLabel.text = "  "
            }
        }
    }
}

// MARK: - Helper
extension HealthDataShowController {
    private func processLineData(_ models: [HealthDataModel]) {
        var times = [String]()
        var values0 = [Int]()
        var values1 = [Int]()
        var timeValues = [TimeInterval]()
        
        for m in models {
            if let time = m.createTime, let value = m.healthLogValue {
                let t = time.toTime(format: "MM-dd")
                if !timeValues.contains(time) {
                    times.append(t)
                    timeValues.append(time)
                }
                
                switch m.healthLogType {
                case "HLR_HLG_T_01":
                    values0.append(value)
                case "HLR_HLG_T_02":
                    values1.append(value)
                case "HLR_HLG_T_10":
                    values0.append(value)
                default: break
                }
            }
        }
        
        if !timeValues.isEmpty {
            healthLineView.lineEmpytLabel.isHidden = true
        }
        
        var values = [[Int]]()
        if !values0.isEmpty {
            values.append(values0)
        }
        if !values1.isEmpty {
            values.append(values1)
        }
        
        viewModel.showTimes = timeValues
        viewModel.showValues = values
        
        switch viewModel.type {
        case "HLR_HLG_T_01":
            healthLineView.lineView.pointYs = [
                LineView.LineModel(lineColor: .cffa306, string: self.viewModel.title, values: values0),
                LineView.LineModel(lineColor: .cff7b4f, string: self.viewModel.title, values: values1)
            ]
        case "HLR_HLG_T_10":
            healthLineView.lineView.pointYs = [
                LineView.LineModel(lineColor: .cff9a21, string: self.viewModel.title, values: values0)
            ]
        default: break
        }
        
        healthLineView.lineView.pointXs = times
        
        healthLineView.lineView.maxYValue = 200
        healthLineView.lineView.rowCountValue = 5
        healthLineView.lineView.refreshViews()
    }
}

// MARK: - Other
extension HealthDataShowController {
    
}

// MARK: - Public
extension HealthDataShowController {
    
}

