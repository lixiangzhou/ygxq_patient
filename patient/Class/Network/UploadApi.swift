//
//  UploadApi.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/1.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya

struct FileData {
    var data: Data
    var name: String
}

enum UploadApi: TargetType {
    case upload(datas: [FileData])
}

extension UploadApi {
    var path: String {
        switch self {
        case .upload:
            return "/upload/file"
        }
    }
    
    var baseURL: URL {
        switch enviroment {
        case .release:
            return URL(string: "http://www.lightheart.com.cn/shdr-file-boot")!
        case .test:
            return URL(string: "http://172.21.24.251:5085/shdr-file-boot")!
        case .develop:
            return URL(string: "http://172.21.24.252:5085/shdr-file-boot")!
        }
    }
    
    var task: Task {
        switch self {
        case let .upload(datas: datas):
            var formDatas = [MultipartFormData]()
            for file in datas {
                formDatas.append(MultipartFormData(provider: .data(file.data), name: "file", fileName: file.name, mimeType: "image/jpeg"))
            }
            
            return .uploadMultipart(formDatas)
        }
    }
}
