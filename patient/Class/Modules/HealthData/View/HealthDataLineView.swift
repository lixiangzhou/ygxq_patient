//
//  HealthDataLineView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/9.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HealthDataLineView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 350))
        
        setUI()
        
        currentBtnProperty.signal.skipNil().observeValues { [weak self] (btn) in
            guard let self = self else { return }
            self.dataBtn.isEnabled = self.dataBtn != btn
            self.dateBtn.isEnabled = self.dateBtn != btn
            
            self.lineView.isHidden = self.dataBtn.isEnabled
            self.calendarView.isHidden = !self.dataBtn.isEnabled
        }
        
        currentBtnProperty.value = dataBtn
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
    
    let dataBtn = UIButton(imageName: "health_input_data")
    let dateBtn = UIButton(imageName: "health_input_date")
    
    let currentBtnProperty = MutableProperty<UIButton?>(nil)
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

        dataBtn.setImage(UIImage(named: "health_input_data_sel"), for: .disabled)
        dateBtn.setImage(UIImage(named: "health_input_date_sel"), for: .disabled)
        dataBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        dateBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        addSubview(dataBtn)
        addSubview(dateBtn)
        
        calendarView.reactive.controlEvents(.valueChanged).skip(first: 1).observeValues { [weak self] (view) in
            guard let self = self else { return }
            
            self.selectDateClosure?(view.selectedDate)
            if self.dataBtn.isEnabled {
                self.currentBtnProperty.value = self.dataBtn
            }
        }
        
        dataBtn.sendActions(for: .touchUpInside)
        
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
        
        dataBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(12)
            make.width.height.equalTo(40)
            make.right.equalTo(lineView.snp.centerX).offset(-25)
        }
        
        dateBtn.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(dataBtn)
            make.left.equalTo(lineView.snp.centerX).offset(25)
        }
    }
}

extension HealthDataLineView {
    @objc private func btnAction(_ sender: UIButton) {
        currentBtnProperty.value = sender
    }
}
