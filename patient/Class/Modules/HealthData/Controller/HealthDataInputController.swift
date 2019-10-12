//
//  HealthDataInputController.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/9.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataInputController: BaseController {

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "手动输入"
        setUI()
        setBinding()
    }

    // MARK: - Public Property
    let viewModel = HealthDataInputViewModel()
    
    // MARK: - Private Property
    let scrollView = UIScrollView()
    let contentView = UIView()

    var lastView: UIView!
}

// MARK: - UI
extension HealthDataInputController {
    override func setUI() {
        setRightBarItem(title: "保存", action: #selector(saveAction))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        switch viewModel.type {
        case "HLR_HLG_T_10":
            addHeartRateView()
        case "HLR_HLG_T_01":
            addBloodPressureView()
        default:
            return
        }
        
        let dateInputView = HealthDataInputDateView()
        dateInputView.zz_setCorner(radius: 6, masksToBounds: true)
        contentView.addSubview(dateInputView)
        
        dateInputView.timeDidSetClosure = { [weak self] date in
            self?.viewModel.selectedDate = date
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(UIScreen.zz_width)
            make.height.equalTo(UIScreen.zz_height)
        }
        
        dateInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lastView.snp.bottom).offset(12)
            make.left.right.height.equalTo(lastView)
        }
    }
    
    private func addBloodPressureView() {
        let inputView1 = HealthDataInputRowView()
        inputView1.zz_setCorner(radius: 6, masksToBounds: true)
        contentView.addSubview(inputView1)
        
        inputView1.dataSource = [Int](1...300)
        inputView1.value = 120
        self.viewModel.values.append(inputView1.value)
        inputView1.dataChangeClosure = { [weak self] value in
            self?.viewModel.values.replaceSubrange(0...0, with: [value])
            return self?.viewModel.bloodPresureHight(value: value)
        }
        
        let inputView2 = HealthDataInputRowView()
        inputView2.zz_setCorner(radius: 6, masksToBounds: true)
        contentView.addSubview(inputView2)
        
        inputView2.dataSource = [Int](1...300)
        inputView2.value = 80
        self.viewModel.values.append(inputView2.value)
        inputView2.dataChangeClosure = { [weak self] value in
            self?.viewModel.values.replaceSubrange(1...1, with: [value])
            return self?.viewModel.bloodPresureLow(value: value)
        }
        
        inputView1.dataLabel.attributedText = inputView1.dataChangeClosure?(inputView1.value)
        inputView2.dataLabel.attributedText = inputView2.dataChangeClosure?(inputView2.value)
        
        lastView = inputView2
        
        inputView1.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(65)
        }

        inputView2.snp.makeConstraints { (make) in
            make.top.equalTo(inputView1.snp.bottom).offset(12)
            make.left.right.height.equalTo(inputView1)
        }

    }
    
    private func addHeartRateView() {
        let inputView = HealthDataInputRowView()
        inputView.zz_setCorner(radius: 6, masksToBounds: true)
        contentView.addSubview(inputView)
        
        inputView.dataSource = [Int](1...200)
        inputView.value = 60
        self.viewModel.values.append(inputView.value)
        inputView.dataChangeClosure = { [weak self] value in
            self?.viewModel.values.replaceSubrange(0...0, with: [value])
            return self?.viewModel.heartRate(value: value)
        }
        
        inputView.dataLabel.attributedText = inputView.dataChangeClosure?(inputView.value)
        
        lastView = inputView
        
        inputView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(65)
        }
    }
    
    override func setBinding() {
        viewModel.saveResultProperty.signal.observeValues { [weak self] (isSuccess) in
            if isSuccess {
                self?.pop()
            }
        }
    }
}

// MARK: - Action
extension HealthDataInputController {
    @objc private func saveAction() {
        viewModel.save()
    }
}

