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
import Result
import HandyJSON
import SwiftyJSON

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
    switch context {
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
    
    var sampleData: Data { return "sampleData".data(using: .utf8)! }
    
    var headers: [String : String]? {
        return nil
    }
}

extension TargetType {
    // MARK: -
    func rac_responseModel<Model: ModelProtocol>(_ type: Model.Type) -> SignalProducer<Model?, NoError> {
        return rac_response(type).map { self.getModel(type, responseModel: $0) }
    }
    
    func rac_response<Model: ModelProtocol>(_ type: Model.Type) -> SignalProducer<ResponseModel<Model>, NoError> {
        return SignalProducer<ResponseModel<Model>, NoError> { observer, lifetime in
            let cancellableToken = Provider.request(MultiTarget(self)) { (result) in
                switch result {
                case let .success(resp):
                    observer.send(value: self.getResponseModel(type, resp))
                    observer.sendCompleted()
                case let .failure(error):
                    observer.send(value: ResponseModel<Model>(.failure(error)))
                    observer.sendCompleted()
                }
            }
            
            lifetime.observeEnded {
                cancellableToken.cancel()
            }
        }
    }
    
    // MARK: -
    func responseModel<Model: ModelProtocol>(_ type: Model.Type, completion: ((Model?) -> Void)? = nil) {
        response(type) { completion?(self.getModel(type, responseModel: $0)) }
    }
    
    func response<Model: ModelProtocol>(_ type: Model.Type, completion: @escaping (ResponseModel<Model>) -> Void) {
        response { (result) in
            switch result {
            case .success(let resp):
                completion(self.getResponseModel(type, resp))
            case .failure(let error):
                completion(ResponseModel<Model>(.failure(error)))
            }
        }
    }
    
    func response(_ completion: @escaping Moya.Completion) {
        Provider.request(MultiTarget(self), completion: completion)
    }
    
    // MARK: - 内部辅助方法
    /// 获取后台返回的数据结构模型
    private func getResponseModel<Model: ModelProtocol>(_ type: Model.Type, _ resp: Response) -> ResponseModel<Model> {
        var responseModel = ResponseModel<Model>(.success(resp))
        let json = try? JSONSerialization.jsonObject(with: resp.data, options: .allowFragments) as? [String: Any]
        JSONDeserializer.update(object: &responseModel, from: json)
        return responseModel
    }
    
    /// 通过 后台返回的数据结构模型 获取 结果模型
    private func getModel<Model: ModelProtocol>(_ type: Model.Type, responseModel: ResponseModel<Model>) -> Model? {
        switch responseModel.result {
        case .success:
            if responseModel.resultcode == 200 {
                return responseModel.content
            } else {
                return nil
            }
        case .failure:
            return nil
        }
    }
}

/// 响应模型
struct ResponseModel<Content: ModelProtocol>: ModelProtocol  {
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

extension ResponseModel {
    var isSuccess: Bool {
        return resultcode == 200
    }
}

extension String: ModelProtocol { }
extension Int: ModelProtocol { }
extension Bool: ModelProtocol { }
extension Double: ModelProtocol { }
extension Array: ModelProtocol { }
extension Dictionary: ModelProtocol { }
struct None: ModelProtocol { }

struct BoolString {
    var isSuccess: Bool
    var toast: String = ""
}
extension BoolString {
    init<Content: ModelProtocol>(_ resp: ResponseModel<Content>) {
        self.isSuccess = resp.isSuccess
        self.toast = resp.resultmsg ?? ""
    }
}

// MARK: - Plugins
struct NetworkSimpleLoggerPlugin: PluginType {
    private let loggerId = "Loger"
    
    private let dateFormatter = DateFormatter()
    
    private let requestSeparatorLine = "============================== Request =============================="
    private let responseSeparatorLine = "############################### Response #############################"
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
        let resultString = String(data: response.data , encoding: .utf8) ?? ""
        
        var result: Any = resultString
        if let data = resultString.data(using: .utf8), let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            result = json
        }
        
        return [format(loggerId, date: date, identifier: "Response", message: "Status Code: \(response.statusCode) \n\(response.request?.httpMethod ?? "NoMethod") \(response.request?.url?.absoluteString ?? "")\n\(result)")]
    }
    
    func reversedPrint(_ separator: String, terminator: String, items: Any...) {
        for item in items {
            print(item, separator: separator, terminator: terminator)
        }
    }
}

