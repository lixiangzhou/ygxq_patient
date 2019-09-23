//
//  DoctorDetailMsgExpendableCell.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/23.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class DoctorDetailMsgExpendableCell: UITableViewCell {
    
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
    let titleLabel = UILabel(font: .boldSize(15), textColor: .c3)
    let txtLabel = YYLabel()
    
    var expendAction: ((Bool) -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension DoctorDetailMsgExpendableCell {
    private func setUI() {
        contentView.backgroundColor = .cf0efef
        
        let bgView = contentView.zz_add(subview: UIView())
        bgView.zz_setCorner(radius: 5, masksToBounds: true)
        bgView.backgroundColor = .cf
        
        txtLabel.font = .size(14)
        txtLabel.textColor = .c3
        txtLabel.numberOfLines = 0
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(txtLabel)
        
        addMore()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(15)
        }
        
        txtLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(15)
            make.width.equalTo(UIScreen.zz_width - 60)
            make.height.equalTo(17)
            make.bottom.equalTo(-10)
        }
    }
}

extension DoctorDetailMsgExpendableCell {
    func updateConstraint(expend: Bool) {
        let upString = "  收起"
        let attr = txtLabel.attributedText!.mutableCopy() as! NSMutableAttributedString
        
        txtLabel.sizeToFit()
        var height = txtLabel.zz_height
        
        if expend { // 展开
            let upAttr = NSMutableAttributedString(string: upString, attributes: [NSAttributedString.Key.font: UIFont.size(14), NSAttributedString.Key.foregroundColor: UIColor.c407cec])
            let hi = YYTextHighlight()
            upAttr.yy_setTextHighlight(hi, range: upAttr.string.zz_ns.range(of: upString))
            
            hi.tapAction = { [weak self] view, txt, range, rect in
                self?.expendAction?(false)
                self?.updateConstraint(expend: false)
            }
            
            attr.append(upAttr)
            
            txtLabel.attributedText = attr
            
            txtLabel.sizeToFit()
            height = txtLabel.zz_height
        } else { // 收起
            let range = attr.string.zz_ns.range(of: upString, options: .backwards)
            if range.location != NSNotFound {
                attr.deleteCharacters(in: range)
            }
            height = min((UIFont.size(14).pointSize + 3.2) * 5, height)
            txtLabel.attributedText = attr
        }

        txtLabel.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    
    
    func addMore() {
        let moreTxt = NSMutableAttributedString(string: "...展开")
        
        let hi = YYTextHighlight()
        hi.tapAction = { [weak self] view, txt, range, rect in
            self?.expendAction?(true)
            self?.updateConstraint(expend: true)
        }
        
        moreTxt.yy_setColor(.c407cec, range: moreTxt.string.zz_ns.range(of: "展开"))
        moreTxt.yy_setTextHighlight(hi, range: moreTxt.string.zz_ns.range(of: "展开"))
        moreTxt.yy_font = UIFont.size(14)
        
        let seeMore = YYLabel()
        seeMore.attributedText = moreTxt
        seeMore.sizeToFit()
        
        txtLabel.truncationToken = NSAttributedString.yy_attachmentString(withContent: seeMore, contentMode: .center, attachmentSize: seeMore.zz_size, alignTo: moreTxt.yy_font!, alignment: .center)
    }
}
