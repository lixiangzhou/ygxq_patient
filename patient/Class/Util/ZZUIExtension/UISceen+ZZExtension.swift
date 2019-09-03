//
//  UISceen+ZZExtension.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/3/10.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

public let zz_screen = UIScreen.main

public extension UIScreen {
    /// 屏幕高度
    static var zz_height: CGFloat {
        return zz_screen.bounds.height
    }
    
    /// 屏幕宽度
    static var zz_width: CGFloat {
        return zz_screen.bounds.width
    }
    
    /// 设备的 scale
    static var zz_scale: CGFloat {
        return zz_screen.scale
    }
    
    /// 屏幕亮度
    static var zz_brightness: CGFloat {
        set {
            zz_screen.brightness = newValue
        }
        
        get {
            return zz_screen.brightness
        }
    }
    
    /// 状态栏额外的高度
    static var zz_statusBar_additionHeight: CGFloat {
        return zz_iPhoneX ? 24 : 0
    }
    
    /// 底部额外的高度
    static var zz_tabBar_additionHeight: CGFloat {
        return zz_iPhoneX ? 34 : 0
    }
    
    /// 状态栏高度
    static var zz_nav_statusHeight: CGFloat {
        return zz_iPhoneX ? 44 : 20
    }
    
    /// 导航栏高度
    static var zz_navHeight: CGFloat {
        return zz_iPhoneX ? 88 : 64
    }
    
    /// tabbar 高度
    static var zz_tabBarHeight: CGFloat {
        return zz_iPhoneX ? 83 : 49
    }
    
    /// 是否iPhone X
    static var zz_iPhoneX: Bool {
        return zz_height == 812 || zz_height == 896
    }
    
    /// 导航栏下面视图的frame 
    static var zz_frameUnderNavigation: CGRect {
        return CGRect(x: 0, y: 0, width: zz_width, height: zz_height - zz_navHeight)
    }
    
    /// 导航栏下面视图的安全frame
    static var zz_safeFrameUnderNavigation: CGRect {
        return CGRect(x: 0, y: 0, width: zz_width, height: zz_height - zz_navHeight - zz_tabBar_additionHeight)
    }
}
