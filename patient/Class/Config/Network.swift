//
//  Network.swift
//  patient
//
//  Created by Macbook Pro on 2019/5/29.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import Moya
import ReactiveSwift
import HandyJSON
import Result
import SVProgressHUD


let Provider = MoyaProvider<MultiTarget>(plugins: getPlugin())

// MARK: -
let activityPlugin = NetworkActivityPlugin { (type: NetworkActivityChangeType, target: TargetType) in
    switch type {
    case .began:
        AppActivityIndicatorConfig.requestCount.value += 1
    case .ended:
        AppActivityIndicatorConfig.requestCount.value -= 1
    }
}

private func getPlugin() -> [PluginType] {
    switch enviroment {
    case .release:
        return [activityPlugin]
    default:
        return [NetworkSimpleLoggerPlugin(), activityPlugin]
    }
}

// MARK: -
extension TargetType {
    var baseURL: URL { return NetworkConfig.APP_SERVE_URL }
    
    var method: Moya.Method { return .post }
    
    var sampleData: Data { return "test".data(using: .utf8)! }
    
    var headers: [String : String]? {
        return nil
    }
}

extension TargetType {
    func response(_ completion: @escaping Moya.Completion) {
        Provider.request(MultiTarget(self), completion: completion)
    }
    
    func rac_response(_ completion: @escaping Moya.Completion) -> SignalProducer<Response, MoyaError> {
        return Provider.reactive.request(MultiTarget(self))
    }

    ///
    func _response<Model: HandyJSON>(_ type: Model.Type, completion: @escaping (ResponseModel<Model>) -> Void) {
        response { (result) in
            switch result {
            case .success(let resp):
                var responseModel = ResponseModel<Model>(.success(resp))
                let json = try? JSONSerialization.jsonObject(with: resp.data, options: .allowFragments) as? [String: Any]
                JSONDeserializer.update(object: &responseModel, from: json)
                completion(responseModel)
            case .failure(let error):
                let responseModel = ResponseModel<Model>(.failure(error))
                completion(responseModel)
            }
        }
    }
    
    func responseModel<Model: HandyJSON>(_ type: Model.Type, completion: ((Model?) -> Void)? = nil) {
        _response(type) { (resp: ResponseModel<Model>) in
            switch resp.result {
            case .success:
                if resp.resultcode == 200 {
                    completion?(resp.content)
                } else {
                    completion?(nil)
                }
            case .failure:
                completion?(nil)
            }
        }
    }
}

/// 响应模型
struct ResponseModel<Content: HandyJSON>: HandyJSON  {
    // MARK: - 后台返回的数据结构
    var resultcode: Int?
    var resultmsg: String?
    var content: Content?
    
    /// 原始结果
    var result: Result<Moya.Response, MoyaError>
    
    init(_ result: Result<Moya.Response, MoyaError>) {
        self.result = result
    }
    
    init() {
        result = .failure(MoyaError.requestMapping("不要使用这个初始化方法"))
    }
}

extension String: HandyJSON { }
extension Int: HandyJSON { }
extension Bool: HandyJSON { }
extension Double: HandyJSON { }
struct None: HandyJSON { }


// MARK: - Plugins
struct NetworkSimpleLoggerPlugin: PluginType {
    private let loggerId = "Loger"
    
    private let dateFormatter = DateFormatter()
    
    private let requestSeparatorLine = "========================================================"
    private let responseSeparatorLine = "########################################################"
    private let printOverLine = "--------------------------------------------------------"
    
    init() {
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        print(requestSeparatorLine)
        outputItems(logNetworkRequest(request.request as URLRequest?))
        print(printOverLine)
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        print(responseSeparatorLine)
        if case .success(let response) = result {
            outputItems(logNetworkResponse(response, data: response.data, target: target))
        } else {
            outputItems(logNetworkResponse(nil, data: nil, target: target))
        }
        print(printOverLine)
    }
    
    private func outputItems(_ items: [String]) {
        items.forEach { reversedPrint(", ", terminator: "\n", items: $0) }
    }
    
    var date: String {
        return dateFormatter.string(from: Date())
    }
    
    func format(_ loggerId: String, date: String, identifier: String, message: String) -> String {
        return "\(loggerId): [\(date)] \(identifier): \(message)"
    }
    
    func logNetworkRequest(_ request: URLRequest?) -> [String] {
        var output = [String]()
        var string = ""
        if let httpMethod = request?.httpMethod {
            string += "\(httpMethod) "
        }
        string += (request?.description ?? "(invalid request)")
        
        if let headers = request?.allHTTPHeaderFields {
            string += "\nRequest Headers:\n\(headers)"
        }
        
        if let body = request?.httpBody, let stringOutput = String(data: body, encoding: .utf8) {
            string += "\nRequest Body:\n\(stringOutput)"
        }
        
        output += [format(loggerId, date: date, identifier: "Request", message: string)]
        
        
        return output
    }
    
    func logNetworkResponse(_ response: Moya.Response?, data: Data?, target: TargetType) -> [String] {
        guard let response = response else {
            return [format(loggerId, date: date, identifier: "Response", message: "Received empty network response for \(target).")]
        }
        
        return [format(loggerId, date: date, identifier: "Response", message: "Status Code: \(response.statusCode) \n\(response.request?.httpMethod ?? "NoMethod") \(response.request?.url?.absoluteString ?? "")\n\(String(data: response.data , encoding: .utf8) ?? "")")]
    }
    
    func reversedPrint(_ separator: String, terminator: String, items: Any...) {
        for item in items {
            print(item, separator: separator, terminator: terminator)
        }
    }
}
