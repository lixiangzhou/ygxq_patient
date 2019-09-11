//
//  UploadHistoryCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/4.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class UploadHistoryCell: UITableViewCell {
    
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
    let timeLabel = UILabel(font: .size(15), textColor: .c6)
    var itemViews = [UIImageView]()
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension UploadHistoryCell {
    private func setUI() {
        backgroundColor = .cf
        
        let topView = contentView.zz_add(subview: UIView())
        topView.addSubview(timeLabel)
        topView.addBottomLine()
        
        let picsView = contentView.zz_add(subview: UIView())
        
        let count = 4
        let padding: CGFloat = 10
        let edgePadding: CGFloat = 15
        let wh: CGFloat = (UIScreen.zz_width - edgePadding * 2 - CGFloat(count - 1) * padding) / CGFloat(count)
        var x = edgePadding
        let y = padding
        for idx in 0..<count {
            x = edgePadding + (padding + wh) * CGFloat(idx)
            let itemView = UIImageView(frame: CGRect(x: x, y: y, width: wh, height: wh))
            itemView.backgroundColor = .cf0efef
            picsView.addSubview(itemView)
            itemViews.append(itemView)
        }
        
        let bottomView = contentView.zz_add(subview: UIView())
        bottomView.backgroundColor = .cf0efef
        
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
        }
        
        picsView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(padding * 2 + wh)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(picsView.snp.bottom)
            make.height.equalTo(10)
            make.bottom.left.right.equalToSuperview()
        }
    }
}
