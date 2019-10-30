//
//  LeftRightUpDownLabelView.swift
//  patient
//
//  Created by lixiangzhou on 2019/10/30.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class LeftRightUpDownLabelView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    var bottomLine: UIView!
    
    var config: Config! {
        didSet {
            titleLabel.font = config.leftFont
            titleLabel.textColor = config.leftTxtColor
            
            subTitleLabel.font = config.rightFont
            subTitleLabel.textColor = config.rightTxtColor
            subTitleLabel.textAlignment = .right
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(config.topPadding)
                make.left.equalTo(config.leftPadding)
                make.width.equalTo(config.leftWidth)
                make.bottom.lessThanOrEqualTo(-config.bottomPadding)
            }
            
            subTitleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(config.topPadding)
                make.right.equalTo(-config.rightPadding)
                make.bottom.equalTo(-config.bottomPadding)
                make.left.equalTo(titleLabel.snp.right)
            }
            
            bottomLine.isHidden = !config.hasBottomLine
            bottomLine.backgroundColor = config.bottomLineColor
            
            bottomLine.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.left.equalTo(config.bottomLineLeftPadding)
                make.right.equalTo(-config.bottomLineRightPadding)
                make.height.equalTo(config.bottomLineHeight)
            }
        }
    }
    
    var text: String? {
        didSet {
            subTitleLabel.text = text
            let txt = text ?? ""
            let maxWidth = UIScreen.zz_width - config.leftPadding - config.rightPadding - config.leftWidth
            let width = txt.zz_size(withLimitWidth: UIScreen.zz_width, fontSize: config.rightFont.pointSize).width
            
            if width >= maxWidth {
                subTitleLabel.numberOfLines = 0
                subTitleLabel.textAlignment = .left
                subTitleLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(titleLabel.snp.bottom).offset(config.topBottomPadding)
                    make.left.equalTo(titleLabel)
                    make.right.equalTo(-config.rightPadding)
                    make.bottom.equalTo(-config.bottomPadding)
                }
            } else {
                subTitleLabel.numberOfLines = 1
                subTitleLabel.textAlignment = .right
                subTitleLabel.snp.remakeConstraints { (make) in
                    make.top.equalTo(config.bottomPadding)
                    make.right.equalTo(-config.rightPadding)
                    make.bottom.equalTo(-config.bottomPadding)
                    make.left.equalTo(titleLabel.snp.right)
                }
            }
        }
    }
    
}

// MARK: - UI
extension LeftRightUpDownLabelView {
    private func setUI() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        bottomLine = addBottomLine()
    }
}

// MARK: - Helper
extension LeftRightUpDownLabelView {
    struct Config {
        let topPadding: CGFloat
        let bottomPadding: CGFloat
        let leftPadding: CGFloat
        let rightPadding: CGFloat
        let leftWidth: CGFloat
        let topBottomPadding: CGFloat
        
        let leftFont: UIFont
        let leftTxtColor: UIColor
        let rightFont: UIFont
        let rightTxtColor: UIColor
        
        var hasBottomLine = true
        var bottomLineColor: UIColor
        var bottomLineLeftPadding: CGFloat
        var bottomLineRightPadding: CGFloat
        var bottomLineHeight: CGFloat
        
        init(topPadding: CGFloat = 14,
             bottomPadding: CGFloat = 14,
             leftPadding: CGFloat = 15,
             rightPadding: CGFloat = 15,
             leftWidth: CGFloat = 100,
             topBottomPadding: CGFloat = 14,
             leftFont: UIFont = .size(16),
             leftTxtColor: UIColor = .c3,
             rightFont: UIFont = .size(16),
             rightTxtColor: UIColor = .c3,
             hasBottomLine: Bool = true,
             bottomLineColor: UIColor = UIColor.cdcdcdc,
             bottomLineLeftPadding: CGFloat = 0,
             bottomLineRightPadding: CGFloat = 0,
             bottomLineHeight: CGFloat = 0.5) {
            
            self.topPadding = topPadding
            self.bottomPadding = bottomPadding
            self.leftPadding = leftPadding
            self.rightPadding = rightPadding
            self.leftWidth = leftWidth
            self.topBottomPadding = topBottomPadding
            
            self.leftFont = leftFont
            self.leftTxtColor = leftTxtColor
            self.rightFont = rightFont
            self.rightTxtColor = rightTxtColor
            
            self.hasBottomLine = hasBottomLine
            self.bottomLineLeftPadding = bottomLineLeftPadding
            self.bottomLineColor = bottomLineColor
            self.bottomLineRightPadding = bottomLineRightPadding
            self.bottomLineHeight = bottomLineHeight
        }
    }
}
