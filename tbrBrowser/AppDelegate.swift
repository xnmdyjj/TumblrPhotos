//
//  AppDelegate.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/8.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import NEKit
import Alamofire
import GoogleMobileAds
import SwiftyUserDefaults

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var proxyServer: ProxyServer!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize the Google Mobile Ads SDK.
        // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
        GADMobileAds.configure(withApplicationID: Constants.admob_app_id)
        
        let navigationBarAppearace = UINavigationBar.appearance()

        navigationBarAppearace.tintColor = UIColor.white
        navigationBarAppearace.barTintColor = UIColor.mainColor
        //navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        if Defaults[.isUseProxy] {
            self.createAndStratProxyServer()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        if Defaults[.isUseProxy] {
             proxyServer.stop()
        }
    }
    
    let proxyServerInfo = [["host": "172.105.214.28", "password":"xyyWAvGJOUL7LrE2"],
                           ["host": "66.42.108.130", "password":"7FdDYNT2ze15OZrP"],
                           ["host": "23.83.231.180", "password":"t4nCCGgStnd8EB71"],
                        ["host": "149.28.11.14", "password":"gik0sUlIYqnJb1AS"],
                        ["host": "66.42.59.151", "password":"s7TVe6YAzZzXT3H7"]]
    

    func createAndStratProxyServer() {

        guard let serverInfo = proxyServerInfo.randomElement() else {
            return
        }

        guard let ss_adder = serverInfo["host"] else {
            return
        }
        let ss_port = 8581
        guard let password = serverInfo["password"] else {
            return
        }
        
        
        let algorithm:CryptoAlgorithm = .AES256CFB
        
        
        // Origin
        let obfuscater = ShadowsocksAdapter.ProtocolObfuscater.OriginProtocolObfuscater.Factory()
        
        //proxy
        let ssAdapterFactory = ShadowsocksAdapterFactory(serverHost: ss_adder, serverPort: ss_port, protocolObfuscaterFactory:obfuscater, cryptorFactory: ShadowsocksAdapter.CryptoStreamProcessor.Factory(password: password, algorithm: algorithm), streamObfuscaterFactory: ShadowsocksAdapter.StreamObfuscater.OriginStreamObfuscater.Factory())
        
        
        let rule = AllRule(adapterFactory: ssAdapterFactory)
        let manager = RuleManager(fromRules: [rule])
        RuleManager.currentManager = manager
        
        self.proxyServer = GCDHTTPProxyServer(address: IPAddress(fromString: "127.0.0.1"), port: NEKit.Port(port: 9090))
        
        do {
            try self.proxyServer.start()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

