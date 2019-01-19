//
//  FavoriteTableViewController.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/13.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import DZNEmptyDataSet
import GoogleMobileAds

class FavoriteTableViewController: UITableViewController, DZNEmptyDataSetSource {
    
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的收藏"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.emptyDataSetSource = self
        //self.tableView.emptyDataSetDelegate = self
        
        self.tableView.tableFooterView = UIView()
        
        configADBaner()
    }
    
    func configADBaner() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: 60))
        headerView.backgroundColor = UIColor.white
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        headerView.addSubview(bannerView)
        bannerView.snp.makeConstraints { (make) in
            make.center.equalTo(headerView)
        }
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.adUnitID = Constants.favorite_ad_unit_id
        //bannerView.load(GADRequest())
        let request = GADRequest()
        //Fixed: need to remove test device
        //request.testDevices = [ "16e8a2676baa95709584d3087113eb05" ]
        bannerView.load(request)
        
        self.tableView.tableHeaderView = headerView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Defaults[.favoriteList].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell

        // Configure the cell...
        let blog = Defaults[.favoriteList][indexPath.row]
        cell.blogIdLabel.text = blog.name
        
        if let blogId = blog.name {
            let avatarUrl = "https://api.tumblr.com/v2/blog/" + blogId + ".tumblr.com/avatar"
            if let url = URL(string: avatarUrl) {
                cell.avatarImageView.kf.setImage(with: url)
            }
        }
      
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let blogId = Defaults[.favoriteList][indexPath.row].name {
                FavoriteManager.shareInstance.remove(blogId: blogId)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let blogCodable = Defaults[.favoriteList][indexPath.row]
        let blog = Blog(blog: blogCodable)
        
        let controller = BlogViewController(blog: blog)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = NSAttributedString(string: "您还没有收藏哟", attributes: nil)
        return title
    }
}


extension FavoriteTableViewController: GADBannerViewDelegate {
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
