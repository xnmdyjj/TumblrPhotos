//
//  TumblrChildViewController.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/9.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import ObjectMapper
import SKPhotoBrowser
import MBProgressHUD
import Kingfisher
import SwiftyUserDefaults
import DZNEmptyDataSet
import SVProgressHUD
import Alamofire

class TumblrChildViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource {

    var tag: String!
    let tableView = UITableView()
    
    var results:[TagSearchResponse] = []
    
    private let refreshControl = UIRefreshControl()
    
    var isRquesting = false
    
    var photoTappedRow: Int?
    
    
    /// 重写父类的init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)方法
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// 重载父类的init()
    init(tag: String) {
        super.init(nibName: nil, bundle: nil)
        self.tag = tag
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = tag
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.mainColor
        tableView.separatorStyle = .none
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "photoCell")
        
        ImageDownloader.default.downloadTimeout = 60

        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

        if Defaults[.isUseProxy] {
            self.configImageDownloaderProxy()
            self.proxyRequestData()
        }else {
            self.configImageDownloaderNormal()
            self.requestData()
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        if Defaults[.isUseProxy] {
            self.configImageDownloaderProxy()
            self.proxyRequestData()
        }else {
            self.configImageDownloaderNormal()
            self.requestData()
        }
    }
    
    func configImageDownloaderNormal() {
        let config = ImageDownloader.default.sessionConfiguration
        config.connectionProxyDictionary = nil
        ImageDownloader.default.sessionConfiguration = config
    }
    
    func configImageDownloaderProxy() {
        print("-----------------configImageDownloaderProxy------------------")
        
        //let config = URLSessionConfiguration.default
        let config = ImageDownloader.default.sessionConfiguration
        
        config.connectionProxyDictionary = [AnyHashable: Any]()
        config.connectionProxyDictionary?[kCFNetworkProxiesHTTPEnable as String] = 1
        config.connectionProxyDictionary?[kCFNetworkProxiesHTTPProxy as String] = "127.0.0.1"
        config.connectionProxyDictionary?[kCFNetworkProxiesHTTPPort as String] = 9090
        config.connectionProxyDictionary?[kCFStreamPropertyHTTPSProxyHost as String] = "127.0.0.1"
        config.connectionProxyDictionary?[kCFStreamPropertyHTTPSProxyPort as String] = 9090
        
        ImageDownloader.default.sessionConfiguration = config
    }
    
    func requestData() {
        print("-----------------normal request------------------")
        
        let tagArray = tag.components(separatedBy: " ")
        let tagString = tagArray.joined(separator: "+")
        
        var queryTagStr = ""
        if let escapedTagString = tagString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            queryTagStr = escapedTagString
        } else {
            queryTagStr = tagString
        }
    
        let url = Constants.api_endPoint + "/v2/tagged?" + "tag=" + queryTagStr + "&api_key=" + Constants.api_key + "&limit=" + String(Defaults[.limit])

        isRquesting = true
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Realhttp.shareInstance.getRequest(url: url, success: { (responseString) in
            //print(responseString)
            self.isRquesting = false
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            let model = BaseModel(JSONString: responseString)
            if model?.meta?.status == 200 {
                if let data = model?.response as? [[String: Any]] {
                    let array = Mapper<TagSearchResponse>().mapArray(JSONArray: data)
                    self.choosePhotoItem(data: array)
                    self.tableView.reloadData()
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            self.isRquesting = false
            self.refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showMBText(message: "网络错误，请稍后再试")
        }
    }
    
    func proxyRequestData() {
        print("-----------------proxy request------------------")
        let tagArray = tag.components(separatedBy: " ")
        let tagString = tagArray.joined(separator: "+")

        var queryTagStr = ""
        if let escapedTagString = tagString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            queryTagStr = escapedTagString
        } else {
            queryTagStr = tagString
        }
        
        let url = Constants.api_endPoint + "/v2/tagged?" + "tag=" + queryTagStr + "&api_key=" + Constants.api_key + "&limit=" + String(Defaults[.limit])
        
        isRquesting = true
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ProxyRequest.shareInstance.getRequest(url: url, success: { (responseString) in
            //print(responseString)
            self.isRquesting = false
            MBProgressHUD.hide(for: self.view, animated: true)
            self.refreshControl.endRefreshing()
            let model = BaseModel(JSONString: responseString)
            if model?.meta?.status == 200 {
                if let data = model?.response as? [[String: Any]] {
                    let array = Mapper<TagSearchResponse>().mapArray(JSONArray: data)
                    self.choosePhotoItem(data: array)
                    self.tableView.reloadData()
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            self.isRquesting = false
            self.refreshControl.endRefreshing()
            MBProgressHUD.hide(for: self.view, animated: true)
            self.showMBText(message: "网络错误，请稍后再试")
        }
    }
    
    
    func choosePhotoItem(data: [TagSearchResponse])  {
        results.removeAll()
        for item in data {
            if item.type == "photo" {
                results.append(item)
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoTableViewCell
        cell.config(data: results[indexPath.row], row: indexPath.row)
        cell.delegate = self
        return cell
     
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = results[indexPath.row]
        return PhotoTableViewCell.rowHeight(data: data)
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if isRquesting {
            return NSAttributedString(string: "", attributes: nil)
        }
        let title = NSAttributedString(string: "未查询到有图片的内容哟", attributes: nil)
        return title
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

extension TumblrChildViewController: PhotoTableViewCellDelegate {
    func photoTapped(row: Int, index: Int) {
        if Defaults[.isUseProxy] {
            configSKPhotoBrowserProxy()
        }else {
            configImageDownloaderNormal()
        }
        
        let item = results[row]
        
        guard let photos = item.photos else {
            return
        }
        
        
        
        // 1. create URL Array
        var images = [SKPhoto]()
        for photo in photos {
            if let url = photo.original_size?.url {
                let photo = SKPhoto.photoWithImageURL(url)
                photo.caption = item.summary
                images.append(photo)
            }
        }
        
        SKPhotoBrowserOptions.actionButtonTitles = ["保存"]
        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.delegate = self
        browser.initializePageIndex(index)
        browser.cancelTitle = "取消"
        present(browser, animated: true, completion: {})
        
        self.photoTappedRow = row
    }
    
    func showBlogView(row: Int) {
        let data = results[row]
        guard let blog = data.blog else {
            return
        }
        blog.theme = data.trail?.first?.blog?.theme
        let controller = BlogViewController(blog: blog)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tagTapped(tag: String) {
        let controller = TumblrChildViewController(tag: tag)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}

extension TumblrChildViewController: SKPhotoBrowserDelegate {
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
        if buttonIndex == 0 {
            guard let row = self.photoTappedRow else {
                return
            }
            
            let item = results[row]
            
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
            print(error.localizedDescription)
            //self.showMBText(message: "保存失败")
            SVProgressHUD.showError(withStatus: "保存失败")
        } else {
            // self.showMBText(message: "保存成功")
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }
    }
}
