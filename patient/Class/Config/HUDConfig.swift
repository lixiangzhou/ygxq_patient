//
//  HUDConfig.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/31.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

struct HUD {
    static func show(toast: String, in view: UIView = UIApplication.shared.keyWindow!) {
        ZZHud.show(message: toast,
                   font: UIFont.systemFont(ofSize: 12),
                   color: UIColor.white,
                   backgroundColor: UIColor(white: 0.2, alpha: 0.8),
                   cornerRadius: 5,
                   showDuration: 1,
                   toView: view)
    }
    
    static func showLoding(toView: UIView = UIApplication.shared.keyWindow!) {
        let loadingBgView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.startAnimating()
        
        loadingBgView.addSubview(activityView)
        activityView.center = loadingBgView.center
        
        ZZHud.show(loading: loadingBgView,
                   loadingId: NSNotFound,
                   toView: toView,
                   hudCornerRadius: 5,
                   hudBackgroundColor: UIColor(white: 0.2, alpha: 0.8),
                   hudAlpha: 1,
                   contentInset: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                   position: .center,
                   offsetY: 0,
                   animation: nil)
    }
    
    static func hideLoding(forView: UIView) {
        ZZHud.hideLoading(for: forView)
    }
    
    static func showError(_ result: BoolString, in view: UIView = UIApplication.shared.keyWindow!) {
        if !result.isSuccess && !result.toast.isEmpty {
            show(toast: result.toast, in: view)
        }
    }
    
    static func showSuccess(_ result: BoolString, in view: UIView = UIApplication.shared.keyWindow!) {
        if result.isSuccess && !result.toast.isEmpty {
            show(toast: result.toast, in: view)
        }
    }
    
    static func show(_ result: BoolString, in view: UIView = UIApplication.shared.keyWindow!) {
        if result.isSuccess {
            showSuccess(result)
        } else {
            showError(result)
        }
    }
}
