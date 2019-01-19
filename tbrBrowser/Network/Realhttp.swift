//
//  Realhttp.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/8.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import Alamofire

class Realhttp {
    static let shareInstance = Realhttp()
    private init(){}
}

extension Realhttp {
    // MARK: 根据项目需求，看是否要返回failrue
    // get请求
    func getRequest(url:String, parameters:[String : Any]? = nil,success:@escaping (_ response : String)->(), failure : @escaping (_ error : Error)->()){
        print(url)
        Alamofire.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseString { (response) in
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
    // post请求
    func postRequest(url:String, parameters:[String : Any]? = nil,success:@escaping (_ response : String)->(), failure : @escaping (_ error : Error)->()){
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseString { (response) in
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
    // 下载文件
    func downloadRequest(url:String,success:@escaping (_ response : Any)->(), failure : @escaping (_ error : Error)->()){
        Alamofire.download(url).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    success(value)
                }
            case .failure(let error):
                print("download is fail")
                failure(error)
            }
        }
        
    }
    // 下载文件 查看进度
    func downloadRequestAndProgress(url:String,success:@escaping (_ response : Any)->(), failure : @escaping (_ error : Error)->()){
        Alamofire.download(url).downloadProgress { (progress) in
            print("download progress = \(progress)")
            }.responseJSON { (response) in
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
