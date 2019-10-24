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
    let titleLabel = UILabel(font: .boldSize(17), textColor: .c3)
    let txtLabel = YYLabel()
    let bgView = UIView()
    var expendAction: ((Bool) -> Void)?
    // MARK: - Private Property
    
}

// MARK: - UI
extension DoctorDetailMsgExpendableCell {
    private func setUI() {
        contentView.backgroundColor = .cf0efef
        
        contentView.addSubview(bgView)
        bgView.zz_setCorner(radius: 5, masksToBounds: true)
        bgView.backgroundColor = .cf
        
        txtLabel.font = .size(16)
        txtLabel.textColor = .c3
        txtLabel.numberOfLines = 0
        txtLabel.frame = CGRect(x: 15, y: 50, width: UIScreen.zz_width - 60, height: 200)
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(txtLabel)
        
        addMore()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(60 + 15)
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(12)
        }
    }
}

extension DoctorDetailMsgExpendableCell {
    func updateConstraint(expend: Bool) {
        let upString = "  收起"
        let attr = txtLabel.attributedText!.mutableCopy() as! NSMutableAttributedString
        
        attr.yy_font = UIFont.size(16)
        attr.yy_color = .c3
        attr.yy_lineSpacing = 5
        
        var height: CGFloat = 0
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        let attrDict = [NSAttributedString.Key.font: UIFont.size(16), NSAttributedString.Key.paragraphStyle: style]
        if expend { // 展开
            let upAttr = NSMutableAttributedString(string: upString)
            let hi = YYTextHighlight()
            
            upAttr.yy_setTextHighlight(hi, range: upAttr.string.zz_ns.range(of: upString))
            upAttr.yy_font = UIFont.size(16)
            upAttr.yy_color = .c407cec
            upAttr.yy_lineSpacing = 5
            
            hi.tapAction = { [weak self] view, txt, range, rect in
                self?.expendAction?(false)
                self?.updateConstraint(expend: false)
            }
            attr.append(upAttr)
            
            txtLabel.attributedText = attr
            height = txtLabel.attributedText!.string.zz_ns.boundingRect(with: CGSize(width: UIScreen.zz_width - 54, height: 100000), options: .usesLineFragmentOrigin, attributes: attrDict, context: nil).height
            txtLabel.frame = CGRect(x: 12, y: 42, width: UIScreen.zz_width - 54, height: height)
        } else { // 收起
            let range = attr.string.zz_ns.range(of: upString, options: .backwards)
            if range.location != NSNotFound {
                attr.deleteCharacters(in: range)
            }
            txtLabel.attributedText = attr
            
            let fiveHeight = "*\n\n\n\n".zz_ns.boundingRect(with: CGSize(width: UIScreen.zz_width - 54, height: 100000), options: .usesLineFragmentOrigin, attributes: attrDict, context: nil).height
            let fullHeight = txtLabel.attributedText!.string.zz_ns.boundingRect(with: CGSize(width: UIScreen.zz_width - 54, height: 100000), options: .usesLineFragmentOrigin, attributes: attrDict, context: nil).height
            height = min(fiveHeight, fullHeight)
            
            txtLabel.frame = CGRect(x: 12, y: 45, width: UIScreen.zz_width - 54, height: height)
        }

        bgView.snp.updateConstraints { (make) in
            make.height.equalTo(60 + height)
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
        moreTxt.yy_font = UIFont.size(16)
        moreTxt.yy_lineSpacing = 5
        
        let seeMore = YYLabel()
        seeMore.attributedText = moreTxt
        seeMore.sizeToFit()
        
        txtLabel.truncationToken = NSAttributedString.yy_attachmentString(withContent: seeMore, contentMode: .center, attachmentSize: seeMore.zz_size, alignTo: moreTxt.yy_font!, alignment: .center)
    }
}
