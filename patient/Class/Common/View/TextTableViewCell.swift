//
//  TextTableViewCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import SnapKit

class TextTableViewCell: UITableViewCell, IDCell {
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        separatorInset = .zero
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Props
    var config: TextTableViewCellConfig? {
        didSet {
            if config == oldValue {
                return
            }
            
            guard let config = config else {
                return
            }
            /// Effect
            switch config.effectStyle {
            case .none:
                backgroundColor = config.cellBackgroundColor
                contentView.backgroundColor = config.contentViewBackgroundColor
                effectView.removeFromSuperview()
            default:
                backgroundColor = .clear
                contentView.backgroundColor = .clear
                
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
                
                contentView.insertSubview(effectView, at: 0)
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
                    make.right.equalTo(titleLabel.snp.left).offset(-config.leftPaddingRight)
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
                    make.right.equalTo(titleLabel.snp.left).offset(0)
                }
            }
            
            // Title
            titleLabel.font = config.font
            titleLabel.textColor = config.textColor
            titleLabel.snp.remakeConstraints { (make) in
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
                
            } else {
                rightView.isHidden = true
            }
            
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
    
    // MARK: -
    static let cellHeight: CGFloat = 44
    
    let leftView = UIView()
    let titleLabel = UILabel()
    let rightView = UIView()
    let bottomLine = UIView()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
}

// MARK: - UI
extension TextTableViewCell {
    fileprivate func setUI() {
        contentView.addSubview(leftView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightView)
        contentView.addSubview(bottomLine)
        
        config = TextTableViewCellConfig()
    }
}


extension TextTableViewCell {
    var leftIconView: UIImageView? {
        return config?.leftView as? UIImageView
    }
}

struct TextTableViewCellConfig {
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
    var font: UIFont
    /// 文本字体颜色
    var textColor: UIColor
    
    /// 右边的View
    var rightView: UIView?
    /// 右边的View大小，如果为nil，则是rightView的系统自动设置的大小
    var rightViewSize: CGSize?
    /// 右边的View距离右边的距离
    var rightPadding: CGFloat
    
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
         font: UIFont = UIFont.size(17),
         textColor: UIColor = UIColor.c3,
         rightView: UIView? = UIImageView(image: UIImage(named: "common_arrow_right")),
         rightViewSize: CGSize? = nil,
         rightPadding: CGFloat = 15,
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
        
        self.font = font
        self.textColor = textColor
        
        self.rightView = rightView
        self.rightViewSize = rightViewSize
        self.rightPadding = rightPadding
        
        self.hasBottomLine = hasBottomLine
        self.bottomLineLeftPadding = bottomLineLeftPadding
        self.bottomLineColor = bottomLineColor
        self.bottomLineRightPadding = bottomLineRightPadding
        self.bottomLineHeight = bottomLineHeight
    }
}

extension TextTableViewCellConfig: Equatable {
    
    static func == (lhs: TextTableViewCellConfig, rhs: TextTableViewCellConfig) -> Bool {
        return lhs.effectStyle == rhs.effectStyle &&
            lhs.cellBackgroundColor.rgbaValue == rhs.cellBackgroundColor.rgbaValue &&
            lhs.contentViewBackgroundColor.rgbaValue == rhs.contentViewBackgroundColor.rgbaValue &&
            lhs.leftView == rhs.leftView &&
            lhs.leftViewSize == rhs.leftViewSize &&
            lhs.leftPaddingLeft == rhs.leftPaddingLeft &&
            lhs.leftPaddingRight == rhs.leftPaddingRight &&
            lhs.font.pointSize == rhs.font.pointSize &&
            lhs.textColor.rgbaValue == rhs.textColor.rgbaValue &&
            lhs.rightView == rhs.rightView &&
            lhs.rightViewSize == rhs.rightViewSize &&
            lhs.rightPadding == rhs.rightPadding &&
            lhs.hasBottomLine == rhs.hasBottomLine &&
            lhs.bottomLineColor?.rgbaValue == rhs.bottomLineColor?.rgbaValue &&
            lhs.bottomLineLeftPadding == rhs.bottomLineLeftPadding &&
            lhs.bottomLineRightPadding == rhs.bottomLineRightPadding &&
            lhs.bottomLineHeight == rhs.bottomLineHeight
    }
}

extension TextTableViewCellConfig {
    mutating func hasBottomLine(_ prop: Bool) -> TextTableViewCellConfig {
        self.hasBottomLine = prop
        return self
    }
}

extension TextTableViewCellConfig {
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
