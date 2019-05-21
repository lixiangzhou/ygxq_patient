//
//  UIDevice+ZZExtension.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/3/21.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

public let zz_device = UIDevice.current

/// 具体参照： https://www.theiphonewiki.com/wiki/Models
fileprivate let zz_deviceVersion: (identifier: String, version: ZZDeviceVersion) = {
    
    var systemInfo = utsname()
    uname(&systemInfo)
    let identifier = String(validatingUTF8: NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: String.Encoding.ascii.rawValue)!.utf8String!) ?? "unknown"
    
    switch identifier {
    /*** iPhone ***/
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":         return (identifier: identifier, version: ZZDeviceVersion.iPhone_4)
    case "iPhone4,1", "iPhone4,2", "iPhone4,3":         return (identifier: identifier, version: ZZDeviceVersion.iPhone_4S)
    case "iPhone5,1", "iPhone5,2":                      return (identifier: identifier, version: ZZDeviceVersion.iPhone_5)
    case "iPhone5,3", "iPhone5,4":                      return (identifier: identifier, version: ZZDeviceVersion.iPhone_5C)
    case "iPhone6,1", "iPhone6,2":                      return (identifier: identifier, version: ZZDeviceVersion.iPhone_5S)
    case "iPhone7,2":                                   return (identifier: identifier, version: ZZDeviceVersion.iPhone_6)
    case "iPhone7,1":                                   return (identifier: identifier, version: ZZDeviceVersion.iPhone_6_Plus)
    case "iPhone8,1":                                   return (identifier: identifier, version: ZZDeviceVersion.iPhone_6S)
    case "iPhone8,2":                                   return (identifier: identifier, version: ZZDeviceVersion.iPhone_6S_Plus)
    case "iPhone8,4":                                   return (identifier: identifier, version: ZZDeviceVersion.iPhone_SE)
    case "iPhone9,1", "iPhone9,3":                      return (identifier: identifier, version: ZZDeviceVersion.iPhone_7)
    case "iPhone9,2", "iPhone9,4":                      return (identifier: identifier, version: ZZDeviceVersion.iPhone_7_Plus)
    case "iPhone10,1", "iPhone10,4":                    return (identifier: identifier, version: ZZDeviceVersion.iPhone_8)
    case "iPhone10,2", "iPhone10,5":                    return (identifier: identifier, version: ZZDeviceVersion.iPhone_8_Plus)
    case "iPhone10,3", "iPhone10,6":                    return (identifier: identifier, version: ZZDeviceVersion.iPhone_X)
        
    /*** iPad ***/
    case "iPad1,1":                                     return (identifier: identifier, version: ZZDeviceVersion.iPad)
    case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":    return (identifier: identifier, version: ZZDeviceVersion.iPad_2)
    case "iPad3,1", "iPad3,2", "iPad3,3":               return (identifier: identifier, version: ZZDeviceVersion.iPad_3)
    case "iPad3,4", "iPad3,5", "iPad3,6":               return (identifier: identifier, version: ZZDeviceVersion.iPad_4)
    case "iPad6,11", "iPad6,12":                        return (identifier: identifier, version: ZZDeviceVersion.iPad_5)
    case "iPad4,1", "iPad4,2", "iPad4,3":               return (identifier: identifier, version: ZZDeviceVersion.iPad_Air)
    case "iPad5,3", "iPad5,4":                          return (identifier: identifier, version: ZZDeviceVersion.iPad_Air_2)
    case "iPad2,5", "iPad2,6", "iPad2,7":               return (identifier: identifier, version: ZZDeviceVersion.iPad_Mini)
    case "iPad4,4", "iPad4,5", "iPad4,6":               return (identifier: identifier, version: ZZDeviceVersion.iPad_Mini_2)
    case "iPad4,7", "iPad4,8", "iPad4,9":               return (identifier: identifier, version: ZZDeviceVersion.iPad_Mini_3)
    case "iPad5,1", "iPad5,2":                          return (identifier: identifier, version: ZZDeviceVersion.iPad_Mini_4)
    case "iPad6,7", "iPad6,8":                          return (identifier: identifier, version: ZZDeviceVersion.iPad_Pro_12_9)
    case "iPad7,1", "iPad7,2":                          return (identifier: identifier, version: ZZDeviceVersion.iPad_Pro_2_12_9)
    case "iPad6,3", "iPad6,4":                          return (identifier: identifier, version: ZZDeviceVersion.iPad_Pro_9_7)
    case "iPad7,3", "iPad7,4":                          return (identifier: identifier, version: ZZDeviceVersion.iPad_Pro_10_5)
    case "iPad7,5", "iPad7,6":                          return (identifier: identifier, version: ZZDeviceVersion.iPad_6)
        
    /*** iPod ***/
    case "iPod1,1":                                     return (identifier: identifier, version: ZZDeviceVersion.iPodTouch_1)
    case "iPod2,1":                                     return (identifier: identifier, version: ZZDeviceVersion.iPodTouch_2)
    case "iPod3,1":                                     return (identifier: identifier, version: ZZDeviceVersion.iPodTouch_3)
    case "iPod4,1":                                     return (identifier: identifier, version: ZZDeviceVersion.iPodTouch_4)
    case "iPod5,1":                                     return (identifier: identifier, version: ZZDeviceVersion.iPodTouch_5)
    case "iPod7,1":                                     return (identifier: identifier, version: ZZDeviceVersion.iPodTouch_6)
        
    /*** Simulator ***/
    case "i386", "x86_64":                              return (identifier: identifier, version: ZZDeviceVersion.simulator)
        
    default:                                            return (identifier: identifier, version: ZZDeviceVersion.unknown)
    }
}()

public enum ZZDeviceType: String {
    case iPhone
    case iPad
    case iPod
    case simulator
    case unknown
}

public enum ZZDeviceVersion: String {
    /*** iPhone ***/
    case iPhone_4 = "iPhone 4"
    case iPhone_4S = "iPhone 4S"
    case iPhone_5 = "iPhone 5"
    case iPhone_5C = "iPhone 5C"
    case iPhone_5S = "iPhone 5S"
    case iPhone_6 = "iPhone 6"
    case iPhone_6_Plus = "iPhone 6 Plus"
    case iPhone_6S = "iPhone 6S"
    case iPhone_6S_Plus = "iPhone 6S Plus"
    case iPhone_SE = "iPhone SE"
    case iPhone_7 = "iPhone 7"
    case iPhone_7_Plus = "iPhone 7 Plus"
    case iPhone_8 = "iPhone 8"
    case iPhone_8_Plus = "iPhone 8 Plus"
    case iPhone_X = "iPhone X"
    
    /*** iPad ***/
    case iPad_Mini = "iPad mini"
    case iPad_Mini_2 = "iPad mini 2"
    case iPad_Mini_3 = "iPad mini 3"
    case iPad_Mini_4 = "iPad mini 4"
    case iPad = "iPad"
    case iPad_2 = "iPad 2"
    case iPad_3 = "iPad 3"
    case iPad_4 = "iPad 4"
    case iPad_5 = "iPad 5"
    case iPad_6 = "iPad 6"
    case iPad_Air = "iPad Air"
    case iPad_Air_2 = "iPad Air 2"
    case iPad_Pro_12_9 = "iPad Pro (12.9-inch)"
    case iPad_Pro_2_12_9 = "iPad Pro 2 (12.9-inch)"
    case iPad_Pro_9_7 = "iPad Pro (9.7-inch)"
    case iPad_Pro_10_5 = "iPad Pro (10.5-inch)"
    
    
    /*** iPod ***/
    case iPodTouch_1 = "iPod touch 1"
    case iPodTouch_2 = "iPod touch 2"
    case iPodTouch_3 = "iPod touch 3"
    case iPodTouch_4 = "iPod touch 4"
    case iPodTouch_5 = "iPod touch 5"
    case iPodTouch_6 = "iPod touch 6"
    
    /*** Simulator ***/
    case simulator = "iPhone Simulator"
    
    /*** Unknown ***/
    case unknown
}

public extension UIDevice {
    
    /// 是否iPad
    var zz_isPad: Bool {
        return zz_type == .iPad
    }
    
    /// 是否iPhone
    var zz_isPhone: Bool {
        return zz_type == .iPhone
    }
    
    /// 是否iPod
    var zz_isPod: Bool {
        return zz_type == .iPod
    }
    
    /// 是否Simulator
    var zz_isSimulator: Bool {
        return zz_type == .simulator
    }
    
    /// 设备类型
    var zz_type: ZZDeviceType {
        let identifier = zz_deviceVersion.identifier
        if identifier.contains("iPhone") {
            return .iPhone
        } else if identifier.contains("iPad") {
            return .iPad
        } else if identifier.contains("iPod") {
            return .iPod
        } else if identifier == "i386" || identifier == "x86_64" {
            return .simulator
        } else {
            return .unknown
        }
    }
    
    /// 设备版本
    var zz_version: ZZDeviceVersion {
        return zz_deviceVersion.version
    }
    
    /// 设备 identifier
    var zz_identifier: String {
        return zz_deviceVersion.identifier
    }
    
    /// 是否可打电话
    var zz_canMakePhoneCall: Bool {
        return zz_application.canOpenURL(URL(string: "tel://")!)
    }
    
    /// 设备 uuid
    var zz_uuidString: String? {
        return zz_device.identifierForVendor?.uuidString
    }
    
    /// 获取磁盘大小(字节)，获取失败返回-1
    var zz_systemSize: Double {
        guard let attr = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) else {
            return -1
        }
        
        guard let space = attr[FileAttributeKey.systemSize] as? Double else {
            return -1
        }
        
        return space
    }
    
    /// 获取磁盘可用大小(字节)，获取失败返回-1
    var zz_systemFreeSize: Double {
        guard let attr = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()) else {
            return -1
        }
        
        guard let space = attr[FileAttributeKey.systemFreeSize] as? Double else {
            return -1
        }
        
        return space
    }
}
