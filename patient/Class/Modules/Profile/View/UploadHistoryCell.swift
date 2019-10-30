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
    let timeLabel = UILabel(font: .size(16), textColor: .c6)
    var itemViews = [UIImageView]()
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension UploadHistoryCell {
    private func setUI() {
        backgroundColor = .cf
        
        let topView = contentView.zz_add(subview: UIView())
        topView.backgroundColor = .cf0efef
        topView.addSubview(timeLabel)
        topView.addBottomLine()
        
        let picsView = contentView.zz_add(subview: UIView())
        let moreBtn = topView.zz_add(subview: ZZImagePositionButton(title: "查看更多", font: .size(16), titleColor: .c6, imageName: "upload_history_arrow", hilightedImageName: "upload_history_arrow", imgPosition: .right, middlePadding: 6))
        moreBtn.isUserInteractionEnabled = false
        
        let count = 3
        let padding: CGFloat = 8
        let edgePadding: CGFloat = 15
        let wh: CGFloat = (UIScreen.zz_width - edgePadding * 2 - CGFloat(count - 1) * padding) / CGFloat(count)
        var x = edgePadding
        let y: CGFloat = 12
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
        
        moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.width.equalTo(78)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        picsView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(24 + wh)
        }
    }
}
