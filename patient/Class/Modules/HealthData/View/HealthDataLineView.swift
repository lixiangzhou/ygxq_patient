//
//  HealthDataLineView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/9.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataLineView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 350))
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    let titleLabel = UILabel(font: .size(16), textColor: .c3)
    let lineView = LineView()
    let calenderView = YFDayCalendarView()
}

// MARK: - UI
extension HealthDataLineView {
    private func setUI() {
        backgroundColor = .clear
        lineView.backgroundColor = .cf
        calenderView.backgroundColor = .cf
        
        addSubview(titleLabel)
        addSubview(lineView)
        addSubview(calenderView)
        
        let v1 = UIButton(imageName: "health_input_data", selectedImageName: "health_input_data_sel")
        let v2 = UIButton(imageName: "health_input_date", selectedImageName: "health_input_date_sel")
        
        addSubview(v1)
        addSubview(v2)
        
        
        v1.reactive.controlEvents(.touchUpInside).observeValues { (_) in
            v1.isSelected = !v1.isSelected
            v2.isSelected = !v1.isSelected
            
            self.lineView.isHidden = !v1.isSelected
            self.calenderView.isHidden = v1.isSelected
        }
        
        v2.reactive.controlEvents(.touchUpInside).observeValues { (_) in
            v2.isSelected = !v2.isSelected
            v1.isSelected = !v2.isSelected
            
            self.lineView.isHidden = !v1.isSelected
            self.calenderView.isHidden = v1.isSelected
        }
        
        v1.sendActions(for: .touchUpInside)
        
        lineView.showTop = false
        lineView.topPadding = 20
        lineView.bottomPadding = 50
        lineView.leftPadding = 40
        lineView.showInfoView = false
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.height.equalTo(45)
            make.top.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(15)
            make.width.equalTo(UIScreen.zz_width - 30)
            make.height.equalTo(230)
        }
        
        calenderView.snp.makeConstraints { (make) in
            make.edges.equalTo(lineView)
        }
        
        v1.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(12)
            make.width.height.equalTo(40)
            make.right.equalTo(lineView.snp.centerX).offset(-25)
        }
        
        v2.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(v1)
            make.left.equalTo(lineView.snp.centerX).offset(25)
        }
    }
}

// MARK: - Action
extension HealthDataLineView {
    
}

// MARK: - Helper
extension HealthDataLineView {
    
}

// MARK: - Other
extension HealthDataLineView {
    
}

// MARK: - Public
extension HealthDataLineView {
    
}
