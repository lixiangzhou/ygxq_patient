//
//  HealthDataInputDateView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/9.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataInputDateView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let timeLabel = UILabel(text: Date().zz_string(withDateFormat: "yyyy-MM-dd HH:mm"), font: .size(16), textColor: .c3)
    var timeDidSetClosure: ((Date) -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension HealthDataInputDateView {
    private func setUI() {
        backgroundColor = .cf
        
        let descLabel = UILabel(text: "测量日期", font: .size(16), textColor: .cff9a21)
        addSubview(descLabel)
        
        timeLabel.isUserInteractionEnabled = true
        let arrowView = UIImageView.defaultRightArrow()
        
        addSubview(timeLabel)
        addSubview(arrowView)
        
        timeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timeAction)))
        
        descLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(arrowView.snp.left).offset(-10)
            make.top.bottom.equalToSuperview()
        }
    }
}

// MARK: - Action
extension HealthDataInputDateView {
    @objc private func timeAction() {
        let dateView = DateView()
        dateView.picker.date = timeLabel.text!.zz_date(withDateFormat: "yyyy-MM-dd HH:mm")!
        dateView.finishClosure = { [weak self] date in
            self?.timeLabel.text = date.zz_string(withDateFormat: "yyyy-MM-dd HH:mm")
            self?.timeDidSetClosure?(date)
        }
        dateView.show()
    }
}
