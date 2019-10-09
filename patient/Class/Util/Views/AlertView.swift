//
//  AlertView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class AlertView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    let backgroundView = UIView()
    let contentView = UIView()
    let titleLabel = UILabel(font: .boldSize(17), textColor: .c3, textAlignment: .center)
    let msgLabel = UILabel(font: .size(15), textColor: .c3, textAlignment: .center)
    let firstBtn = UIButton(font: .size(16), titleColor: .c6, backgroundColor: .cf5f5f5, target: self, action: #selector(firstAction))
    let secondBtn = UIButton(font: .size(16), titleColor: .cf, backgroundColor: .c407cec, target: self, action: #selector(secondAction))
    
    var firstClosure: ((AlertView) -> Void)?
    var secondClosure: ((AlertView) -> Void)?
    // MARK: - Private Property
    private var showTitle = true
}

// MARK: - UI
extension AlertView {
    private func setUI() {
        backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        contentView.backgroundColor = .cf
        contentView.zz_setCorner(radius: 5, masksToBounds: true)
        addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(msgLabel)
        contentView.addSubview(firstBtn)
        contentView.addSubview(secondBtn)
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(285)
        }
        
        if showTitle {
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(20)
                make.centerX.equalToSuperview()
                make.left.equalTo(15)
                make.right.equalTo(-15)
            }
        }
        
        msgLabel.snp.makeConstraints { (make) in
            if showTitle {
                make.top.equalTo(titleLabel.snp.bottom).offset(25)
            } else {
                make.top.equalTo(25)
            }
            make.centerX.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        if firstBtn.currentTitle != nil && secondBtn.currentTitle != nil {
            firstBtn.snp.makeConstraints { (make) in
                make.top.equalTo(msgLabel.snp.bottom).offset(25)
                make.left.bottom.equalToSuperview()
                make.height.equalTo(40)
            }
            
            secondBtn.snp.makeConstraints { (make) in
                make.top.height.width.equalTo(firstBtn)
                make.left.equalTo(firstBtn.snp.right)
                make.right.bottom.equalToSuperview()
            }
        } else if firstBtn.currentTitle != nil {
            firstBtn.snp.makeConstraints { (make) in
                make.top.equalTo(msgLabel.snp.bottom).offset(25)
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(40)
            }
        } else if secondBtn.currentTitle != nil {
            secondBtn.snp.makeConstraints { (make) in
                make.top.equalTo(msgLabel.snp.bottom).offset(25)
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(40)
            }
        }
    }
}

// MARK: - Action
extension AlertView {
    @objc private func firstAction() {
        firstClosure?(self)
    }
    
    @objc private func secondAction() {
        secondClosure?(self)
    }
}

// MARK: - Helper
extension AlertView {
    
}

// MARK: - Other
extension AlertView {
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        alpha = 0
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        }) { (_) in
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func hide() {
        alpha = 1
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}

// MARK: - Public
extension AlertView {
    static func show(title: String?, msg: String, firstTitle: String?, secondTitle: String?, firstClosure: ((AlertView) -> Void)?, secondClosure: ((AlertView) -> Void)?) {
        let alertView = AlertView()
        alertView.titleLabel.text = title
        alertView.msgLabel.text = msg
        alertView.firstBtn.setTitle(firstTitle, for: .normal)
        alertView.secondBtn.setTitle(secondTitle, for: .normal)
        alertView.firstClosure = firstClosure
        alertView.secondClosure = secondClosure
        alertView.showTitle = title != nil
        
        alertView.setUI()
        
        alertView.show()
    }
}
