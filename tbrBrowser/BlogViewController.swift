//
//  BlogViewController.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/11.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import MBProgressHUD
import SwiftyUserDefaults
import GoogleMobileAds
import SVProgressHUD
import Alamofire

class BlogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var blog: Blog!
    var posts: [TagSearchResponse] = []
    
    let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    var bannerView: GADBannerView!
    
    var photoTappedRow: Int?
    
    
    /// 重写父类的init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)方法
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// 重载父类的init()
    init(blog: Blog) {
        super.init(nibName: nil, bundle: nil)
        self.blog = blog
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.navigationItem.title = "Tumblr 博客 - " + (blog.name ?? "")
        //self.navigationItem.title = "Tumblr 博客"
        self.navigationItem.title = blog.name
        
        if let blogId = blog.name {
            if FavoriteManager.shareInstance.findIndex(blogId: blogId) == nil {
                 self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "收藏", style: .plain, target: self, action: #selector(self.favoriteAction))
            }
        }
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        if let background_color = self.blog.theme?.background_color  {
            tableView.backgroundColor = UIColor(background_color)
        }else {
            tableView.backgroundColor = UIColor.mainColor
        }
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

        
        let headerView = BlogHeaderView(frame: CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: 200))
        headerView.config(data: blog)
        tableView.tableHeaderView = headerView
        
        tableView.register(PostPhotoTableViewCell.self, forCellReuseIdentifier: "postPhotoCell")
        
        if Defaults[.isUseProxy] {
            self.proxyRequestData()
        }else {
            self.requestData()
        }
        
        configADBaner()
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
        bannerView.adUnitID = Constants.blog_ad_unit_id
        //bannerView.load(GADRequest())
        let request = GADRequest()
        //Fixed: need to remove test device
        //request.testDevices = [ "16e8a2676baa95709584d3087113eb05" ]
        bannerView.load(request)
    }
    
    @objc private func refreshData(_ sender: Any) {
        if Defaults[.isUseProxy] {
            self.proxyRequestData()
        }else {
            self.requestData()
        }
    }
    
    @objc func favoriteAction() {
        let blogInfo = BlogCodable(blog: blog)
        FavoriteManager.shareInstance.add(blog: blogInfo)
        self.showMBText(message: "收藏成功，您可以在我的收藏中查看")
    }

    func requestData() {
        print("-----------------normal request------------------")

        guard let blogName = blog.name else {
            return
        }
     
        let blogId = blogName + ".tumblr.com"
        
        
        let url = Constants.api_endPoint + "/v2/blog/" + blogId + "/posts/photo?" + "api_key=" + Constants.api_key + "&limit=" + String(Defaults[.limit])
        
        //let url = "https://api.tumblr.com/v2/blog/manydramaslittletime.tumblr.com/posts/photo?api_key=yj3VDZLbOPgUt0Lnh4Nw2a1LoqmPhgRellDXhvCGJSzMLtGM0q&limit=20"
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Realhttp.shareInstance.getRequest(url: url, success: { (responseString) in
            //print(responseString)
            self.refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
            let model = BaseModel(JSONString: responseString)
            if model?.meta?.status == 200 {
                if let response = model?.response as? [String: Any] {
                    if let responseObj = PostsResponse(JSON: response) {
                        self.posts = responseObj.posts
                        self.tableView.reloadData()
                    }

                }
            }
  
        }) { (error) in
            print(error.localizedDescription)
            self.refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showMBText(message: "网络错误，请稍后再试")
        }
    }
    
    func proxyRequestData() {
        print("-----------------proxy request------------------")

        guard let blogName = blog.name else {
            return
        }
        
        let blogId = blogName + ".tumblr.com"
        let url = Constants.api_endPoint + "/v2/blog/" + blogId + "/posts/photo?" + "api_key=" + Constants.api_key + "&limit=" + String(Defaults[.limit])
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ProxyRequest.shareInstance.getRequest(url: url, success: { (responseString) in
            //print(responseString)
            self.refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
            let model = BaseModel(JSONString: responseString)
            if model?.meta?.status == 200 {
                if let response = model?.response as? [String: Any] {
                    if let responseObj = PostsResponse(JSON: response) {
                        self.posts = responseObj.posts
                        self.tableView.reloadData()
                    }
                    
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
            self.refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showMBText(message: "网络错误，请稍后再试")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postPhotoCell", for: indexPath) as! PostPhotoTableViewCell
        cell.config(data: posts[indexPath.row], row: indexPath.row)
        cell.delegate = self
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = posts[indexPath.row]
        return PostPhotoTableViewCell.rowHeight(data: data)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let background_color = self.blog.theme?.background_color {
            cell.backgroundColor = UIColor(background_color)
        }else {
            cell.backgroundColor = UIColor.mainColor
        }
    }
    
    func configSKPhotoBrowserNormal() {
        let config = SKPhotoBrowserOptions.sessionConfiguration
        config.connectionProxyDictionary = nil
        SKPhotoBrowserOptions.sessionConfiguration = config
    }
    
    func configSKPhotoBrowserProxy() {
        let config = SKPhotoBrowserOptions.sessionConfiguration
        config.connectionProxyDictionary = [AnyHashable: Any]()
        config.connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable as String] = 1
        config.connectionProxyDictionary?[kCFNetworkProxiesHTTPProxy as String] = "127.0.0.1"
        config.connectionProxyDictionary?[kCFNetworkProxiesHTTPPort as String] = 9090
        config.connectionProxyDictionary?[kCFStreamPropertyHTTPSProxyHost as String] = "127.0.0.1"
        config.connectionProxyDictionary?[kCFStreamPropertyHTTPSProxyPort as String] = 9090
        SKPhotoBrowserOptions.sessionConfiguration = config
    }
}

extension BlogViewController: PostPhotoTableViewCellDelegate {
   
    func photoTapped(row: Int, index: Int) {
        if Defaults[.isUseProxy] {
            configSKPhotoBrowserProxy()
        }else {
            configSKPhotoBrowserNormal()
        }
        
        let item = posts[row]
        
        guard let photos = item.photos else {
            return
        }
        
        // 1. create URL Array
        var images = [SKPhoto]()
        for photo in photos {
            if let url = photo.original_size?.url {
                let photo = SKPhoto.photoWithImageURL(url)
                photo.caption = item.summary
                //photo.shouldCachePhotoURLImage = true
                images.append(photo)
            }
        }
        
        SKPhotoBrowserOptions.actionButtonTitles = ["保存"]

        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.cancelTitle = "取消"
        browser.initializePageIndex(index)
        browser.delegate = self
        present(browser, animated: true, completion: {})
        
        self.photoTappedRow = row
    }
    
    func tagTapped(tag: String) {
        let controller = TumblrChildViewController(tag: tag)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}

extension BlogViewController: SKPhotoBrowserDelegate {
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
        if buttonIndex == 0 {
            guard let row = self.photoTappedRow else {
                return
            }
            
            let item = posts[row]
            
            guard let photos = item.photos else {
                return
            }
            
            let photo = photos[photoIndex]
            
            if let url = photo.original_size?.url {
                SVProgressHUD.show()
                Alamofire.request(url).responseData { response in
                    SVProgressHUD.dismiss()
                    guard let data = response.result.value else { return }
                    if let image = UIImage(data: data) {
                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    }
                }
            }
        }
    }


    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print(error.localizedDescription)
            //self.showMBText(message: "保存失败")
            SVProgressHUD.showError(withStatus: "保存失败")
        } else {
           // self.showMBText(message: "保存成功")
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }
    }
}


extension BlogViewController: GADBannerViewDelegate {
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
}
