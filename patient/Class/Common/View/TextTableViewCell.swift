//
//  TextTableViewCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import SnapKit

class TextTableViewCell: UITableViewCell {
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Props
    var config: LeftRightConfigViewConfig? {
        didSet {
            view.config = config
            
            guard let config = config else { return }
            switch config.effectStyle {
            case .none:
                backgroundColor = config.cellBackgroundColor
                contentView.backgroundColor = config.contentViewBackgroundColor
            default:
                backgroundColor = .clear
                contentView.backgroundColor = .clear
            }
        }
    }
    
    // MARK: -
    static let cellHeight: CGFloat = 44
    
    var leftView: UIView {
        return view.leftView
    }
    
    var leftLabel: UILabel {
        return view.leftLabel
    }
    
    var rightView: UIView {
        return view.rightView
    }
    
    var rightLabel: UILabel {
        return view.rightLabel
    }
    var bottomLine: UIView {
        return view.bottomLine
    }
    var effectView: UIVisualEffectView {
        return view.effectView
    }
    
    let view = LeftRightConfigView()
}

// MARK: - UI
extension TextTableViewCell {
    fileprivate func setUI() {
        contentView.addSubview(view)
        
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        config = LeftRightConfigViewConfig()
    }
}


extension TextTableViewCell {
    var leftIconView: UIImageView? {
        return config?.leftView as? UIImageView
    }
}
