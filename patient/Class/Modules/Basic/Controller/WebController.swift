//
//  WebController.swift
//  patient
//
//  Created by Macbook Pro on 2019/7/3.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import WebKit
import WKWebViewJavascriptBridge

class WebController: BaseController {

    // MARK: - Life Cycle
    
    override public func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        couldShowLogin = false
        setUI()
        registerHandlers()
        loadPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if titleString != nil {
            title = titleString
        }
    }

    // MARK: - Public Property
    /// 要加载的URL
    var url: URL?
    /// 要加载的URLRequet
    var request: URLRequest?
    /// 如果设置了就显示，如果没有设置，就显示网页的 document.title
    var titleString: String?
    
    var canBack = true
    var cantBackTipString = ""
    ///
    lazy var bridge: WKWebViewJavascriptBridge = {
        return WKWebViewJavascriptBridge(webView: webView)
    }()
    // MARK: - Private Property
    private let webView = WKWebView()
}

// MARK: - UI
extension WebController {
    override func setUI() {
        webView.scrollView.backgroundColor = .cf0efef
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
}

// MARK: - Network
extension WebController {
    func loadPage() {
        if let request = request {
            webView.load(request)
        } else if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
}

// MARK: - Delegate Internal

// MARK: -
extension WebController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension WebController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        webView.evaluateJavaScript("document.title") { [weak self] (response, error) in
            if self?.titleString == nil {
                self?.title = response as! String?
            }
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        
        let hostAddress = navigationAction.request.url?.host
        
        if (navigationAction.targetFrame == nil) {
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
        
        // To connnect app store
        if hostAddress == "itunes.apple.com" {
            if UIApplication.shared.canOpenURL(navigationAction.request.url!) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }
        }
        
        let url_elements = url!.absoluteString.components(separatedBy: ":")
        
        switch url_elements[0] {
        case "tel":
            openCustomApp(urlScheme: "telprompt://", additional_info: url_elements[1])
            decisionHandler(.cancel)
            
        case "sms":
            openCustomApp(urlScheme: "sms://", additional_info: url_elements[1])
            decisionHandler(.cancel)
            
        case "mailto":
            openCustomApp(urlScheme: "mailto://", additional_info: url_elements[1])
            decisionHandler(.cancel)
            
        default:
            break
        }
        
        decisionHandler(.allow)
        
    }
    
    func openCustomApp(urlScheme: String, additional_info:String){
        
        if let requestUrl: URL = URL(string:"\(urlScheme)"+"\(additional_info)") {
            let application:UIApplication = UIApplication.shared
            if application.canOpenURL(requestUrl) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
    }
}

// MARK: - Delegate External

// MARK: -

// MARK: - Helper
extension WebController {
    
}

// MARK: - Other
extension WebController {
    private func registerHandlers() {
        register("nav_back") { [weak self] (data, callBack) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        register("btn_click") { [weak self] (data, callBack) in
            if let type = data?["state"] as? String {
                switch type {
                case "stDialing", "stDialTalking":
                    self?.canBack = false
                    self?.cantBackTipString = "通话中不可退出当前页面"
                default:
                    self?.canBack = true
                }
            }
        }
    }
    
    override func backAction() {
        if !canBack && !cantBackTipString.isEmpty {
            HUD.show(toast: cantBackTipString)
        } else {
            super.backAction()
        }
    }
}

// MARK: - Public
extension WebController {
    func register(_ handlerName: String, handler: @escaping WKWebViewJavascriptBridgeBase.Handler) {
        bridge.register(handlerName: handlerName, handler: handler)
    }
    
    func call(handlerName: String) {
        bridge.call(handlerName: handlerName)
    }
    
    static func pushFrom(_ vc: UIViewController,title: String? = nil, url: URL?) {
        let vc = WebController()
        vc.titleString = title
        vc.url = url
        vc.push(vc)
    }
}

