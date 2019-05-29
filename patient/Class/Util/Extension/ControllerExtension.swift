//
//  ControllerExtension.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/28.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

private var navigationBarEffectViewKey: Void?

extension UIViewController {
    func push(_ controller: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func addNavigationBarEffectView() {
        if let navBgView = navigationController?.navigationBar.subviews.first, let effectView = navigationBarEffectView {
            navBgView.insertSubview(effectView, at: 0)
        }
    }
    
    var navigationBarEffectView: UIVisualEffectView? {
        get {
            var effectView = objc_getAssociatedObject(self, &navigationBarEffectViewKey) as? UIVisualEffectView
            if effectView == nil {
                effectView = getNavigationBarEffectView()
                objc_setAssociatedObject(self, &navigationBarEffectViewKey, effectView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return effectView
        }
    }
    
    private func getNavigationBarEffectView() -> UIVisualEffectView? {
        if let subviews = navigationController?.navigationBar.subviews.first?.subviews {
            for view in subviews {
                if view is UIVisualEffectView {
                    return view as? UIVisualEffectView
                }
            }
        }
        return nil
    }
}
