//
//  HealthDataPanelView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/8.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataPanelView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 310 + UIScreen.zz_statusBar_additionHeight))
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let valueLabel = UILabel(text: "  ", font: .boldSize(30), textColor: .cf)
    let unitLabel = UILabel(text: "  ", font: .size(12), textColor: .cf)
    let timeLabel = UILabel(text: "  ", font: .size(13), textColor: .cf)
    
    var addClosure: (() -> Void)?
    var inputClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension HealthDataPanelView {
    private func setUI() {
        let bgView = UIImageView(image: UIImage(named: "health_input_top_bg"))
        addSubview(bgView)
        
        let panelView = UIImageView(image: UIImage(named: "health_input_panel"))
        addSubview(panelView)
        
        panelView.addSubview(valueLabel)
        panelView.addSubview(unitLabel)
        panelView.addSubview(timeLabel)
        
        let addBtn = UIButton(title: "添加设备", font: .size(16), titleColor: .cf, target: self, action: #selector(addAction))
        let inputBtn = UIButton(title: "手动输入", font: .size(16), titleColor: .cf, target: self, action: #selector(inputAction))
        
        addBtn.zz_setBorder(color: .cf, width: 1)
        addBtn.zz_setCorner(radius: 6, masksToBounds: true)
        
        inputBtn.zz_setBorder(color: .cf, width: 1)
        inputBtn.zz_setCorner(radius: 6, masksToBounds: true)
        
        addSubview(addBtn)
        addSubview(inputBtn)
        
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
        
        unitLabel.snp.makeConstraints { (make) in
            make.top.equalTo(valueLabel.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(unitLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        addBtn.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.bottom.equalTo(-25)
            make.width.equalTo(130)
            make.height.equalTo(45)
        }
        
        inputBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.bottom.width.height.equalTo(addBtn)
        }
    }
}

// MARK: - Action
extension HealthDataPanelView {
    @objc private func addAction() {
        addClosure?()
    }
    
    @objc private func inputAction() {
        inputClosure?()
    }
}
