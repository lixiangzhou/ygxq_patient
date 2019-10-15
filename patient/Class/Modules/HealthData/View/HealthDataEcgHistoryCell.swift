//
//  HealthDataEcgHistoryCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HealthDataEcgHistoryCell: UITableViewCell {
    
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
    let nameLabel = UILabel(font: .size(15), textColor: .c3)
    let stateLabel = UILabel(font: .size(15), textColor: .c407cec)
    let timeLabel = UILabel(font: .size(15), textColor: .c6)
    
    var model: HealthDataECGModel! {
        didSet {
            nameLabel.text = model.name
            
            stateLabel.textColor = .c407cec
            switch model.emergency {
            case "1":
                stateLabel.text = "普通"
            case "2":
                stateLabel.text = "急"
            case "3":
                stateLabel.text = "紧急"
            case "4":
                stateLabel.text = "无法评估"
                stateLabel.textColor = .c9
            default:
                stateLabel.text = "--"
                stateLabel.textColor = .c9
            }
            
            stateLabel.snp.updateConstraints { (make) in
                make.width.equalTo(stateLabel.text!.zz_size(withLimitWidth: 200, fontSize: stateLabel.font.pointSize).width)
            }
            
            timeLabel.text = model.createTime.toTime(format: "HH:mm:ss")
            
            timeLabel.snp.updateConstraints { (make) in
                make.width.equalTo(timeLabel.text!.zz_size(withLimitWidth: 200, fontSize: timeLabel.font.pointSize).width)
            }
        }
    }
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension HealthDataEcgHistoryCell {
    private func setUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(stateLabel)
        contentView.addSubview(timeLabel)
        
        let arrowView = contentView.zz_add(subview: UIImageView.defaultRightArrow())
        
        contentView.addBottomLine()
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        stateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(10)
            make.right.lessThanOrEqualTo(timeLabel.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.right.equalTo(arrowView.snp.left).offset(-10)
        }
        
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
            make.size.equalTo(arrowView.zz_size)
        }
    }
}
