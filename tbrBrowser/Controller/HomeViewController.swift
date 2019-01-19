//
//  HomeViewController.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/9.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import PYSearch
import GoogleMobileAds

class HomeViewController: TabmanViewController, PageboyViewControllerDataSource, TMBarDataSource {
    
    

    private(set) var viewControllers: [TumblrChildViewController] = []
    
    let data = [["title":"旅行", "tag":"travel"],
                ["title":"摄影", "tag":"photography"],
                ["title":"文化", "tag":"culture"],
                ["title":"艺术", "tag":"art"],
                ["title":"美食", "tag":"food"],
                ["title":"美妆", "tag":"beauty"],
                ["title":"名人", "tag":"celebrities"],
                ["title":"时尚", "tag":"fashion"],
                ["title":"男装", "tag":"menswear"],
                ["title":"萌物", "tag":"cute"],
                ["title":"宠物", "tag":"pets"],
                ["title":"自然", "tag":"nature"],
                ["title":"体育", "tag":"sports"],
                ["title":"新闻", "tag":"news"],
                ["title":"设计", "tag":"design"],
                ["title":"漫画", "tag":"comics"],
                ["title":"日本动画", "tag":"anime"],
                
                ["title":"电影", "tag":"movies"],
                ["title":"音乐", "tag":"music"],
                ["title":"电视", "tag":"television"],
                ["title":"网络剧", "tag":"web+series"],
                ["title":"演员", "tag":"actors"],
                ["title":"作家", "tag":"writers"],
                ["title":"学生", "tag":"student"],
                
                ["title":"科学", "tag":"science"],
                ["title":"科技", "tag":"technology"],
                ["title":"汽车", "tag":"autos"],
                ["title":"游戏", "tag":"gaming"],
                ["title":"手工制品", "tag":"handmade"],
                
                ["title":"亲子", "tag":"parenting"],
                ["title":"教育", "tag":"education"],
                ["title":"历史", "tag":"history"],
                ["title":"博物馆", "tag":"museums"],
                ["title":"开发者与创业公司", "tag":"developers+startups"],
                ["title":"书与图书馆", "tag":"books+libraries"],
                ["title":"家具与生活", "tag":"home+lifestyle"],
                ["title":"健康与健身", "tag":"health+fitness"]]
    

    var bannerView: GADBannerView!
    
    let bar = TMBar.ButtonBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configNavBar()
        
        self.navigationItem.title = "汤博阅读"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.showSearchView))

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.showSettingsView))
        // Do any additional setup after loading the view.
        for item in data {
            let viewController = childViewController(tag: item["tag"]!)
            viewControllers.append(viewController)
        }
        
        
        // Create bar
     
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        //bar.transitionStyle = .snap // Customize
        bar.indicator.weight = .light
        // Add to view
        addBar(bar, dataSource: self, at: .top)
        
        dataSource = self
        
        // set appearance
//        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
//            
//            // colors
//            appearance.indicator.color = UIColor.twitterBlue
//            appearance.state.selectedColor = UIColor.twitterBlue
//            appearance.state.color = UIColor.twitterGray
//            
//            appearance.text.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
//            
//            // layout
//            appearance.layout.height = .explicit(value: 44.0)
//            appearance.layout.interItemSpacing = 8.0
//        })
        
        configADBaner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Customize bar colors for gradient background.
        let tintColor = UIColor.twitterBlue
        bar.buttons.customize { (button) in
            button.selectedTintColor = tintColor
            button.tintColor = tintColor.withAlphaComponent(0.4)
        }
        bar.indicator.tintColor = tintColor
    }
    
    func configADBaner() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-20)
        }
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.adUnitID = Constants.home_ad_unit_id
        let request = GADRequest()
        //Fixed: need to remove test device
        //request.testDevices = [ "16e8a2676baa95709584d3087113eb05" ]
        bannerView.load(request)
    }
    
  
    private func childViewController(tag: String) -> TumblrChildViewController {
        let viewController = TumblrChildViewController(tag: tag)
        return viewController
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for tabViewController: TabmanViewController, at index: Int) -> TMBarItemable {
        //let title = "Page \(index)"
        let item = data[index]
        return TMBarItem(title: item["title"]!)
       
        
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = data[index]
        return TMBarItem(title: item["title"]!)
    }

    @objc func showSearchView() {
        
        let hotSeaches: [String] = []
        
        let searchViewController = PYSearchViewController(hotSearches: hotSeaches, searchBarPlaceholder: "搜索您感兴趣的标签") { (searchViewController, searchBar, searchText) in
            guard let tag = searchText else {
                return
            }
            
            if !tag.isEmpty  {
                let controller = TumblrChildViewController(tag: tag)
                searchViewController?.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        searchViewController?.searchTextField.tintColor = UIColor.black
        searchViewController?.searchViewControllerShowMode = .modePush
        self.navigationController?.pushViewController(searchViewController!, animated: true)
    }

    @objc func showSettingsView() {
        self.performSegue(withIdentifier: "showSettingsView", sender: nil)
    }
}

extension HomeViewController: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
