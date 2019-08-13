//
//  ViewExtension.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/29.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

extension UIView {
    static func sepLine(color: UIColor = .cdcdcdc) -> UIView {
        let sep = UIView()
        sep.backgroundColor = color
        return sep
    }
    
    @discardableResult
    func addBottomLine(color: UIColor = .cdcdcdc, left: CGFloat = 0, right: CGFloat = 0, height: CGFloat = 0.5) -> UIView {
        let line = UIView()
        line.backgroundColor = color
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(left)
            make.right.equalTo(-right)
            make.height.equalTo(height)
            make.bottom.equalToSuperview()
        }
        return line
    }
}

extension InputFieldView {
    func addShadowView(_ imgName: String) {
        let bg = UIImageView(image: UIImage(named: imgName))
        bg.contentMode = .scaleToFill
        backgroundColor = .clear
        
        insertSubview(bg, at: 0)
        bg.snp.makeConstraints { (make) in
            make.top.equalTo(-3)
            make.left.equalTo(-5)
            make.right.equalTo(5)
            make.bottom.equalTo(6.5)
        }
    }
}

class BaseShowView: BaseView {}

extension BaseShowView {
    @objc func show() {
        frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(self)
        
        alpha = 0
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        }) { (_) in
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    @objc func hide() {
        alpha = 1
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}



protocol LayoutHeightProtocol {
    func layoutHeight()
}

extension UIView: LayoutHeightProtocol {
    func layoutHeight() {
        layoutIfNeeded()
        var height: CGFloat = 0
        for view in subviews {
            if view.zz_maxY > height {
                height = view.zz_maxY
            }
        }
        zz_height = height
    }
}
