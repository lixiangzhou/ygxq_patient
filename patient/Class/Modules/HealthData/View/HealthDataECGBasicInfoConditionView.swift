//
//  HealthDataECGBasicInfoConditionView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataECGBasicInfoConditionView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    
    // MARK: - Private Property
    var btns = [UIButton]()
}

// MARK: - UI
extension HealthDataECGBasicInfoConditionView {
    private func setUI() {
        backgroundColor = .cf
        
        let titleView = TextLeftRightView()
        titleView.config = TextLeftRightViewConfig(leftFont: .boldSize(15), leftTextColor: .c3)
        titleView.leftLabel.text = "检查前身体状况"
        addSubview(titleView)
        
        let conditionView = zz_add(subview: UIView())
        
        let conditions = ["无明显不适", "肩背不适", "上腹痛", "头晕、黑蒙", "呼吸困难", "乏力", "恶心、呕吐", "咽喉不适", "大汗", "胸闷、胸痛", "心悸、心慌", "咳血"]
        let column: CGFloat = 3
        let margin: CGFloat = 15
        let width: CGFloat = 100
        let paddingX: CGFloat = (UIScreen.zz_width - margin * 2 - column * width) / (column - 1)
        let height: CGFloat = 30
        
        for (idx, c) in conditions.enumerated() {
            let row = CGFloat(idx / Int(column))
            let col = CGFloat(idx).truncatingRemainder(dividingBy: column)
            let x = margin + col * (width + paddingX)
            let y = margin + row * (height + margin)
            
            let btn = UIButton(title: c, font: .size(14), titleColor: .c3, target: self, action: #selector(selectAction))
            btn.setTitleColor(.c7c97b0, for: .selected)
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
            btn.zz_setCorner(radius: 15, masksToBounds: true)
            btn.tag = idx
            setBtnState(btn)
                        
            btns.append(btn)
            conditionView.addSubview(btn)
        }
        
        btns.first!.isSelected = true
        setBtnState(btns.first!)
        
        let cdtHeight = conditionView.subviews.last!.zz_maxY + margin
        
        addBottomLine(color: .cf0efef, height: 10)
        
        titleView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(45)
        }
        
        conditionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.height.equalTo(cdtHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-10)
        }
    }
}

// MARK: - Action
extension HealthDataECGBasicInfoConditionView {
    @objc private func selectAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        setBtnState(sender)
        
        if sender.tag == 0 && sender.isSelected {
            for btn in btns {
                if btn.tag > 0 {
                    btn.isSelected = false
                    setBtnState(btn)
                }
            }
        }
        
        if sender.tag != 0 && sender.isSelected {
            btns.first!.isSelected = false
            setBtnState(btns.first!)
        }
    }
    
    private func setBtnState(_ btn: UIButton) {
        btn.backgroundColor = btn.isSelected ? UIColor.cf0fafc : UIColor.cf5f5f5
        btn.zz_setBorder(color: .cdcdcdc, width: btn.isSelected ? 0.5 : 0)
    }
}
