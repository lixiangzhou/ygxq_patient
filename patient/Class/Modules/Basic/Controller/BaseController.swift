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

        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationStyle(.default)
        setBackImage("common_nav_back")
        
        if !PatientManager.shared.isLogin && couldShowLogin {
            present(BaseNavigationController(rootViewController: LoginController()), animated: true, completion: nil)
        }
        
        if hideNavigation {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if hideNavigation {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    deinit {
        print("DEINIT => \(self.classForCoder)")
    }
    
    var couldShowLogin = true
    var hideNavigation = false
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - Other
extension BaseController {
    enum NavigationStyle {
        case `default`
        case `systemDefault`
        case transparency
        case whiteBg
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
        case .whiteBg:
            backgroundImage = UIImage.zz_image(withColor: .cf)
            shadowImage = UIImage()
        case .other(let imgs):
            backgroundImage = imgs.background
            shadowImage = imgs.shadow
        }
        
        navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationController?.navigationBar.shadowImage = shadowImage
    }
    
    func setBackImage(_ imgName: String) {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIButton(imageName: imgName, target: self, action: #selector(backAction)))
        }
    }
}

extension BaseController {
    func toServicePrototol() {
        guard let serviceURL = NetworkConfig.serviceURL else { return }
        let vc = WebController()
        vc.titleString = appService
        vc.url = serviceURL
        
        let btn = UIButton(title: "下载", font: .size(itemFontSize), titleColor: .cf)
        btn.reactive.controlEvents(.touchUpInside).observeValues { _ in
            UIApplication.shared.open(serviceURL, options: [:], completionHandler: nil)
        }
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        self.push(vc)
    }
}
