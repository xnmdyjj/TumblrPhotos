//
//  ProxyRequest.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/10.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import Alamofire

class ProxyRequest  {
    
    static let shareInstance = ProxyRequest()
    private init(){
       configRequest()
    }
    
    var requestManager = Alamofire.SessionManager.default

    func configRequest() {
        var proxyConfiguration = [NSObject: AnyObject]()
        proxyConfiguration[kCFNetworkProxiesHTTPProxy] = "127.0.0.1" as AnyObject?
        proxyConfiguration[kCFNetworkProxiesHTTPPort] = "9090" as AnyObject?
        proxyConfiguration[kCFNetworkProxiesHTTPEnable] = 1 as AnyObject?
        proxyConfiguration[kCFStreamPropertyHTTPSProxyHost] = "127.0.0.1" as AnyObject
        proxyConfiguration[kCFStreamPropertyHTTPSProxyPort] = 9090 as AnyObject
        //proxyConfiguration[kCFProxyUsernameKey as String] = xxx
        //proxyConfiguration[kCFProxyPasswordKey as String] = "pwd if any"
        let cfg = Alamofire.SessionManager.default.session.configuration
        cfg.connectionProxyDictionary = proxyConfiguration
        requestManager = Alamofire.SessionManager(configuration: cfg)
    }
    
//    func proxyURLSessionConfiguration() -> URLSessionConfiguration {
//        let config = URLSessionConfiguration.default
//        //config.requestCachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
//        config.connectionProxyDictionary = [AnyHashable: Any]()
//        config.connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable as String] = 1
//        config.connectionProxyDictionary?[kCFNetworkProxiesHTTPProxy as String] = "127.0.0.1"
//        config.connectionProxyDictionary?[kCFNetworkProxiesHTTPPort as String] = 9090
//        config.connectionProxyDictionary?[kCFStreamPropertyHTTPSProxyHost as String] = "127.0.0.1"
//        config.connectionProxyDictionary?[kCFStreamPropertyHTTPSProxyPort as String] = 9090
//        return config
//    }
    
    // MARK: 根据项目需求，看是否要返回failrue
    // get请求
    func getRequest(url:String, parameters:[String : Any]? = nil,success:@escaping (_ response : String)->(), failure : @escaping (_ error : Error)->()){
        print(url)
        
        requestManager.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseString { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    success(value)
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}
