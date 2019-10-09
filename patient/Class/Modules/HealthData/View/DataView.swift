//
//  DataView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/9.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class DataView: BaseShowView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let picker = UIPickerView()
    var dataSource = [Int]()
    
    var confirmClosure: ((Int) -> Void)?
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension DataView {
    private func setUI() {
        backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        let toolBar = UIView()
        toolBar.backgroundColor = .cf0efef
        addSubview(toolBar)
        
        let cancelBtn = UIButton(title: "取消", font: .size(17), titleColor: .c6, target: self, action: #selector(hide))
        let confirmBtn = UIButton(title: "确定", font: .size(17), titleColor: .c407cec, target: self, action: #selector(confirmAction))
        
        toolBar.addSubview(cancelBtn)
        toolBar.addSubview(confirmBtn)
        
        picker.backgroundColor = .cf
        picker.dataSource = self
        picker.delegate = self
        addSubview(picker)
        
        toolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.bottom.equalToSuperview()
        }
        
        picker.snp.makeConstraints { (make) in
            make.top.equalTo(toolBar.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
}

// MARK: - Action
extension DataView {
    @objc private func confirmAction() {
        hide()
        confirmClosure?(dataSource[picker.selectedRow(inComponent: 0)])
    }
}

// MARK: - UIPickerViewDataSource UIPickerViewDelegate
extension DataView: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].description
    }
}

// MARK: - Other
extension DataView {
    
}

// MARK: - Public
extension DataView {
    
}
