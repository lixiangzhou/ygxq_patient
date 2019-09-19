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
