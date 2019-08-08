//
//  CommonPicker.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/5.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class CommonPicker: BaseView {
    
    enum DataSouce {
        case one([String])
        case two([GroupModel<String>])
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    let commmonPicker = UIPickerView()
    let cancelBtn = UIButton(title: "取消", font: .size(14), titleColor: .c407cec, target: self, action: #selector(cancelAction))
    let finishBtn = UIButton(title: "完成", font: .size(14), titleColor: .c407cec, target: self, action: #selector(finishAction))
    
    var dataSource: DataSouce? {
        didSet {
            commmonPicker.reloadAllComponents()
        }
    }
    
    func selectOne(_ one: String?) {
        guard let dataSource = dataSource, let one = one else { return }
        switch dataSource {
        case let .one(ds):
            if let idx = ds.firstIndex(of: one) {
                commmonPicker.selectRow(idx, inComponent: 0, animated: false)
            }
        case let .two(ds):
            for (idx, group) in ds.enumerated() {
                if group.title == one {
                    commmonPicker.selectRow(idx, inComponent: 0, animated: false)
                    break
                }
            }
        }
    }
    
    var finishClosure: ((CommonPicker) -> Void)?
    var cancelClosure: ((CommonPicker) -> Void)?
}

// MARK: - UI
extension CommonPicker {
    private func setUI() {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(bgView)
        
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        
        let toolBar = UIView()
        toolBar.backgroundColor = .cf0efef
        addSubview(toolBar)
        
        toolBar.addSubview(cancelBtn)
        toolBar.addSubview(finishBtn)
        
        commmonPicker.backgroundColor = .cf
        commmonPicker.dataSource = self
        commmonPicker.delegate = self
        addSubview(commmonPicker)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        toolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        finishBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.centerY.equalToSuperview()
        }
        
        commmonPicker.snp.makeConstraints { (make) in
            make.top.equalTo(toolBar.snp.bottom)
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}

extension CommonPicker: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let dataSource = dataSource else { return 0 }
        
        switch dataSource {
        case .one:
            return 1
        case .two:
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        
        switch dataSource {
        case let .one(ds):
            return ds.count
        case let .two(ds):
            if component == 0 {
                return ds.count
            } else {
                let row0 = pickerView.selectedRow(inComponent: 0)
                return ds[row0].list.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let dataSource = dataSource else { return nil }
        
        switch dataSource {
        case let .one(ds):
            return ds[row]
        case let .two(ds):
            if component == 0 {
                return ds[row].title
            } else {
                let row0 = pickerView.selectedRow(inComponent: 0)
                return ds[row0].list[row]
            }
        }
    }
}

// MARK: - Action
extension CommonPicker {
    @objc private func cancelAction() {
        hide()
        cancelClosure?(self)
    }
    
    @objc private func finishAction() {
        hide()
        finishClosure?(self)
    }
}

// MARK: - Public
extension CommonPicker {
    @discardableResult
    static func show() -> CommonPicker {
        let picker = CommonPicker()
        UIApplication.shared.keyWindow?.addSubview(picker)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        picker.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            picker.alpha = 1
        }) { (_) in
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        return picker
    }
    
    @objc func hide() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}
