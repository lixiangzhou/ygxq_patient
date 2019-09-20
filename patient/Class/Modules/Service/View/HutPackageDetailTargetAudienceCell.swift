//
//  HutPackageDetailTargetAudienceCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/18.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HutPackageDetailTargetAudienceCell: UITableViewCell {
    
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
    var models: [HutPackageDetailViewModel.TargetAudienceModel]? {
        didSet {
            for v in itemsView.subviews {
                v.removeFromSuperview()
            }
            
            guard let models = models else {
                itemsView.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                }
                return
            }
            
            
            let itemHeight: CGFloat = 105
            let itemWidth: CGFloat = 80
            let maxWidth = UIScreen.zz_width - 60
            var lastY: CGFloat = 0
            let paddingX = (maxWidth - itemWidth * 3) / 2
            for (idx, m) in models.enumerated() {
                let col = CGFloat(idx % 3)
                let row = CGFloat(idx / 3)
                
                let itemX: CGFloat = col * (paddingX + itemWidth)
                let itemY: CGFloat = row * (15 + itemHeight)
                
                let view = ImageTitleView(frame: CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight))
                view.config = .init(imageInTop: true, imageSize: CGSize(width: 80, height: 80), verticalHeight1: 0, verticalHeight2: 12, titleLeft: 0, titleRight: 0, titleFont: .size(15), titleColor: .c3)
                view.imgView.kf.setImage(with: URL(string: m.pic))
                view.titleLabel.text = m.title
                view.imgView.backgroundColor = .orange
                itemsView.addSubview(view)
                lastY = view.frame.maxY
            }
            
            itemsView.snp.updateConstraints { (make) in
                make.height.equalTo(lastY)
            }
        }
    }
    // MARK: - Private Property
    let itemsView = UIView()
}

// MARK: - UI
extension HutPackageDetailTargetAudienceCell {
    private func setUI() {
        backgroundColor = .cf0efef
        
        let whiteView = contentView.zz_add(subview: UIView())
        whiteView.zz_setCorner(radius: 6, masksToBounds: true)
        whiteView.backgroundColor = .cf
        
        let titleLabel = whiteView.zz_add(subview: UILabel(text: "受众人群", font: .boldSize(17), textColor: .c3))
        whiteView.addSubview(itemsView)
        
        whiteView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.bottom.equalTo(-12)
            make.right.equalTo(-15)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        itemsView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(0)
            make.bottom.equalTo(-15)
        }
    }
}

// MARK: - Action
extension HutPackageDetailTargetAudienceCell {
    
}

// MARK: - Helper
extension HutPackageDetailTargetAudienceCell {
    
}

// MARK: - Other
extension HutPackageDetailTargetAudienceCell {
    
}

// MARK: - Public
extension HutPackageDetailTargetAudienceCell {
    
}
