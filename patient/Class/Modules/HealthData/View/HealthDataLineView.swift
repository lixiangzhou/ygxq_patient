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
    let lineEmpytLabel = UILabel(text: "无数据", font: .size(16), textColor: .c6, textAlignment: .center)
    let calendarView = YFDayCalendarView()
    var selectDateClosure: ((Date) -> Void)?
}

// MARK: - UI
extension HealthDataLineView {
    private func setUI() {
        backgroundColor = .clear
        
        lineView.backgroundColor = .cf
        lineView.lineWidth = 2
        lineView.pointRadius = 3
        lineView.zz_setCorner(radius: 5, masksToBounds: true)
        
        calendarView.backgroundColor = .cf
        calendarView.componentTextColor = .c3
        calendarView.indicatorRadius = 15
        calendarView.boldPrimaryComponentText = false
        calendarView.selectedIndicatorColor = .cff7b4f
        calendarView.zz_setCorner(radius: 5, masksToBounds: true)
        calendarView.weekdayHeaderWeekendTextColor = .c6
        calendarView.weekdayHeaderTextColor = .c6
        calendarView.selectedDate = Date()
        
        lineEmpytLabel.backgroundColor = .cf
        lineEmpytLabel.zz_setCorner(radius: 5, masksToBounds: true)
        
        addSubview(titleLabel)
        addSubview(lineView)
        addSubview(lineEmpytLabel)
        addSubview(calendarView)
        
        let v1 = UIButton(imageName: "health_input_data")
        let v2 = UIButton(imageName: "health_input_date")
        v1.setImage(UIImage(named: "health_input_data_sel"), for: .disabled)
        v2.setImage(UIImage(named: "health_input_date_sel"), for: .disabled)
        
        addSubview(v1)
        addSubview(v2)
        
        calendarView.reactive.controlEvents(.valueChanged).observeValues { [weak self] (view) in
            self?.selectDateClosure?(view.selectedDate)
            v1.sendActions(for: .touchUpInside)
        }
        
        v1.reactive.controlEvents(.touchUpInside).observeValues { (_) in
            v1.isEnabled = !v1.isEnabled
            v2.isEnabled = !v1.isEnabled
            
            self.lineView.isHidden = v1.isEnabled
            self.calendarView.isHidden = !v1.isEnabled
        }
        
        v2.reactive.controlEvents(.touchUpInside).observeValues { (_) in
            v2.isEnabled = !v2.isEnabled
            v1.isEnabled = !v2.isEnabled
            
            self.lineView.isHidden = v1.isEnabled
            self.calendarView.isHidden = !v1.isEnabled
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
        
        lineEmpytLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(lineView)
        }
        
        calendarView.snp.makeConstraints { (make) in
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
