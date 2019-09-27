//
//  HomeHelpTipView.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/25.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class HomeHelpTipView: BaseView {
    
    // MARK: - Life Cycle
    
    // MARK: - Public Property
    
    // MARK: - Private Property
    weak var scanView: UIView!
    weak var caseView: UIView!
    weak var doctorsView: UIView!
    weak var planView: UIView!
    
    private let key = "help_tip_key"
    func show(with scanView: UIView, caseView: UIView, doctorsView: UIView, planView: UIView) {
        if PatientManager.shared.isLogin {
            if !UserDefaults.standard.bool(forKey: key) {
                UserDefaults.standard.set(true, forKey: key)
                
                self.scanView = scanView
                self.caseView = caseView
                self.doctorsView = doctorsView
                self.planView = planView
                show()
            }
        }
    }
    
    func show() {
        DispatchQueue.main.zz_after(1) {
            UIApplication.shared.keyWindow?.addSubview(self)
            self.frame = UIScreen.main.bounds
            let bgView = UIImageView(image: UIApplication.shared.keyWindow!.zz_snapshotImage())
            bgView.isUserInteractionEnabled = true
            self.addSubview(bgView)
            self.addTip1()
        }
    }

    func addTip1() {
        let point = convert(scanView.center, to: UIApplication.shared.keyWindow!)
        let r: CGFloat = 30
        addTip({
            let r0: CGFloat = 32
            // 白圈
            let path0 = UIBezierPath(ovalIn: CGRect(x: point.x - r0, y: point.y - r0, width: r0 * 2, height: r0 * 2))
            path0.addClip()
            UIColor.white.setFill()
            UIRectFill(frame)
            
            // 透明圆
            let path = UIBezierPath(ovalIn: CGRect(x: point.x - r, y: point.y - r, width: r * 2, height: r * 2))
            path.addClip()
            UIColor.clear.setFill()
            UIRectFill(frame)

        }, tipImg: "home_help1_tip", tipBtnFrameClosure: { (btn) in
            btn.frame.origin.x = point.x + r
            btn.frame.origin.y = point.y + r
        }) { [weak self] in
            guard let self = self else { return }
            self.addTip2()
        }
    }
    
    func addTip2() {
        let rect = doctorsView.convert(doctorsView.bounds, to: UIApplication.shared.keyWindow!)
        addTip({
            let path = UIBezierPath(roundedRect: CGRect(x: rect.minX - 5, y: rect.minY - 6, width: rect.width + 10, height: rect.height + 12), cornerRadius: 5)
            path.addClip()
            UIColor.clear.setFill()
            UIRectFill(frame)
        }, tipImg: "home_help2_tip", tipBtnFrameClosure: { (btn) in
            btn.frame.origin.x = rect.midX - 40
            btn.frame.origin.y = rect.maxY - 20
        }) { [weak self] in
            guard let self = self else { return }
            self.addTip3()
        }
    }
    
    func addTip3() {
        let rect = planView.convert(planView.bounds, to: UIApplication.shared.keyWindow!)
        addTip({
            let path = UIBezierPath(roundedRect: CGRect(x: rect.minX - 5, y: rect.minY - 6, width: rect.width + 10, height: rect.height + 12), cornerRadius: 5)
            path.addClip()
            UIColor.clear.setFill()
            UIRectFill(frame)
        }, tipImg: "home_help3_tip", tipBtnFrameClosure: { (btn) in
            btn.frame.origin.x = rect.minX - btn.frame.width * 0.5
            btn.frame.origin.y = rect.maxY + 15
        }) { [weak self] in
            guard let self = self else { return }
            self.addTip4()
        }
    }
    
    func addTip4() {
        let rect = caseView.convert(caseView.bounds, to: UIApplication.shared.keyWindow!)
        addTip({
            let path = UIBezierPath(roundedRect: CGRect(x: rect.minX - 5, y: rect.minY - 6, width: rect.width + 10, height: rect.height + 12), cornerRadius: 5)
            path.addClip()
            UIColor.clear.setFill()
            UIRectFill(frame)
        }, tipImg: "home_help4_tip", tipBtnFrameClosure: { (btn) in
            btn.frame.origin.x = rect.midX - btn.frame.width * 0.5
            btn.frame.origin.y = rect.maxY + 15
        }) { [weak self] in
            guard let self = self else { return }
            self.removeFromSuperview()
        }
    }
    
    @discardableResult
    func addTip(_ closure: () -> Void, tipImg: String, tipBtnFrameClosure: (UIButton) -> Void, nextClosure: @escaping () -> Void) -> UIView {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        UIColor(white: 0, alpha: 0.6).setFill()
        UIRectFill(frame)
        
        closure()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let tip = UIImageView(image: result)
        tip.isUserInteractionEnabled = true
        
        addSubview(tip)
        
        let btn = UIButton(backgroundImageName: tipImg, hilightedBackgroundImageName: tipImg)
        btn.sizeToFit()
        tipBtnFrameClosure(btn)
        tip.addSubview(btn)
        
        btn.reactive.controlEvents(.touchUpInside).observeValues { (_) in
            tip.removeFromSuperview()
            nextClosure()
        }
        
        return tip
    }
}
