//
//  MainTabBarController.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class MainTabBarController: BaseTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildControllers()
    }
    
    private func addChildControllers() {
        add(HomeController(), title: "首页")
        add(MineController(), title: "我的")
    }

    private func add(_ controller: BaseController, title: String) {
        controller.title = title
        let nav = BaseNavigationController(rootViewController: controller)
        addChild(nav)
    }
}
