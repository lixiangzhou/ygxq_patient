//
//  ActionCollecter.swift
//  sphr-doctor-iOS
//
//  Created by Macbook Pro on 2019/4/4.
//  Copyright © 2019 qingsong. All rights reserved.
//

import Foundation
import HandyJSON
import CoreTelephony
import KeychainSwift
import Alamofire
import CoreTelephony

class ActionCollecter {
    static let shared = ActionCollecter()
    
    var baseParams: [String : Any]!
    
    private init() { }
    
    let UUIDIdentifier = "2dd88370e17949b59bcb6dac46562204"
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    func setup() {
        setBasicParams()
        checkAppFirstInstall()
        launchAction()
        hookControllerLifeCycle()
//        hookEvents()
    }
    
    private func hookControllerLifeCycle() {
        let appearClosure: @convention(block) (AspectInfo)-> Void = { aspectInfo in
//            print("\((aspectInfo.instance()! as! UIViewController).zz_className) viewDidAppear")
            self.sendData(lev1: "1", lev2: "0", page: (aspectInfo.instance()! as! UIViewController).zz_className, method: "viewDidAppear")
        }
        _ = try? UIViewController.aspect_hook(#selector(UIViewController.viewDidAppear(_:)), with: .positionBefore, usingBlock: appearClosure)
        
        let disAppearClosure: @convention(block) (AspectInfo)-> Void = { aspectInfo in
//            print("\(String(describing: aspectInfo.instance()!)) viewDidDisappear")
            self.sendData(lev1: "2", lev2: "0", page: (aspectInfo.instance()! as! UIViewController).zz_className, method: "viewDidDisappear")
        }
        _ = try? UIViewController.aspect_hook(#selector(UIViewController.viewDidDisappear(_:)), with: .positionBefore, usingBlock: disAppearClosure)
    }
    
//    private func hookEvents() {
////        let fliePath:String = Bundle.main.path(forResource: "ActionCollecter.plist", ofType: nil)!
////        let itemArray = NSArray(contentsOfFile: fliePath)!
//        let jsonPath = Bundle.main.url(forResource: "ActionCollecter.json", withExtension: nil)!
//        let itemArray = try! JSONSerialization.jsonObject(with: Data(contentsOf: jsonPath), options: .allowFragments) as! [Any]
//
//        for item in itemArray {
//            guard let data = ActionData.deserialize(from: item as? [String: Any]) else    {
//                continue
//            }
//
//            let closure: @convention(block) (AspectInfo)-> Void = { aspectInfo in
//                Logger.log(data.pageName + " -> " + data.eventName)
//
//                self.sendData(lev1: data.level_1_id,
//                              lev2: data.level_2_id,
//                              page: data.pageName,
//                              method: data.eventName)
//            }
//            _ = try? data.clazz?.aspect_hook(data.selector, with: .positionBefore, usingBlock: closure)
//        }
//    }
    
    private func checkAppFirstInstall() {
        let keychain = KeychainSwift()
        let uuid = keychain.get(UUIDIdentifier)
        if uuid == nil {   //首次装机，需要上传装机事件
            let user_UUID = UIDevice.current.identifierForVendor?.uuidString ?? ""
            keychain.set(user_UUID, forKey: UUIDIdentifier)
            
            sendData(lev1: "6", lev2: "0", page: "AppDelegate", method: "didFinishLaunchingWithOptions")
        }
    }
    
    private func launchAction() {
        sendData(lev1: "4", lev2: "0", page: "AppDelegate", method: "didFinishLaunchingWithOptions")
    }
    
    /// 发送埋点数据
    func sendData(lev1: String, lev2: String, page: String = #file, method: String = #function) {
        var params = self.baseParams!
        params["networkType"] = getNetworkType()
        params["uid"] = patientId
        
        if (page as NSString).lastPathComponent.hasSuffix(".swift") {
            let last = (page as NSString).lastPathComponent
            params["pageClassName"] = last.zz_ns.substring(to: last.count - 6)
        } else {
            params["pageClassName"] = page
        }
        
        params["methodName"] = method
        params["createTime"] = Int(Date().timeIntervalSince1970) * 1000
        if lev2 == "0" {
            params["eventId"] = lev1
        } else {
            params["fEventId"] = lev1
            params["eventId"] = lev2
        }
        
        print(lev1 + "@" + lev2)
        
        CommonApi.upAction(params: params).rac_response(String.self).startWithValues { (_) in
        }
    }
    
    static func sendData(lev: String, page: String = #file, method: String = #function) {
        ActionCollecter.shared.sendData(lev1: "3", lev2: lev)
    }
    
    private func setBasicParams() {
        baseParams = [
        "mobileBrand": "iPhone",
        "mobileModel": "未知",
        "mobileSystem": UIDevice.current.systemName,
        "platform": "app",
        "appVersion": appVersion,
        "mobileOperator": iphoneCarrier,
        "channel": "AppStore",
        "address": "北京",
        "dpi": dpi,
        "mobileSystemVersion": UIDevice.current.systemVersion,
        "appKey": UUIDIdentifier] as [String : Any]
    }
    
    private func getNetworkType() -> String {
        guard let mgr = NetworkReachabilityManager() else {
            return "unknown"
        }
        
        if mgr.isReachableOnWWAN {
            if let accessString = CTTelephonyNetworkInfo().currentRadioAccessTechnology {
                switch accessString {
                case CTRadioAccessTechnologyLTE:
                    return "4G"
                case CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSUPA, CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyeHRPD:
                    return "3G"
                case CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyCDMA1x:
                    return "2G"
                default:
                    return "unknown"
                }
            } else {
                return "unknown"
            }
        } else if mgr.isReachableOnEthernetOrWiFi {
            return "WIFI"
        } else {
            return "unknown"
        }
    }
}

// MARK: - 辅助属性
extension ActionCollecter {
    fileprivate var appVersion: String {
        let infoDictionary = Bundle.main.infoDictionary!
        let majorVersion = infoDictionary["CFBundleShortVersionString"]//主程序版本号
        let appVersion = majorVersion as! String
        return appVersion
    }
    
    fileprivate var iphoneCarrier: String {
        let info = CTTelephonyNetworkInfo()
        if let carrier = info.subscriberCellularProvider {
            if (carrier.carrierName != nil) {
                return carrier.carrierName!
            }
        }
        return "暂无运营商"
    }
    
    fileprivate var dpi: String {
        let screenBounds:CGRect = UIScreen.main.bounds
        return "\(screenBounds.width)*\(screenBounds.height)"
    }
}

extension ActionCollecter {
}


let nameSpace: String = {
    guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
        return ""
    }
    
    return nameSpace.replacingOccurrences(of: "-", with: "_")
}()

private class ActionData: HandyJSON {
    var eventName = ""
    var level_1_id = ""
    var level_2_id = ""
    var pageName = ""
    
    required init() {
    }
    
    var clazz: AnyClass? {
        return NSClassFromString(nameSpace + "." + pageName)
    }
    var selector: Selector {
        return NSSelectorFromString(eventName)
    }
}
