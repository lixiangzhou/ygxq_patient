//
//  BaseController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class BaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setBinding()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationStyle(.default)
        if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "default_nav_back"), style: .plain, target: self, action: #selector(backAction))
        }
        
        if !PatientManager.shared.isLogin && couldShowLogin {
            present(BaseNavigationController(rootViewController: LoginController()), animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        print("DEINIT => \(self.classForCoder)")
    }
    
    var couldShowLogin = true
}

// MARK: - UI
extension BaseController {
    @objc func setUI() {
        
    }
    
    @objc func setBinding() {
        
    }
}

// MARK: - Action
extension BaseController {
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Network
extension BaseController {
    
}

// MARK: - Delegate Internal

// MARK: -

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension BaseController {
    
}

// MARK: - Other
extension BaseController {
    enum NavigationStyle {
        case `default`
        case `systemDefault`
        case transparency
        case other(Images)
        
        struct Images {
            var background: UIImage? = nil
            var shadow: UIImage? = nil
        }
    }
}

// MARK: - Public
extension BaseController {
    /// 设置导航栏样式
    func setNavigationStyle(_ style: NavigationStyle) {
        var backgroundImage: UIImage? = nil
        var shadowImage: UIImage? = nil
        switch style {
        case .systemDefault:
            backgroundImage = nil
            shadowImage = nil
        case .default:
            backgroundImage = UIImage.zz_image(withColor: UIColor.c407cec.withAlphaComponent(0.95))
            shadowImage = nil
        case .transparency:
            backgroundImage = UIImage.zz_image(withColor: .clear)
            shadowImage = UIImage()
        case .other(let imgs):
            backgroundImage = imgs.background
            shadowImage = imgs.shadow
        }
        
        navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationController?.navigationBar.shadowImage = shadowImage
    }
}
