//
//  HealthDataInputRowView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/9.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataInputRowView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let dataLabel = UILabel(textAlignment: .center)
    var dataSource = [Int]()
    
    var value: Int = 0
    
    // MARK: - Private Property
    var dataChangeClosure: ((Int) -> NSAttributedString?)?
}

// MARK: - UI
extension HealthDataInputRowView {
    private func setUI() {
        backgroundColor = .cf
        
        let leftView = UIImageView(image: UIImage(named: "health_input_date_left"))
        leftView.contentMode = .scaleAspectFit
        leftView.isUserInteractionEnabled = true
        leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(leftAction)))
        
        let rightView = UIImageView(image: UIImage(named: "health_input_date_right"))
        rightView.contentMode = .scaleAspectFit
        rightView.isUserInteractionEnabled = true
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rightAction)))
        
        dataLabel.isUserInteractionEnabled = true
        
        addSubview(leftView)
        addSubview(rightView)
        addSubview(dataLabel)
        
        dataLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dataAction)))
        
        leftView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.width.equalTo(30)
            make.top.bottom.equalToSuperview()
        }
        
        rightView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.width.top.bottom.equalTo(leftView)
        }
        
        dataLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(leftView.snp.right).offset(30)
            make.right.equalTo(rightView.snp.left).offset(-30)
        }
    }
}

// MARK: - Action
extension HealthDataInputRowView {
    @objc private func leftAction() {
        if value > dataSource.first! {
            value -= 1
            dataLabel.attributedText = dataChangeClosure?(value)
        }
    }
    
    @objc private func rightAction() {
        if value < dataSource.last! {
            value += 1
            dataLabel.attributedText = dataChangeClosure?(value)
        }
    }
    
    @objc private func dataAction() {
        let dataView = DataView()
        dataView.dataSource = dataSource
        dataView.picker.selectRow(dataSource.firstIndex(of: value)!, inComponent: 0, animated: false)
        dataView.confirmClosure = { [weak self] value in
            self?.value = value
            self?.dataLabel.attributedText = self?.dataChangeClosure?(value)
        }
        dataView.show()
    }
}
