//
//  FUVisitPlanCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/6.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class FUVisitPlanCell: UITableViewCell {
    
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
    
    var model: FUVisitModel! {
        didSet {
            for v in rowViews {
                v.isHidden = true
                v.removeFromSuperview()
            }
            
            timeLabel.text = model!.flpTime.toTime(format: "yyyy-MM-dd")
            statusLabel.text = model.fsCHN + ((model.fsfCHN == "正常") ? "" : "-\(model.fsfCHN)")
            
            var views = [LeftRightConfigView]()
            if model.flupStatus == "FLU_S_NEW" {
                statusLabel.textColor = .gray
            } else if model.flupStatus == "FLU_S_FIN" {
                statusLabel.textColor = .blue
                views.append(contentsOf: getRowType([.lookFlpExams, .materials]))
            } else if model.flupStatus == "FLU_S_ING" {
                statusLabel.textColor = .red
                views.append(contentsOf: getRowType([.lookFlpExams, .materials]))
            } else if model.flupStatus == "FLU_S_FAL" {
                statusLabel.textColor = .gray
            }
            
            var lastView: LeftRightConfigView!
            for (idx, view) in views.enumerated() {
                let isLast = (idx == views.count - 1)
                if let lastView = lastView {
                    view.snp.remakeConstraints { (maker) in
                        maker.right.left.equalToSuperview()
                        maker.height.equalTo(40)
                        maker.top.equalTo(lastView.snp.bottom)
                        if isLast {
                            maker.bottom.equalToSuperview()
                        }
                    }
                } else {
                    view.snp.remakeConstraints { (maker) in
                        maker.top.right.left.equalToSuperview()
                        maker.height.equalTo(40)
                        if isLast {
                            maker.bottom.equalToSuperview()
                        }
                    }
                }
                lastView = view
            }
        }
    }
    
    let timeLabel = UILabel(font: .size(16), textColor: .c6)
    let statusLabel = UILabel(font: .size(13), textColor: .c6)
    let containerView = UIView()
    
    var rowClosure: ((RowType) -> Void)?

    // MARK: - Private Property
    private var rowViews = [LeftRightConfigView]()
}

// MARK: - UI
extension FUVisitPlanCell {
    private func setUI() {
        backgroundColor = .cf
        
        let header = contentView.zz_add(subview: UIView())
        header.addSubview(timeLabel)
        header.addSubview(statusLabel)
        header.addBottomLine()
        contentView.addSubview(containerView)
        
        let sepView = contentView.zz_add(subview: UIView())
        sepView.backgroundColor = .cf0efef
        
        header.snp.makeConstraints { (maker) in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(50)
        }
        
        containerView.snp.makeConstraints { (maker) in
            maker.top.equalTo(header.snp.bottom)
            maker.left.right.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15)
            maker.centerY.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(timeLabel.snp.right).offset(5)
            maker.centerY.equalToSuperview()
        }
        
        sepView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(5)
        }
    }
}

// MARK: - Action
extension FUVisitPlanCell {
    @objc private func tapAction(_ tap: UITapGestureRecognizer) {
        if let view = tap.view as? LeftRightConfigView, let type = RowType(rawValue: view.leftLabel.text!) {
            rowClosure?(type)
        }
    }
}

// MARK: - Helper
extension FUVisitPlanCell {
    func getRowType(_ types: [RowType]) -> [LeftRightConfigView] {
        var views = [LeftRightConfigView]()
        var idx = 0
        for type in types {
            if (type == .lookFlpExams && model.answer && !model.resultId.isEmpty) ||
                (type == .materials && !model.imgs.isEmpty) {
                let view: LeftRightConfigView!
                if idx < rowViews.count {
                    view = rowViews[idx]
                } else {
                    view = LeftRightConfigView()
                    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
                    rowViews.append(view)
                }
                containerView.addSubview(view)
                view.isHidden = false
                view.leftLabel.text = type.rawValue
                views.append(view)
                
                idx += 1
            }
        }
        
        for (idx, v) in views.enumerated() {
            let isLast = idx == views.count - 1
            v.config = LeftRightConfigViewConfig(leftPaddingRight: 0, leftFont: .size(15), rightView: UIImageView.defaultRightArrow(), hasBottomLine: !isLast, bottomLineLeftPadding: 15)
        }
        
        return views
    }
}

// MARK: - Other
extension FUVisitPlanCell {
    enum RowType: String {
        case lookFlpExams = "查看随访问卷"
        case materials = "查看完善资料"
//        case getDocAdvice = "查看医生建议"
//        case fail = "失败原因"
    }
}

// MARK: - Public
extension FUVisitPlanCell {
    
}
