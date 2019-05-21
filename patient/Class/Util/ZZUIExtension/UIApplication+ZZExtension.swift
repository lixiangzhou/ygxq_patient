//
//  UIApplication+ZZExtension.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/3/21.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

public let zz_application = UIApplication.shared

/// 可以保存文件的目录类型
public enum ZZSavedFileDirectoryType {
    case cachesDirectory, documentDirectory, libraryDirectory, tempDirectory
}

/// 生成获取一个文件的路径
///
/// - parameter directory: 文件目录类型
/// - parameter fileName:  文件名
///
/// - returns: 生成的文件路径
public func zz_filePath(with directory: ZZSavedFileDirectoryType = .cachesDirectory, fileName: String) -> String {
    switch directory {
    case .documentDirectory:
        return zz_application.zz_documentPath + "/\(fileName)"
    case .cachesDirectory:
        return zz_application.zz_cachesPath + "/\(fileName)"
    case .libraryDirectory:
        return zz_application.zz_libraryPath + "/\(fileName)"
    case .tempDirectory:
        return zz_application.zz_tempPath + fileName
    }
}

public extension UIApplication {
    /// .documentDirectory URL
    var zz_documentURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    
    /// .documentDirectory PATH
    var zz_documentPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    /// .cachesDirectory URL
    var zz_cachesURL: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
    }
    
    /// .cachesDirectory PATH
    var zz_cachesPath: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    
    /// .libraryDirectory URL
    var zz_libraryURL: URL {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last!
    }
    
    /// .libraryDirectory PATH
    var zz_libraryPath: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    }
    
    /// temp PATH
    var zz_tempPath: String {
        return NSTemporaryDirectory()
    }
    
    /// home PATH
    var zz_homePath: String {
        return NSHomeDirectory()
    }
    
    /// 应用 identifier
    var zz_appID: String {
        return Bundle.main.bundleIdentifier!
//        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    }
    
    /// 应用名称
    var zz_appName: String {
        return (Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String) ?? Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
    
    /// 应用版本号
    var zz_appVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    /// 应用构建版本号
    var zz_appBuildVersion: String {
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }
}

public extension UIApplication {
    /// 查询本应用在itunes 的信息
    func zz_lookupAppInfo(_ completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(zz_appID)") else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    /// 根据appID 打开一个应用
    func zz_launchAppStore(_ appID: String) {
        guard let url = URL(string: "https://itunes.apple.com/app/id\(appID)") else {
                return
        }
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                self.open(url, completionHandler: nil)
            } else {
                self.openURL(url)
            }
        }
    }
}
