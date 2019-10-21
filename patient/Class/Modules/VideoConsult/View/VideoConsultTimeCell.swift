//
//  VideoConsultTimeCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/15.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class VideoConsultTimeCell: UITableViewCell {
    
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
    let titleView = TextLeftRightView()
    
    let statusView = UIImageView(image: UIImage(named: "consult_status_ing"))
    
    let appointTimeLabel = UILabel(text: "等待医生确认", font: .size(16), textColor: .c6)
    let talkTimeLabel = UILabel(font: .size(16), textColor: .c6)
    let statusEndLabel = UILabel(text: "已通话", font: .size(16), textColor: .c9)
    let noTalkLabel = UILabel(text: "未通话", font: .size(16), textColor: .c407cec)
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension VideoConsultTimeCell {
    private func setUI() {
        let topSepView = contentView.zz_add(subview: UIView())
        topSepView.backgroundColor = .cf0efef
        
        titleView.config = TextLeftRightViewConfig(leftFont: .boldSize(17), leftTextColor: .c3)
        contentView.addSubview(titleView)
        
        let bottomView = contentView.zz_add(subview: UIView())
        
        bottomView.addSubview(statusView)
        
        let ingLabel = bottomView.zz_add(subview: UILabel(text: "进行中", font: .size(16), textColor: .c3))
        
        bottomView.addSubview(appointTimeLabel)
        bottomView.addSubview(talkTimeLabel)
        bottomView.addSubview(statusEndLabel)
        bottomView.addSubview(noTalkLabel)
        
        topSepView.snp.makeConstraints { (make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(12)
        }
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(topSepView.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(50)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.right.left.bottom.equalToSuperview()
        }

        statusView.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
            make.size.equalTo(CGSize(width: 22, height: 100))
        }
        
        ingLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusView)
            make.left.equalTo(statusView.snp.right).offset(15)
        }
        
        appointTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ingLabel)
            make.top.equalTo(ingLabel.snp.bottom).offset(10)
        }
        
        statusEndLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ingLabel)
            make.bottom.equalTo(statusView)
        }
        
        talkTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusEndLabel.snp.bottom).offset(10)
            make.left.equalTo(ingLabel)
            make.bottom.equalTo(-10)
        }
        
        noTalkLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(appointTimeLabel)
        }
    }
}

// MARK: - Public
extension VideoConsultTimeCell {
    func setData(status: String, appointTime: TimeInterval, talkTime: TimeInterval) {
        if status == "SER_CST_S_ING" {
            if appointTime == 0 {    // 未预约时间
                statusView.image = UIImage(named: "consult_status_ing")
                appointTimeLabel.text = "等待医生确认"
                statusEndLabel.textColor = .c9
                talkTimeLabel.text = nil
                noTalkLabel.isHidden = true
                
                talkTimeLabel.snp.updateConstraints { (make) in
                    make.top.equalTo(statusEndLabel.snp.bottom).offset(0)
                }
            } else {
                if talkTime == 0 {   // 预约了时间，没有通话过
                    statusView.image = UIImage(named: "consult_status_ing")
                    appointTimeLabel.text = "预约成功 " + appointTime.toTime(format: "yyyy-MM-dd HH:mm")
                    statusEndLabel.textColor = .c9
                    talkTimeLabel.text = nil
                    noTalkLabel.isHidden = false
                    
                    talkTimeLabel.snp.updateConstraints { (make) in
                        make.top.equalTo(statusEndLabel.snp.bottom).offset(0)
                    }
                } else {    // 预约了时间，通话过
                    overStatus(appointTime: appointTime, talkTime: talkTime)
                }
            }
        } else { // 已结束咨询
            overStatus(appointTime: appointTime, talkTime: talkTime)
        }
    }
    
    private func overStatus(appointTime: TimeInterval, talkTime: TimeInterval) {
        statusView.image = UIImage(named: "consult_status_end")
        appointTimeLabel.text = "预约成功 " + appointTime.toTime(format: "yyyy-MM-dd HH:mm")
        statusEndLabel.textColor = .c3
        talkTimeLabel.text = talkTime.toTime(format: "yyyy-MM-dd HH:mm")
        noTalkLabel.isHidden = true
        
        talkTimeLabel.snp.updateConstraints { (make) in
            make.top.equalTo(statusEndLabel.snp.bottom).offset(10)
        }
    }
}
