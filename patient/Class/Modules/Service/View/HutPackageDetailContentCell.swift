//
//  HutPackageDetailContentCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/18.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HutPackageDetailContentCell: UITableViewCell {
    
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
    var contents: [String]? {
        didSet {
            for v in contentListView.subviews {
                v.removeFromSuperview()
            }
            
            guard let contents = contents else {
                contentListView.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
                return
            }
            
            var itemX: CGFloat = 0
            var itemY: CGFloat = 0
            let itemHeight: CGFloat = 30
            let maxWidth = UIScreen.zz_width - 60
            var lastY: CGFloat = 0
            
            for txt in contents {
                let itemWidth = txt.zz_size(withLimitWidth: maxWidth, fontSize: 15).width + 24
                
                if itemX + itemWidth > maxWidth {
                    itemX = 0
                    itemY += itemHeight + 15
                }
                
                let txtLabel = UILabel(text: txt, font: .size(15), textColor: .c407cec, textAlignment: .center)
                txtLabel.backgroundColor = UIColor.ce5eeff
                txtLabel.zz_setCorner(radius: 15, masksToBounds: true)
                txtLabel.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
                itemX = itemX + txtLabel.frame.maxX + 15
                
                contentListView.addSubview(txtLabel)
                lastY = txtLabel.frame.maxY
            }
            
            contentListView.snp.updateConstraints { (make) in
                make.height.equalTo(lastY)
            }
        }
    }
    // MARK: - Private Property
    let contentListView = UIView()
    let detailLabel = UILabel(font: .size(16), textColor: .c3)
    let iconView = UIImageView()
}

// MARK: - UI
extension HutPackageDetailContentCell {
    private func setUI() {
        backgroundColor = .cf0efef
        
        let whiteView = contentView.zz_add(subview: UIView())
        whiteView.zz_setCorner(radius: 6, masksToBounds: true)
        whiteView.backgroundColor = .cf
        
        let contentTitleLabel = whiteView.zz_add(subview: UILabel(text: "服务内容", font: .boldSize(17), textColor: .c3))
        whiteView.addSubview(contentListView)
        
        let detailTitleLabel = whiteView.zz_add(subview: UILabel(text: "服务详情", font: .boldSize(17), textColor: .c3))
        whiteView.addSubview(detailLabel)
        
        iconView.backgroundColor = .red
        whiteView.addSubview(iconView)
        
        whiteView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.bottom.equalTo(-12)
            make.right.equalTo(-15)
        }
        
        contentTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        contentListView.snp.makeConstraints { (make) in
            make.top.equalTo(contentTitleLabel.snp.bottom).offset(15)
            make.left.right.equalTo(contentTitleLabel)
            make.height.equalTo(0)
        }
        
        detailTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentListView.snp.bottom).offset(15)
            make.left.right.equalTo(contentTitleLabel)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(detailTitleLabel.snp.bottom).offset(15)
            make.left.right.equalTo(contentTitleLabel)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(detailLabel.snp.bottom).offset(15)
            make.left.right.equalTo(contentTitleLabel)
            make.height.equalTo(150)
            make.bottom.equalTo(-15)
        }
    }
}
