//
//  JPushManager.swift
//  patient
//
//  Created by lixiangzhou on 2019/9/11.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import UserNotifications

class JPushManager: NSObject {
    static let shared = JPushManager()
    private override init() {}
    
    func setup(with options: [UIApplication.LaunchOptionsKey: Any]?) {
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) |  Int(JPAuthorizationOptions.sound.rawValue) |  Int(JPAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        JPUSHService.setup(withOption: options, appKey: "ded10f24a61f67eb82856767", channel:"Publish Channel" , apsForProduction: true)
    }
}

// MARK: - JPUSHRegisterDelegate
extension JPushManager: JPUSHRegisterDelegate {
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        guard let notification = notification else {
            return
        }
        
        if let trigger = notification.request.trigger, trigger is UNPushNotificationTrigger {
            // 从通知界面直接进入应用
            print(#function, "从通知界面直接进入应用", notification.request.content.userInfo)
        } else {
            // 从通知设置界面进入应用
            print(#function, "从通知设置界面进入应用", notification.request.content.userInfo)
        }
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        print(#function, userInfo)
        
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        print(#function, userInfo)
        
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        guard let type = userInfo["type"] as? String, let linkId = userInfo["linkId"] as? Int else { return }
        
        if PatientManager.shared.isLogin {
            guard let rootVC = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController,
                let nav = rootVC.selectedViewController as? BaseNavigationController else { return }

            switch type {
            case "BindingDoctor_SUC":   // 绑定医生
                let vc = BindedDoctorsController()
                nav.push(vc)
            case "SerConsultVideo_AT":  // 预约时间提醒
                let vc = VideoConsultResultController()
                vc.viewModel.vid = linkId
                nav.push(vc)
            case "order_10min_remind":
                let vc = OrderController()
                nav.push(vc)
            case "picture_finishing":   // 就诊记录
                let vc = HistoryProfileDataController()
                nav.push(vc)
            case "CMN_MSG_T_05_01", "CMN_MSG_T_05_02", "CMN_MSG_T_05_06", "CMN_MSG_T_05_03", "CMN_MSG_T_05_04", "CMN_MSG_T_05_07", "CMN_MSG_T_05_05":   // 任务提醒
                let vc = TaskTipListController()
                nav.push(vc)
            case "SerDrugSunnyBuys_FAL", "SerDrugSunnyBuys_SUC":    // 续药快递提醒
                let vc = SunnyDrugOrderDetailController()
                vc.viewModel.id = linkId
                nav.push(vc)
            case "ECG12":   // 十二导联的推送
                break
            case "SunshineHut_SB":  // 阳光小屋设备已发快递提醒
                break
            default:
                break
            }
        }
        
        
        completionHandler()
    }
    
}

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(#function, error)
    }
}
