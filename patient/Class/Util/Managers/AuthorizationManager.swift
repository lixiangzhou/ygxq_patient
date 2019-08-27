//
//  AuthorizationManager.swift
//  patient
//
//  Created by lixiangzhou on 2019/8/21.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Photos

/// 相册
struct AuthorizationManager {
    static let shared = AuthorizationManager()
    
    /// 使用相册
    ///
    /// - Parameters:
    ///   - requestSuccess: 请求权限成功，首次使用时调用
    ///   - requestDenied: 请求权限失败，首次使用时调用
    ///   - success: 有权限
    ///   - denied: 无权限
    func photo(requestSuccess: (() -> Void)? = nil, requestDenied: (() -> Void)? = nil, success:(() -> Void)? = nil, denied: (() -> Void)? = nil) {
        let auth = PHPhotoLibrary.authorizationStatus()
        switch auth {
        case .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    requestSuccess?()
                } else {
                    requestDenied?()
                }
            }
        case .authorized:
            success?()
        case .denied:
            denied?()
        @unknown default:
            break
        }
    }
    
}
