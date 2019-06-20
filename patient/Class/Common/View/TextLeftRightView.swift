//
//  TextLeftRightView.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/20.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class TextLeftRightView: UIView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    convenience init(_ config: TextLeftRightViewConfig = TextLeftRightViewConfig()) {
        self.init()
        self.config = config
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    var config: TextLeftRightViewConfig? {
        didSet {
            if config == oldValue {
                return
            }
            
            guard let config = config else {
                return
            }
            
            leftLabel.font = config.leftFont
            leftLabel.textColor = config.leftTextColor
            
            rightLabel.font = config.rightFont
            rightLabel.textColor = config.rightTextColor
            
            leftLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(config.leftPadding)
                make.centerY.equalToSuperview()
            }
            
            rightLabel.snp.remakeConstraints { (make) in
                make.right.equalTo(-config.rightPadding)
                make.centerY.equalToSuperview()
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
    
    // MARK: -
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    let bottomLine = UIView()
}

// MARK: - UI
extension TextLeftRightView {
    private func setUI() {
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(bottomLine)
        
        config = TextLeftRightViewConfig()
    }
}

struct TextLeftRightViewConfig {
    /// 左边的View距离左边的距离
    var leftPadding: CGFloat
    /// 右边的View距离右边的距离
    var rightPadding: CGFloat
    
    /// 文本字体
    var leftFont: UIFont
    /// 文本字体颜色
    var leftTextColor: UIColor
    
    /// 文本字体
    var rightFont: UIFont
    /// 文本字体颜色
    var rightTextColor: UIColor
    
    var hasBottomLine = true
    var bottomLineColor: UIColor?
    var bottomLineLeftPadding: CGFloat
    var bottomLineRightPadding: CGFloat
    var bottomLineHeight: CGFloat
    
    init(leftPadding: CGFloat = 15,
         rightPadding: CGFloat = 15,
         leftFont: UIFont = UIFont.size(16),
         leftTextColor: UIColor = UIColor.c3,
         rightFont: UIFont = UIFont.size(15),
         rightTextColor: UIColor = UIColor.c3,
         hasBottomLine: Bool = true,
         bottomLineColor: UIColor = UIColor.cdcdcdc,
         bottomLineLeftPadding: CGFloat = 0,
         bottomLineRightPadding: CGFloat = 0,
         bottomLineHeight: CGFloat = 0.5) {
        
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        
        self.leftFont = leftFont
        self.leftTextColor = leftTextColor
        
        self.rightFont = rightFont
        self.rightTextColor = rightTextColor
        
        self.hasBottomLine = hasBottomLine
        self.bottomLineLeftPadding = bottomLineLeftPadding
        self.bottomLineColor = bottomLineColor
        self.bottomLineRightPadding = bottomLineRightPadding
        self.bottomLineHeight = bottomLineHeight
    }
}

extension TextLeftRightViewConfig: Equatable {
}
