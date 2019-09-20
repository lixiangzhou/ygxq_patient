//
//  HutPackageTimeBuyCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/20.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveSwift

class HutPackageTimeBuyCell: UITableViewCell {
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    let nameLabel = UILabel(font: .boldSize(17), textColor: .c3)
    let priceLabel = UILabel(font: .size(14), textColor: .cff3a33)
    let countLabel = UILabel(text: "1", font: .size(17), textColor: .c6, textAlignment: .center)
    
    let countProperty = MutableProperty<Int>(1)
    // MARK: - Private Property
    
}

// MARK: - UI
extension HutPackageTimeBuyCell {
    private func setUI() {
        backgroundColor = .cf0efef
        
        let whiteView = contentView.zz_add(subview: UIView())
        whiteView.zz_setCorner(radius: 6, masksToBounds: true)
        whiteView.backgroundColor = .cf
        
        whiteView.addSubview(nameLabel)
        whiteView.addSubview(priceLabel)
        
        let btn1 = UIButton(imageName: "service_minus")
        let btn2 = UIButton(imageName: "service_plus")
        
        btn1.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
            guard let self = self else { return }
            let value = Int(self.countLabel.text ?? "1")!
            self.countProperty.value = max(1, value - 1)
        }
        
        btn2.reactive.controlEvents(.touchUpInside).observeValues { [weak self] (_) in
            guard let self = self else { return }
            let value = Int(self.countLabel.text ?? "1")!
            self.countProperty.value = value + 1
        }
        
        countLabel.reactive.text <~ countProperty.producer.map { $0.description }
        
        whiteView.addSubview(btn1)
        whiteView.addSubview(countLabel)
        whiteView.addSubview(btn2)
        
        whiteView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(15)
            make.bottom.equalTo(-12)
            make.right.equalTo(-15)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(-15)
        }
        
        btn1.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.centerY.equalTo(countLabel)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(priceLabel)
            make.left.equalTo(btn1.snp.right)
            make.width.equalTo(35)
            make.right.equalTo(btn2.snp.left)
        }
        
        btn2.snp.makeConstraints { (make) in
            make.width.height.centerY.equalTo(btn1)
            make.right.equalTo(-15)
        }
    }
}
