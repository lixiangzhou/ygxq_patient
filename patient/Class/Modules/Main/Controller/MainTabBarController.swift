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
        add(HomeController(), title: "首页", img: "tabbar_home", selImg: "tabbar_home_sel")
        add(SunShineHutListController(), title: "服务", img: "tabbar_service", selImg: "tabbar_service_sel")
        add(MineController(), title: "我的", img: "tabbar_mine", selImg: "tabbar_mine_sel")
    }

    private func add(_ controller: BaseController, title: String, img: String, selImg: String) {
        controller.title = title
        controller.tabBarItem.image = UIImage(named: img)
        controller.tabBarItem.selectedImage = UIImage(named: selImg)
        let nav = BaseNavigationController(rootViewController: controller)
        addChild(nav)
    }
}
