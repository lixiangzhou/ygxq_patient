//
//  HealthDataECGShowController.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/12.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataECGShowController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "心电数据"
        setUI()
        setBinding()
        viewModel.isBuyECG()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        setNavigationStyle(.transparency)
//        viewModel.getData()
    }

    // MARK: - Public Property
    
    let viewModel = HealthDataECGShowViewModel()
    // MARK: - Private Property
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let panelView = HealthDataECGPanelView()
    let healthLineView = HealthDataLineView()
}

// MARK: - UI
extension HealthDataECGShowController {
    override func setUI() {
        setRightBarItem(title: "监测历史", action: #selector(historyAction))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(panelView)
        contentView.addSubview(healthLineView)
        
        healthLineView.lineView.maxYValue = 200
        healthLineView.lineView.rowCountValue = 5
        
        addLineColorView()
        
        panelView.startClosure = {
            
        }
        
        healthLineView.titleLabel.text = "心率值(bpm)"
        
        healthLineView.lineView.selectClosure = { [weak self] idx in
            guard let self = self else { return }
            
            self.panelView.aveLabel.text = self.viewModel.showValues[0][idx].description
            self.panelView.maxLabel.text = self.viewModel.showValues[1][idx].description
            self.panelView.minLabel.text = self.viewModel.showValues[2][idx].description
            
            let model = self.viewModel.dataSourceProperty.value[idx]
            self.panelView.valueLabel.text = self.viewModel.getStateString(model)
            self.panelView.timeLabel.text = self.viewModel.showTimes[idx].toTime()
        }

        healthLineView.selectDateClosure = { [weak self] date in
            self?.viewModel.selectDate = date
            self?.viewModel.getLastData()
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
        let colorView = UIView()
        let v1 = getColorView(title: "平均心率", color: .cfd7b55)
        let v2 = getColorView(title: "最高心率", color: .cffa84c)
        let v3 = getColorView(title: "最低心率", color: .cfdad2b)
        colorView.addSubview(v1)
        colorView.addSubview(v2)
        colorView.addSubview(v3)
        healthLineView.addSubview(colorView)

        colorView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.bottom.equalTo(healthLineView.titleLabel)
        }

        v1.snp.makeConstraints { (make) in
            make.right.equalTo(v2.snp.left).offset(10)
            make.width.equalTo(100)
            make.top.bottom.equalToSuperview()
        }

        v2.snp.makeConstraints { (make) in
            make.width.equalTo(v1)
            make.top.equalTo(5)
            make.right.equalToSuperview()
        }
        
        v3.snp.makeConstraints { (make) in
            make.width.equalTo(v1)
            make.bottom.equalTo(-5)
            make.right.equalToSuperview()
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
        viewModel.isBuyECGProperty.signal.observeValues { [weak self] (isBuy) in
            if !isBuy {
                AlertView.show(title: nil, msg: "您还没有购买过心电监测套餐，无法进行心电监测，是否现在购买？", firstTitle: "再想想", secondTitle: "去购买", firstClosure: { (alert) in
                    alert.hide()
                    self?.pop()
                }) { (alert) in
                    self?.viewModel.checkToBuy({ (model) in
                        let vc = HutPackageDetailController()
                        vc.viewModel.hutModelProperty.value = model
                        vc.viewModel.from = .ecg
                        self?.push(vc)
                        alert.hide()
                    })
                }
            }
        }
        
        viewModel.dataSourceProperty.signal.observeValues { [weak self] (models) in
            guard let self = self else { return }
            if !models.isEmpty {
                let model = models.last!

                self.panelView.valueLabel.text = self.viewModel.getStateString(model)
                self.panelView.timeLabel.text = model.requestTime.isEmpty ? "--" : model.requestTime

                self.panelView.aveLabel.text = model.avgHeartRate.isEmpty ? "--" : model.avgHeartRate
                self.panelView.maxLabel.text = model.maxHeartRate.isEmpty ? "--" : model.maxHeartRate
                self.panelView.minLabel.text = model.minHeartRate.isEmpty ? "--" : model.minHeartRate
                
                self.processLineData(models)

            } else {
                self.panelView.valueLabel.text = "--"
                self.panelView.timeLabel.text = "--"
                
                self.panelView.aveLabel.text = "--"
                self.panelView.maxLabel.text = "--"
                self.panelView.minLabel.text = "--"
            }
        }
        
        viewModel.selectDateECGModelProperty.signal.observeValues { [weak self] (model) in
            guard let self = self else { return }
           
            self.panelView.valueLabel.text = self.viewModel.getStateString(model)
            self.panelView.timeLabel.text = model.requestTime.isEmpty ? "--" : model.requestTime
            self.panelView.aveLabel.text = model.avgHeartRate.isEmpty ? "--" : model.avgHeartRate
            self.panelView.maxLabel.text = model.maxHeartRate.isEmpty ? "--" : model.maxHeartRate
            self.panelView.minLabel.text = model.minHeartRate.isEmpty ? "--" : model.minHeartRate
        }
    }
}

// MARK: - Action
extension HealthDataECGShowController {
    @objc private func historyAction() {
        
    }
}

// MARK: - Helper
extension HealthDataECGShowController {
    private func processLineData(_ models: [HealthDataECGModel]) {
        var times = [String]()
        
        var values0 = [Int]()
        var values1 = [Int]()
        var values2 = [Int]()
        
        var timeValues = [TimeInterval]()
        
        for m in models {
            let t = m.createTime.toTime(format: "MM-dd")
            times.append(t)
            timeValues.append(m.createTime)
            
            values0.append(Int(m.avgHeartRate) ?? 0)
            values1.append(Int(m.maxHeartRate) ?? 0)
            values2.append(Int(m.minHeartRate) ?? 0)
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
        
        if !values2.isEmpty {
            values.append(values2)
        }
        
        viewModel.showTimes = timeValues
        viewModel.showValues = values

        healthLineView.lineView.pointYs = [
            LineView.LineModel(lineColor: .cfd7b55, string: "平均心率", values: values0),
            LineView.LineModel(lineColor: .cffa84c, string: "最高心率", values: values1),
            LineView.LineModel(lineColor: .cfdad2b, string: "最低心率", values: values2),
        ]
        
        healthLineView.lineView.pointXs = times
        healthLineView.lineView.refreshViews()
    }
}
