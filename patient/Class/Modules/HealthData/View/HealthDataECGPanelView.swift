//
//  HealthDataECGPanelView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/12.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataECGPanelView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 350 + UIScreen.zz_statusBar_additionHeight))
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let valueLabel = UILabel(text: "  ", font: .boldSize(30), textColor: .cf)
    let timeLabel = UILabel(text: "  ", font: .size(13), textColor: .cf)
    
    var aveLabel: UILabel!
    var minLabel: UILabel!
    var maxLabel: UILabel!
    
    var startClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension HealthDataECGPanelView {
    private func setUI() {
        let bgView = UIImageView(image: UIImage(named: "health_input_top_bg"))
        addSubview(bgView)
        
        let panelView = UIImageView(image: UIImage(named: "health_input_panel"))
        addSubview(panelView)
        
        panelView.addSubview(valueLabel)
        panelView.addSubview(timeLabel)
        
        let (aveView, aveLabel) = addItem(title: "平均心率")
        let (maxView, maxLabel) = addItem(title: "最高心率")
        let (minView, minLabel) = addItem(title: "最低心率")
        
        addSepView(to: aveView)
        addSepView(to: maxView)
        
        self.aveLabel = aveLabel
        self.maxLabel = maxLabel
        self.minLabel = minLabel
        
        
        let startBtn = UIButton(title: "开始检测", font: .size(16), titleColor: .cf, target: self, action: #selector(startAction))
        startBtn.zz_setBorder(color: .cf, width: 1)
        startBtn.zz_setCorner(radius: 6, masksToBounds: true)
        addSubview(startBtn)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        panelView.snp.makeConstraints { (make) in
            make.top.equalTo(UIScreen.zz_navHeight + 8)
            make.centerX.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(46)
            make.centerX.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(valueLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        let width = UIScreen.zz_width / 3
        aveView.snp.makeConstraints { (make) in
            make.top.equalTo(panelView.snp.bottom).offset(-20)
            make.left.equalToSuperview()
            make.width.equalTo(width)
        }
        
        maxView.snp.makeConstraints { (make) in
            make.top.width.equalTo(aveView)
            make.centerX.equalToSuperview()
        }
        
        minView.snp.makeConstraints { (make) in
            make.top.width.equalTo(aveView)
            make.right.equalToSuperview()
        }
        
        startBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-15)
            make.width.equalTo(130)
            make.height.equalTo(45)
        }
    }
    
    private func addItem(title: String) -> (UIView, UILabel) {
        let view = UIView()
        let valueLabel = view.zz_add(subview: UILabel(text: "--", font: .boldSize(16), textColor: .cf)) as! UILabel
        let descLabel = view.zz_add(subview: UILabel(text: title, font: .size(15), textColor: .cf))
        
        valueLabel.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
            make.top.equalTo(valueLabel.snp.bottom)
        }
        
        addSubview(view)
        
        return (view, valueLabel)
    }
    
    private func addSepView(to: UIView) {
        let sep = UIImageView(image: UIImage(named: "health_input_sep"))
        to.addSubview(sep)
        sep.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}

// MARK: - Action
extension HealthDataECGPanelView {
    @objc private func startAction() {
        startClosure?()
    }
}
