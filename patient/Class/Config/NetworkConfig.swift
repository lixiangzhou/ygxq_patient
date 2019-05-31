//
//  NetworkConfig.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/30.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya
let enviroment = Enviroment.develop

struct NetworkConfig {
    /// 接口服务器
    static var APP_SERVE_URL: URL {
        switch enviroment {
        case .release:
            return URL(string: "http://www.lightheart.com.cn/shdr-service-basic")!
        case .test:
            return URL(string: "http://172.21.24.251:8889/shdr-service-basic")!
        case .develop:
            return URL(string: "http://172.21.24.252:8889/shdr-service-basic")!
        }
        
        //    return "http://172.21.20.247:8889/shdr-service-basic"
        //    return "http://172.21.20.68:8889/shdr-service-basic"
    }
    
    static func APP_SERVE_URL(_ host: String) -> String {
        return "http://\(host):8889/shdr-service-basic"
    }
    
    static func APP_SERVE_URL(_ last: Int) -> String {
        return "http://172.21.20.\(last):8889/shdr-service-basic"
    }
    
    /// HTML文件服务器
    static var HTML_SERVE_URL: String {
        switch enviroment {
        case .release:
            return "http://www.lightheart.com.cn/sphr-pages/sphr-doctor-h5"
        case .test:
            return "http://172.21.24.251/sphr-pages/sphr-doctor-h5"
        case .develop:
            return "http://172.21.24.252/sphr-pages/sphr-doctor-h5"
        }
    }
    
    /// 文件服务器
    static var APP_FILE_SERVE_URL: String {
        switch enviroment {
        case .release:
            return "http://www.lightheart.com.cn/shdr-file-boot/upload/file"
        case .test:
            return "http://172.21.24.251:5085/shdr-file-boot/upload/file"
        case .develop:
            return "http://172.21.24.252:5085/shdr-file-boot/upload/file"
        }
    }
}

enum Enviroment {
    case release
    case develop
    case test
}
