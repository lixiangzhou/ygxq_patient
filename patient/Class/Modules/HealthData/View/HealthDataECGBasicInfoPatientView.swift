//
//  HealthDataECGBasicInfoPatientView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/14.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataECGBasicInfoPatientView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let nameLabel = UILabel(font: .size(14), textColor: .c3)
    var select: Bool?
    var infoClosure: (() -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension HealthDataECGBasicInfoPatientView {
    private func setUI() {
        backgroundColor = .cf
        
        let titleView = TextLeftRightView()
        titleView.config = TextLeftRightViewConfig(leftFont: .boldSize(15), leftTextColor: .c3)
        titleView.leftLabel.text = "基本信息"
        addSubview(titleView)
        
        let infoView = zz_add(subview: UIView())
        let infoTitleLabel = infoView.zz_add(subview: UILabel(text: "个人信息", font: .size(14), textColor: .c6))
        infoView.addSubview(nameLabel)
        let arrowView = infoView.zz_add(subview: UIImageView.defaultRightArrow())
        infoView.addBottomLine()
        infoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(infoAction)))
        
        let selectView = zz_add(subview: UIView())
        let selectTitleLabel = selectView.zz_add(subview: UILabel(text: "是否植入心脏起搏器", font: .size(14), textColor: .c6))
        let yesBtn = selectView.zz_add(subview: ZZImagePositionButton(title: " 是  ", font: .size(14), titleColor: .c3, imageName: "health_input_unsel", selectedImageName: "health_input_sel", imgPosition: .right)) as! UIButton
        let noBtn = selectView.zz_add(subview: ZZImagePositionButton(title: " 否  ", font: .size(14), titleColor: .c3, imageName: "health_input_unsel", selectedImageName: "health_input_sel", imgPosition: .right)) as! UIButton
        
        yesBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (btn) in
            if !btn.isSelected {
                yesBtn.isSelected = !yesBtn.isSelected
                noBtn.isSelected = !yesBtn.isSelected
                self?.select = true
            }
        }
        
        noBtn.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (btn) in
            if !btn.isSelected {
                noBtn.isSelected = !noBtn.isSelected
                yesBtn.isSelected = !noBtn.isSelected
                self?.select = false
            }
        }
        
        addBottomLine(color: .cf0efef, height: 10)
        
        titleView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(45)
        }
        
        infoView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        infoTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(arrowView.snp.left).offset(-10)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
        }
        
        selectView.snp.makeConstraints { (make) in
            make.top.equalTo(infoView.snp.bottom)
            make.left.right.height.equalTo(infoView)
            make.bottom.equalTo(-10)
        }
        
        selectTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        yesBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(noBtn.snp.left).offset(-27)
        }

        noBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-15)
        }

    }
}

// MARK: - Action
extension HealthDataECGBasicInfoPatientView {
    @objc private func infoAction() {
        infoClosure?()
    }
}
