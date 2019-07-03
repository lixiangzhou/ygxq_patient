//
//  OPInfoView.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/3.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

/// 手术
class OPInfoView: BaseView {
    // MARK: - Public Properties
    var items: [CaseRecordModel.OPAS]! {
        didSet {
            for instance in rowInstances {
                instance.view.isHidden = true
            }
            
            var lastView: UIView!
            for (idx, item) in items.enumerated() {
                var instance: RowInstance!
                if idx < rowInstances.count {
                    instance = rowInstances[idx]
                } else {
                    instance = getSingleRow()
                    rowInstances.append(instance)
                    rowsView.addSubview(instance.view)
                }
                
                instance.view.isHidden = false
                instance.partLabel.text = item.part
                instance.lesionsNatureLabel.text = item.lesionsNature
                instance.stenosisDegreeLabel.text = item.stenosisDegree
                instance.collateralBranchLabel.text = item.collateralBranch
                
                let isLast = (idx == items.count - 1)
                if let lastView = lastView {
                    instance.view.snp.makeConstraints { (maker) in
                        maker.right.left.equalToSuperview()
                        maker.top.equalTo(lastView.snp.bottom)
                        if isLast {
                            maker.bottom.equalToSuperview()
                        }
                    }
                } else {
                    instance.view.snp.makeConstraints { (maker) in
                        maker.top.right.left.equalToSuperview()
                        if isLast {
                            maker.bottom.equalToSuperview()
                        }
                    }
                }
                instance.bottomView.isHidden = isLast
                lastView = instance.view
            }
        }
    }
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 48))
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    private let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 48))
    private let rowsView = UIView()
    private var rowInstances = [RowInstance]()
    
    static let contentWidth = UIScreen.zz_width - 30
    
    var x1: CGFloat = 5
    var x2 = contentWidth * 0.28
    var x3 = contentWidth * 0.6
    var x4 = contentWidth * 0.8
    
    struct RowInstance {
        let view: UIView
        let partLabel: UILabel
        let lesionsNatureLabel: UILabel
        let stenosisDegreeLabel: UILabel
        let collateralBranchLabel: UILabel
        let bottomView: UIView
    }
    
    // MARK: - UI
    private func setUI() {
        addHeaderView()
        addRowsView()
        addLines()
    }
    
    private func addLines() {
        let line1 = zz_add(subview: UIView())
        line1.backgroundColor = .cdcdcdc
        
        let line2 = zz_add(subview: UIView())
        line2.backgroundColor = .cdcdcdc
        
        let line3 = zz_add(subview: UIView())
        line3.backgroundColor = .cdcdcdc
        
        line1.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.width.equalTo(0.5)
            maker.left.equalTo(x2 - 5)
        }
        
        line2.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.width.equalTo(0.5)
            maker.left.equalTo(x3 - 5)
        }
        
        line3.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.width.equalTo(0.5)
            maker.left.equalTo(x4 - 5)
        }
    }
    
    private func addRowsView() {
        addSubview(rowsView)
        rowsView.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerView.snp.bottom)
            maker.left.right.bottom.equalToSuperview()
        }
    }
    
    private func addHeaderView() {
        addSubview(headerView)
        headerView.backgroundColor = UIColor.cf0efef.withAlphaComponent(0.5)
        let partLabel = headerView.zz_add(subview: UILabel(text: "部位", font: .size(15), textColor: .c6, textAlignment: .center))
        let lesionsNatureLabel = headerView.zz_add(subview: UILabel(text: "病变性质", font: .size(15), textColor: .c6, textAlignment: .center))
        let stenosisDegreeLabel = headerView.zz_add(subview: UILabel(text: "狭窄程度", font: .size(15), textColor: .c6, textAlignment: .center))
        let collateralBranchLabel = headerView.zz_add(subview: UILabel(text: "侧支", font: .size(15), textColor: .c6, textAlignment: .center))
        
        headerView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(headerView.zz_height)
        }
        
        partLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(x1)
            maker.width.equalTo(x2 - x1 - 10)
        }
        
        lesionsNatureLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(x2)
            maker.width.equalTo(x3 - x2 - 10)
        }
        
        stenosisDegreeLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(x3)
            maker.width.equalTo(x4 - x3 - 10)
        }
        
        collateralBranchLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(x4)
            maker.right.equalTo(-5)
        }
    }
    
    
    private func getSingleRow() -> RowInstance {
        let rowView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 35))
        
        let partLabel = rowView.zz_add(subview: UILabel(font: .size(15), textColor: .c6, numOfLines: 0, textAlignment: .center)) as! UILabel
        let lesionsNatureLabel = rowView.zz_add(subview: UILabel(font: .size(15), textColor: .c6, numOfLines: 0, textAlignment: .center)) as! UILabel
        let stenosisDegreeLabel = rowView.zz_add(subview: UILabel(font: .size(15), textColor: .c6, numOfLines: 0, textAlignment: .center)) as! UILabel
        let collateralBranchLabel = rowView.zz_add(subview: UILabel(font: .size(15), textColor: .c6, numOfLines: 0, textAlignment: .center)) as! UILabel
        
        let line = rowView.zz_add(subview: UIView())
        line.backgroundColor = .c9
        
        partLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(15)
            maker.left.equalTo(x1)
            maker.width.equalTo(x2 - x1 - 10)
            maker.bottom.lessThanOrEqualTo(-15)
        }
        
        lesionsNatureLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(partLabel)
            maker.left.equalTo(x2)
            maker.width.equalTo(x3 - x2 - 10)
            maker.bottom.lessThanOrEqualTo(-15)
        }
        
        stenosisDegreeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(partLabel)
            maker.left.equalTo(x3)
            maker.width.equalTo(x4 - x3 - 10)
            maker.bottom.lessThanOrEqualTo(-15)
        }
        
        collateralBranchLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(partLabel)
            maker.left.equalTo(x4)
            maker.right.equalTo(-5)
            maker.bottom.lessThanOrEqualTo(-15)
        }
        
        line.snp.makeConstraints { (maker) in
            maker.bottom.left.right.equalToSuperview()
            maker.height.equalTo(0.5)
        }
        
        return RowInstance(view: rowView,
                           partLabel: partLabel,
                           lesionsNatureLabel: lesionsNatureLabel,
                           stenosisDegreeLabel: stenosisDegreeLabel,
                           collateralBranchLabel: collateralBranchLabel,
                           bottomView: line)
    }
}
