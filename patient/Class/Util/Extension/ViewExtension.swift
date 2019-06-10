//
//  ViewExtension.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/29.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

extension UIView {
    static func sepLine(color: UIColor = .c6) -> UIView {
        let sep = UIView()
        sep.backgroundColor = color
        return sep
    }
}

class BaseShowView: BaseView {}

extension BaseShowView {
    func show() {
        frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(self)
        
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    @objc func hide() {
        alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
