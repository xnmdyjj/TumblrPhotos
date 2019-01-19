//
//  NetworkManager.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/8.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager {
    
    //shared instance
    static let shared = NetworkManager()
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.tumblr.com")
    
    func startNetworkReachabilityObserver() {
                
        reachabilityManager?.listener = { status in
            print("Network Status Changed: \(status)")
            
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                
            }
        }
        
        // start listening
        reachabilityManager?.startListening()
    }
}
