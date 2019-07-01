//
//  UploadResourceCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/1.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class UploadResourceCell: UITableViewCell, IDView {
    
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
    var itemViews = [ItemView]()
    
    // MARK: - Private Property
    
}

// MARK: - UI
extension UploadResourceCell {
    private func setUI() {
        let count = 4
        let padding: CGFloat = 10
        let edgePadding: CGFloat = 15
        let wh: CGFloat = (UIScreen.zz_width - edgePadding * 2 - CGFloat(count - 1) * padding) / CGFloat(count)
        var x = edgePadding
        let y: CGFloat = edgePadding
        for idx in 0..<count {
            x = edgePadding + (padding + wh) * CGFloat(idx)
            let itemView = ItemView(frame: CGRect(x: x, y: y, width: wh, height: wh))
            contentView.addSubview(itemView)
            itemViews.append(itemView)
        }
    }
}

// MARK: - Action
extension UploadResourceCell {
    
}

// MARK: - Helper
extension UploadResourceCell {

    class ItemView: UIView {
        // MARK: - LifeCycle
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .yellow
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
            delView.backgroundColor = .orange
            delView.isUserInteractionEnabled = true
            delView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(delAction)))
            
            addSubview(imgView)
            addSubview(delView)
            
            imgView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            delView.snp.makeConstraints { (make) in
                make.top.right.equalToSuperview()
                make.width.height.equalTo(15)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Public Properties
        let imgView = UIImageView()
        let delView = UIImageView()
        
        var tapClosure: ((ItemView) -> Void)?
        var delClosure: ((ItemView) -> Void)?
        
        @objc private func tapAction(_ tap: UITapGestureRecognizer) {
            tapClosure?(self)
        }
        
        @objc private func delAction(_ tap: UITapGestureRecognizer) {
            delClosure?(self)
        }
    }
}

