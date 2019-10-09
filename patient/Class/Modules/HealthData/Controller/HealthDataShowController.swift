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
}

// MARK: - UI
extension HealthDataShowController {
    override func setUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(panelView)
        
        panelView.addClosure = {
            AlertView.show(title: nil, msg: "此功能暂未开通，敬请期待", firstTitle: nil, secondTitle: "我知道了", firstClosure: nil) { (alert) in
                alert.hide()
            }
        }
        
        panelView.inputClosure = { [weak self] in
            let vc = HealthDataInputController()
            vc.viewModel.type = self?.viewModel.type ?? ""
            self?.push(vc)
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
            } else {
                self.panelView.valueLabel.text = "  "
                self.panelView.unitLabel.text = "  "
                self.panelView.timeLabel.text = "  "
            }
        }
    }
}

// MARK: - Action
extension HealthDataShowController {
    
}

// MARK: - Network
extension HealthDataShowController {
    
}

// MARK: - Delegate Internal

// MARK: -

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension HealthDataShowController {
    
}

// MARK: - Other
extension HealthDataShowController {
    
}

// MARK: - Public
extension HealthDataShowController {
    
}

