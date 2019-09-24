//
//  TextLeftRightFieldView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/5.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class TextLeftRightFieldView: UIView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Property
    var config: TextLeftRightFieldViewConfig? {
        didSet {
            if config == oldValue {
                return
            }
            
            guard let config = config else {
                return
            }
            
            leftLabel.font = config.leftFont
            leftLabel.textColor = config.leftTextColor
            
            rightField.font = config.rightFont
            rightField.textColor = config.rightTextColor
            
            leftLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(config.leftPadding)
                make.centerY.equalToSuperview()
            }
            
            rightField.snp.remakeConstraints { (make) in
                make.right.equalTo(-config.rightPadding)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(config.rightWidth)
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
    let rightField = UITextField()
    let bottomLine = UIView()
    
    var inputLimitClosure: ((String) -> Bool)?
}

// MARK: - UI
extension TextLeftRightFieldView {
    private func setUI() {
        addSubview(leftLabel)
        addSubview(rightField)
        addSubview(bottomLine)
        rightField.delegate = self
        
        config = TextLeftRightFieldViewConfig()
    }
}

extension TextLeftRightFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let config = config else { return true }
        
        if string.isEmpty {
            return true
        } else {
            if config.rightLimit == 0 {
                return true
            } else {
                let text = textField.text ?? ""
                var validate = true
                if let closure = inputLimitClosure {
                    validate = closure(string)
                }
                return validate && (text + string).count <= config.rightLimit
            }
        }
    }
}

struct TextLeftRightFieldViewConfig {
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
    /// field宽度
    var rightWidth: CGFloat
    /// field 输入长度限制，0表示无限制
    var rightLimit: Int
    
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
         rightWidth: CGFloat = 150,
         rightLimit: Int = 0,
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
        self.rightWidth = rightWidth
        self.rightLimit = rightLimit
        
        self.hasBottomLine = hasBottomLine
        self.bottomLineLeftPadding = bottomLineLeftPadding
        self.bottomLineColor = bottomLineColor
        self.bottomLineRightPadding = bottomLineRightPadding
        self.bottomLineHeight = bottomLineHeight
    }
}

extension TextLeftRightFieldViewConfig: Equatable {
    static func == (lhs: TextLeftRightFieldViewConfig, rhs: TextLeftRightFieldViewConfig) -> Bool {
        return lhs.leftPadding == rhs.leftPadding &&
            lhs.rightPadding == rhs.rightPadding &&
            lhs.leftFont.pointSize == rhs.leftFont.pointSize &&
            lhs.leftTextColor.rgbaValue == rhs.leftTextColor.rgbaValue &&
            lhs.rightFont.pointSize == rhs.rightFont.pointSize &&
            lhs.rightTextColor.rgbaValue == rhs.rightTextColor.rgbaValue &&
            lhs.rightWidth == rhs.rightWidth &&
            lhs.hasBottomLine == rhs.hasBottomLine &&
            lhs.bottomLineColor?.rgbaValue == rhs.bottomLineColor?.rgbaValue &&
            lhs.bottomLineLeftPadding == rhs.bottomLineLeftPadding &&
            lhs.bottomLineRightPadding == rhs.bottomLineRightPadding &&
            lhs.bottomLineHeight == rhs.bottomLineHeight
    }
}
