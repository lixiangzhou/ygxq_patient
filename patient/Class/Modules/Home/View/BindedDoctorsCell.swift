//
//  BindedDoctorsCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/27.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class BindedDoctorsCell: UITableViewCell {
    
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
    let iconView = UIImageView(image: UIImage(named: "doctor_avator"))
    let nameLabel = UILabel(font: .boldSize(18), textColor: .c3, numOfLines: 1)
    let professionLabel = UILabel(font: .size(16), textColor: .c6, numOfLines: 1)
    let hospitalLabel = UILabel(font: .size(16), textColor: .c6, numOfLines: 1)
    let servicesView = ServiceView()
    
    var services: [String]! {
        didSet {
            servicesView.services = services
            
            servicesView.snp.updateConstraints { (make) in
                make.size.equalTo(servicesView.zz_size)
            }
        }
    }
    
//    let servicesLabel = UILabel(font: .size(14), textColor: .c6)
    // MARK: - Private Property
    
}

// MARK: - UI
extension BindedDoctorsCell {
    private func setUI() {
        iconView.zz_setCorner(radius: 30, masksToBounds: true)
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(professionLabel)
        contentView.addSubview(hospitalLabel)
        contentView.addSubview(servicesView)
        contentView.addBottomLine()
        
        let arrowView = contentView.zz_add(subview: UIImageView.defaultRightArrow())
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(iconView.snp.right).offset(12)
        }
        
        professionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(12)
            make.right.lessThanOrEqualTo(arrowView.snp.left).offset(-10)
            make.width.equalTo(0)
        }
        
        hospitalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalTo(nameLabel)
            make.right.equalTo(arrowView.snp.left).offset(-10)
        }
        
        servicesView.snp.makeConstraints { (make) in
            make.top.equalTo(hospitalLabel.snp.bottom)
            make.left.equalTo(nameLabel)
            make.size.equalTo(CGSize.zero)
            make.bottom.equalTo(-15)
        }
        
        arrowView.sizeToFit()
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.size.equalTo(arrowView.zz_size)
        }
    }
}

extension BindedDoctorsCell {
    class ServiceView: BaseView {
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        var maxWidth: CGFloat = UIScreen.zz_width - 15 - 60 - 12 - 30
        var services: [String]! {
            didSet {
                zz_removeAllSubviews()
                let font = UIFont.size(14)
                
                var x: CGFloat = 0
                var y: CGFloat = 10
                let padding: CGFloat = 10
                let height: CGFloat = 25
                
                var lastHeight: CGFloat = 0
                for ser in services {
                    let serLabel = UILabel(text: ser, font: font, textColor: .c407cec, textAlignment: .center)
                    serLabel.backgroundColor = .ce5eeff
                    serLabel.zz_setCorner(radius: 12.5, masksToBounds: true)
                    
                    let width = ser.zz_size(withLimitWidth: 200, fontSize: font.pointSize).width + 20
                    if x + width > maxWidth {
                        x = 0
                        y += height + padding
                        if y > 10 + height + padding { // 超过两行的内容不显示
                            break
                        }
                    }
                    
                    serLabel.frame = CGRect(x: x, y: y, width: width, height: height)
                    addSubview(serLabel)
                    
                    x += serLabel.frame.maxX + padding
                    lastHeight = serLabel.frame.maxY
                }
                
                frame = CGRect(x: 0, y: 0, width: maxWidth, height: lastHeight)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
