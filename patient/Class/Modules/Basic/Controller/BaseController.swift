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

        view.backgroundColor = .cf0efef
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationStyle(.default)
        setBackImage("common_nav_back")
        
        if !PatientManager.shared.isLogin && couldShowLogin {
            present(BaseNavigationController(rootViewController: LoginController()))
        }
        
        if hideNavigation {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let backClassName = backClassName, var vcs = navigationController?.children, let idx = vcs.firstIndex(where: { $0.zz_className == backClassName }) {
            if idx + 1 <= vcs.count - 2 {
                vcs.removeSubrange((idx + 1)...(vcs.count - 2))
                navigationController?.setValue(vcs, forKey: "viewControllers")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if hideNavigation {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    deinit {
        print("DEINIT => \(self.classForCoder)")
    }
    
    var couldShowLogin = true
    var hideNavigation = false
    
    var backClassName: String?
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
        setNavigation(navigationController, style: style)
    }
    
    func setNavigation(_ navigationController: UINavigationController?, style: NavigationStyle) {
        var backgroundImage: UIImage? = nil
        var shadowImage: UIImage? = nil
        switch style {
        case .systemDefault:
            backgroundImage = nil
            shadowImage = nil
        case .default:
            backgroundImage = UIImage.zz_image(withColor: UIColor.c407cec)
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
            // 空 title 是为了增加可点击范围
            let btn = UIButton(imageName: imgName, target: self, action: #selector(backAction))
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 15)
            btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
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

extension BaseController {
    
    @discardableResult
    func addNavigationItem(position: NavItemPosition, title: String, imgName: String, action: Selector) -> ImageTitleView {
        let config = ImageTitleView.Config(imageSize: CGSize(width: 25, height: 25), verticalHeight1: 0, verticalHeight2: 5, titleLeft: 0, titleRight: 0, titleFont: .size(14), titleColor: .cf)
        
        let item = ImageTitleView()
        item.imgView.contentMode = .center
        item.config = config
        item.titleLabel.text = title
        item.imgView.image = UIImage(named: imgName)
        view.addSubview(item)
        
        item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
        
        item.snp.makeConstraints { (make) in
            make.top.equalTo(35 + UIScreen.zz_statusBar_additionHeight)
            make.width.equalTo(50)
            make.height.equalTo(50)
            switch position {
            case .left: make.left.equalTo(10)
            case .right: make.right.equalTo(-10)
            }
        }
        return item
    }
    
    @discardableResult
    func setRightBarItem(title: String, action: Selector) -> UIButton {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, target: self, action: action)
        return navigationItem.rightBarButtonItem!.customView as! UIButton
    }
}

extension BaseController {
    enum NavItemPosition {
        case left, right
    }
}
