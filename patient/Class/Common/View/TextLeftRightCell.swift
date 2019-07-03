//
//  TextLeftRightCell.swift
//  patient
//
//  Created by Macbook Pro on 2019/6/20.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit


class TextLeftRightCell: UITableViewCell {
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
    var config: TextLeftRightViewConfig? {
        didSet {
            innerView.config = config
        }
    }
    
    // MARK: -
    static let cellHeight: CGFloat = 44
    
    var leftLabel: UILabel {
        return innerView.leftLabel
    }
    
    var rightLabel: UILabel {
        return innerView.rightLabel
    }
    
    private let innerView = TextLeftRightView()
}

extension TextLeftRightCell {
    private func setUI() {
        contentView.addSubview(innerView)
        innerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        config = TextLeftRightViewConfig()
    }
}
