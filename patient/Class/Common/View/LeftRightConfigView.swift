//
//  LeftRightConfigView.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/5.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class LeftRightConfigView: BaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Public Property
    var config: LeftRightConfigViewConfig? {
        didSet {            
            guard let config = config else {
                return
            }
            /// Effect
            switch config.effectStyle {
            case .none:
                backgroundColor = config.contentViewBackgroundColor
                effectView.removeFromSuperview()
            default:
                backgroundColor = .clear
                
                switch config.effectStyle {
                case .extraLight:
                    effectView.effect = UIBlurEffect(style: .extraLight)
                case .light:
                    effectView.effect = UIBlurEffect(style: .light)
                case .dark:
                    effectView.effect = UIBlurEffect(style: .dark)
                case .regular:
                    effectView.effect = UIBlurEffect(style: .regular)
                case .prominent:
                    effectView.effect = UIBlurEffect(style: .prominent)
                default:
                    break
                }
                
                insertSubview(effectView, at: 0)
                effectView.snp.makeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
            
            // LeftView
            if let lv = config.leftView {
                leftView.isHidden = false
                leftView.zz_removeAllSubviews()
                
                leftView.addSubview(lv)
                
                leftView.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(config.leftPaddingLeft)
                    make.right.equalTo(leftLabel.snp.left).offset(-config.leftPaddingRight)
                }
                
                if let size = config.leftViewSize {
                    lv.snp.makeConstraints { (make) in
                        make.size.equalTo(size)
                        make.edges.equalToSuperview()
                    }
                } else {
                    lv.sizeToFit()
                    lv.snp.makeConstraints { (make) in
                        make.size.equalTo(lv.zz_size)
                        make.edges.equalToSuperview()
                    }
                }
                
            } else {
                leftView.isHidden = true
                leftView.zz_removeAllSubviews()
                
                leftView.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.left.equalTo(config.leftPaddingLeft)
                    make.width.equalTo(0)
                    make.right.equalTo(leftLabel.snp.left).offset(-config.leftPaddingRight)
                }
            }
            
            // Title
            leftLabel.font = config.leftFont
            leftLabel.textColor = config.leftTextColor
            leftLabel.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
            }
            
            // RightView
            if let rv = config.rightView {
                rightView.isHidden = false
                rightView.zz_removeAllSubviews()
                
                rightView.addSubview(rv)
                
                rightView.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.right.equalTo(-config.rightPadding)
                }
                
                if let size = config.rightViewSize {
                    rv.snp.makeConstraints { (make) in
                        make.size.equalTo(size)
                        make.edges.equalToSuperview()
                    }
                } else {
                    rv.sizeToFit()
                    rv.snp.makeConstraints { (make) in
                        make.edges.equalToSuperview()
                    }
                }
                
                rightLabel.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.right.equalTo(rightView.snp.left).offset(-config.rightPaddingLeft)
                }
                
            } else {
                rightView.isHidden = true
                
                rightLabel.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.right.equalTo(-(config.rightPaddingLeft + config.rightPadding))
                }
            }
            
            rightLabel.font = config.rightFont
            rightLabel.textColor = config.rightTextColor
            
            // BottomLine
            bottomLine.isHidden = !config.hasBottomLine
            bottomLine.backgroundColor = config.bottomLineColor
            bottomLine.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.height.equalTo(config.bottomLineHeight)
                make.left.equalTo(config.bottomLineLeftPadding)
                make.right.equalTo(-config.bottomLineRightPadding)
            }
        }
    }
    
    
    
    let leftView = UIView()
    let leftLabel = UILabel()
    let rightView = UIView()
    let rightLabel = UILabel()
    let bottomLine = UIView()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
}

// MARK: - UI
extension LeftRightConfigView {
    private func setUI() {
        addSubview(leftView)
        addSubview(leftLabel)
        addSubview(rightView)
        addSubview(rightLabel)
        addSubview(bottomLine)
        
        config = LeftRightConfigViewConfig()
    }
}

struct LeftRightConfigViewConfig {
    /// 背景透明样式
    var effectStyle: EffectStyle = .none
    
    /// 背景色在 effectStyle == .none 才有效
    var cellBackgroundColor: UIColor
    var contentViewBackgroundColor: UIColor
    
    /// 左边的View
    var leftView: UIView?
    /// 左边的View大小，如果为nil，则是leftView的系统自动设置的大小
    var leftViewSize: CGSize?
    /// 左边的View距离左边的距离
    var leftPaddingLeft: CGFloat
    /// 左边的View文本的距离
    var leftPaddingRight: CGFloat
    
    /// 文本字体
    var leftFont: UIFont
    /// 文本字体颜色
    var leftTextColor: UIColor
    
    /// 右边的View
    var rightView: UIView?
    /// 右边的View大小，如果为nil，则是rightView的系统自动设置的大小
    var rightViewSize: CGSize?
    /// 右边的View距离右边的距离
    var rightPadding: CGFloat
    
    /// 右边文本字体
    var rightFont: UIFont
    /// 右边文本字体颜色
    var rightTextColor: UIColor
    /// 右边文本距离右边View的距离
    var rightPaddingLeft: CGFloat
    
    var hasBottomLine = true
    var bottomLineColor: UIColor?
    var bottomLineLeftPadding: CGFloat
    var bottomLineRightPadding: CGFloat
    var bottomLineHeight: CGFloat
    
    init(effectStyle: EffectStyle = .none,
         cellBackgroundColor: UIColor = .white,
         contentViewBackgroundColor: UIColor = .white,
         leftView: UIView? = nil,
         leftViewSize: CGSize? = nil,
         leftPaddingLeft: CGFloat = 15,
         leftPaddingRight: CGFloat = 10,
         leftFont: UIFont = UIFont.size(17),
         leftTextColor: UIColor = UIColor.c3,
         rightView: UIView? = UIImageView.defaultRightArrow(),
         rightViewSize: CGSize? = nil,
         rightPadding: CGFloat = 15,
         rightFont: UIFont = UIFont.size(16),
         rightTextColor: UIColor = .c3,
         rightPaddingLeft: CGFloat = 10,
         hasBottomLine: Bool = true,
         bottomLineColor: UIColor = UIColor.cdcdcdc,
         bottomLineLeftPadding: CGFloat = 0,
         bottomLineRightPadding: CGFloat = 0,
         bottomLineHeight: CGFloat = 0.5) {
        self.effectStyle = effectStyle
        
        self.cellBackgroundColor = cellBackgroundColor
        self.contentViewBackgroundColor = contentViewBackgroundColor
        
        self.leftView = leftView
        self.leftViewSize = leftViewSize
        self.leftPaddingLeft = leftPaddingLeft
        self.leftPaddingRight = leftPaddingRight
        
        self.leftFont = leftFont
        self.leftTextColor = leftTextColor
        
        self.rightView = rightView
        self.rightViewSize = rightViewSize
        self.rightPadding = rightPadding
        
        self.rightFont = rightFont
        self.rightTextColor = rightTextColor
        self.rightPaddingLeft = rightPaddingLeft
        
        self.hasBottomLine = hasBottomLine
        self.bottomLineLeftPadding = bottomLineLeftPadding
        self.bottomLineColor = bottomLineColor
        self.bottomLineRightPadding = bottomLineRightPadding
        self.bottomLineHeight = bottomLineHeight
    }
}

extension LeftRightConfigViewConfig: Equatable {
    
    static func == (lhs: LeftRightConfigViewConfig, rhs: LeftRightConfigViewConfig) -> Bool {
        return lhs.effectStyle == rhs.effectStyle &&
            lhs.cellBackgroundColor.rgbaValue == rhs.cellBackgroundColor.rgbaValue &&
            lhs.contentViewBackgroundColor.rgbaValue == rhs.contentViewBackgroundColor.rgbaValue &&
            lhs.leftView == rhs.leftView &&
            lhs.leftViewSize == rhs.leftViewSize &&
            lhs.leftPaddingLeft == rhs.leftPaddingLeft &&
            lhs.leftPaddingRight == rhs.leftPaddingRight &&
            lhs.leftFont.pointSize == rhs.leftFont.pointSize &&
            lhs.leftTextColor.rgbaValue == rhs.leftTextColor.rgbaValue &&
            lhs.rightView == rhs.rightView &&
            lhs.rightViewSize == rhs.rightViewSize &&
            lhs.rightPadding == rhs.rightPadding &&
            lhs.rightFont.pointSize == rhs.rightFont.pointSize &&
            lhs.rightTextColor.rgbaValue == rhs.rightTextColor.rgbaValue &&
            rhs.rightPaddingLeft == rhs.rightPaddingLeft &&
            lhs.hasBottomLine == rhs.hasBottomLine &&
            lhs.bottomLineColor?.rgbaValue == rhs.bottomLineColor?.rgbaValue &&
            lhs.bottomLineLeftPadding == rhs.bottomLineLeftPadding &&
            lhs.bottomLineRightPadding == rhs.bottomLineRightPadding &&
            lhs.bottomLineHeight == rhs.bottomLineHeight
    }
}

extension LeftRightConfigViewConfig {
    mutating func hasBottomLine(_ prop: Bool) -> LeftRightConfigViewConfig {
        self.hasBottomLine = prop
        return self
    }
}

extension LeftRightConfigViewConfig {
    enum EffectStyle {
        case extraLight
        case light
        case dark
        case none
        
        @available(iOS 10.0, *)
        case regular
        
        @available(iOS 10.0, *)
        case prominent
    }
}
