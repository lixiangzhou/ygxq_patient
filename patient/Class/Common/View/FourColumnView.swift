//
//  FourColumnView.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/3.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class FourColumnView: BaseView {
    // MARK: - Public Properties
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var config: FourColumnViewConfig! {
        didSet {
            guard let config = config else { return }
            
            zz_removeAllSubviews()
            
            let height = config.headerBottomPadding + config.headerTopPadding + config.headerFont.pointSize
            frame = CGRect(x: 0, y: 0, width: config.width, height: height)
            
            setup()
        }
    }
    
    var items: [FourColumnViewModelProtocol]! {
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
                instance.label1.text = item.c1String
                instance.label2.text = item.c2String
                instance.label3.text = item.c3String
                instance.label4.text = item.c4String
                
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
    
    // MARK: - Private Properties
    private let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 48))
    private let rowsView = UIView()
    private var rowInstances = [RowInstance]()
}

// MARK: - UI
extension FourColumnView {
    // MARK: - UI
    func setup() {
        addHeaderView()
        addRowsView()
        addLines()
    }
    
    private func addLines() {
        let line1 = zz_add(subview: UIView())
        line1.backgroundColor = config.lineColor
        
        let line2 = zz_add(subview: UIView())
        line2.backgroundColor = config.lineColor
        
        let line3 = zz_add(subview: UIView())
        line3.backgroundColor = config.lineColor
        
        line1.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(config.lineWidth)
            make.left.equalTo(config.width * config.c1)
        }
        
        line2.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(config.lineWidth)
            make.left.equalTo(config.width * (config.c1 + config.c2))
        }
        
        line3.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(config.lineWidth)
            make.left.equalTo(config.width * (config.c1 + config.c2 + config.c3))
        }
    }
    
    private func addRowsView() {
        addSubview(rowsView)
        rowsView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func addHeaderView() {
        addSubview(headerView)
        headerView.backgroundColor = config.headerBgColor
        let label1 = headerView.zz_add(subview: UILabel(text: config.c1Title, font: config.headerFont, textColor: config.headerTextColor, textAlignment: .center))
        let label2 = headerView.zz_add(subview: UILabel(text: config.c2Title, font: config.headerFont, textColor: config.headerTextColor, textAlignment: .center))
        let label3 = headerView.zz_add(subview: UILabel(text: config.c3Title, font: config.headerFont, textColor: config.headerTextColor, textAlignment: .center))
        let label4 = headerView.zz_add(subview: UILabel(text: config.c4Title, font: config.headerFont, textColor: config.headerTextColor, textAlignment: .center))
        
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        let width = config.width
        let paddingX = config.horizontalPadding
        
        label1.snp.makeConstraints { (make) in
            make.top.equalTo(config.headerTopPadding)
            make.left.equalTo(paddingX)
            make.width.equalTo(width * config.c1 - paddingX * 2)
            make.bottom.lessThanOrEqualTo(-config.headerBottomPadding)
        }
        
        label2.snp.makeConstraints { (make) in
            make.top.equalTo(config.headerTopPadding)
            make.left.equalTo(width * config.c1 + paddingX)
            make.width.equalTo(width * config.c2 - paddingX * 2)
            make.bottom.lessThanOrEqualTo(-config.headerBottomPadding)
        }
        
        label3.snp.makeConstraints { (make) in
            make.top.equalTo(config.headerTopPadding)
            make.left.equalTo(width * (config.c1 + config.c2) + paddingX)
            make.width.equalTo(width * config.c3 - paddingX * 2)
            make.bottom.lessThanOrEqualTo(-config.headerBottomPadding)
        }
        
        label4.snp.makeConstraints { (make) in
            make.top.equalTo(config.headerTopPadding)
            make.left.equalTo(width * (config.c1 + config.c2 + config.c3) + paddingX)
            make.width.equalTo(width * config.c4 - paddingX * 2)
            make.bottom.lessThanOrEqualTo(-config.headerBottomPadding)
        }
    }
    
    
    private func getSingleRow() -> RowInstance {
        let rowView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.zz_width, height: 35))
        
        let label1 = rowView.zz_add(subview: UILabel(font: config.rowFont, textColor: config.rowTextColor, numOfLines: 0, textAlignment: .center)) as! UILabel
        let label2 = rowView.zz_add(subview: UILabel(font: config.rowFont, textColor: config.rowTextColor, numOfLines: 0, textAlignment: .center)) as! UILabel
        let label3 = rowView.zz_add(subview: UILabel(font: config.rowFont, textColor: config.rowTextColor, numOfLines: 0, textAlignment: .center)) as! UILabel
        let label4 = rowView.zz_add(subview: UILabel(font: config.rowFont, textColor: config.rowTextColor, numOfLines: 0, textAlignment: .center)) as! UILabel
        
        let line = rowView.addBottomLine(color: config.lineColor, height: config.lineWidth)
        
        let width = config.width
        let paddingX = config.horizontalPadding
        
        label1.snp.makeConstraints { (make) in
            make.top.equalTo(config.rowTopPadding)
            make.left.equalTo(paddingX)
            make.width.equalTo(width * config.c1 - paddingX * 2)
            make.bottom.lessThanOrEqualTo(-config.rowBottomPadding)
        }
        
        label2.snp.makeConstraints { (make) in
            make.top.equalTo(config.rowTopPadding)
            make.left.equalTo(width * config.c1 + paddingX)
            make.width.equalTo(width * config.c2 - paddingX * 2)
            make.bottom.lessThanOrEqualTo(-config.rowBottomPadding)
        }
        
        label3.snp.makeConstraints { (make) in
            make.top.equalTo(config.rowTopPadding)
            make.left.equalTo(width * (config.c1 + config.c2) + paddingX)
            make.width.equalTo(width * config.c3 - paddingX * 2)
            make.bottom.lessThanOrEqualTo(-config.rowBottomPadding)
        }
        
        label4.snp.makeConstraints { (make) in
            make.top.equalTo(config.rowTopPadding)
            make.left.equalTo(width * (config.c1 + config.c2 + config.c3) + paddingX)
            make.width.equalTo(width * config.c4 - paddingX * 2)
            make.bottom.lessThanOrEqualTo(-config.rowBottomPadding)
        }
        
        return RowInstance(view: rowView,
                           label1: label1,
                           label2: label2,
                           label3: label3,
                           label4: label4,
                           bottomView: line)
    }
}

extension FourColumnView {
    struct RowInstance {
        let view: UIView
        let label1: UILabel
        let label2: UILabel
        let label3: UILabel
        let label4: UILabel
        let bottomView: UIView
    }
}

protocol FourColumnViewModelProtocol {
    var c1String: String { get }
    var c2String: String { get }
    var c3String: String { get }
    var c4String: String { get }
}

struct FourColumnViewConfig {
    /// 宽度
    var width: CGFloat
    
    /// 第1列占总宽度的比例
    var c1: CGFloat
    /// 第2列占总宽度的比例
    var c2: CGFloat
    /// 第3列占总宽度的比例
    var c3: CGFloat
    /// 第4列占总宽度的比例
    var c4: CGFloat
    
    var c1Title: String
    var c2Title: String
    var c3Title: String
    var c4Title: String
    
    var headerBgColor: UIColor
    var headerFont: UIFont
    var headerTextColor: UIColor
    var headerTopPadding: CGFloat
    var headerBottomPadding: CGFloat
    
    var rowBgColor: UIColor
    var rowFont: UIFont
    var rowTextColor: UIColor
    var rowTopPadding: CGFloat
    var rowBottomPadding: CGFloat
    
    var lineColor: UIColor
    var lineWidth: CGFloat
    
    /// 每列内容与边界的最小距离
    var horizontalPadding: CGFloat
    
    init(width: CGFloat = UIScreen.zz_width - 30,
         c1: CGFloat,
         c2: CGFloat,
         c3: CGFloat,
         c4: CGFloat,
         c1Title: String,
         c2Title: String,
         c3Title: String,
         c4Title: String,
         headerBgColor: UIColor = UIColor.cf0efef.withAlphaComponent(0.5),
         headerFont: UIFont = .size(16),
         headerTextColor: UIColor = .c6,
         headerTopPadding: CGFloat = 15,
         headerBottomPadding: CGFloat = 15,
         rowBgColor: UIColor = .cf,
         rowFont: UIFont = .size(14),
         rowTextColor: UIColor = .c3,
         rowTopPadding: CGFloat = 10,
         rowBottomPadding: CGFloat = 10,
         lineColor: UIColor = .cdcdcdc,
         lineWidth: CGFloat = 0.5,
         horizontalPadding: CGFloat = 5) {
        self.width = width
        
        self.c1 = c1
        self.c2 = c2
        self.c3 = c3
        self.c4 = c4
        
        self.c1Title = c1Title
        self.c2Title = c2Title
        self.c3Title = c3Title
        self.c4Title = c4Title
        
        self.headerBgColor = headerBgColor
        self.headerFont = headerFont
        self.headerTextColor = headerTextColor
        self.headerTopPadding = headerTopPadding
        self.headerBottomPadding = headerBottomPadding
        
        self.rowBgColor = rowBgColor
        self.rowFont = rowFont
        self.rowTextColor = rowTextColor
        self.rowTopPadding = rowTopPadding
        self.rowBottomPadding = rowBottomPadding
        
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        
        self.horizontalPadding = horizontalPadding
    }
}
