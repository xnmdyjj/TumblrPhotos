//
//  SettingTableViewController.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/12.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Kingfisher
import MBProgressHUD
import MessageUI

class SettingTableViewController: UITableViewController, LimitTableViewControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var cacheSizeLabel: UILabel!
    @IBOutlet weak var proxyStatusLabel: UILabel!
    @IBOutlet weak var proxySwitch: UISwitch!
    @IBOutlet weak var limitNumLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = "设置"
        proxySwitch.isOn = Defaults[.isUseProxy]
        proxyStatusLabel.text = proxySwitch.isOn ? "已开启" : "未开启"
        limitNumLabel.text = "\(Defaults[.limit])条"
        
        ImageCache.default.calculateDiskCacheSize { (size) in
            //print("Disk cache size: \(Double(size) / 1024 / 1024) MB")
            self.cacheSizeLabel.text = String(format: "%.2f MB", Double(size) / 1024 / 1024)
        }
        
        versionLabel.text = "Version " + version()
    }
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version)" + " (\(build))"
    }

    @IBAction func proxySwitchValueChanged(_ sender: Any) {
        Defaults[.isUseProxy] = proxySwitch.isOn
        proxyStatusLabel.text = proxySwitch.isOn ? "已开启" : "未开启"
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 3 {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            
            // Set the label text.
            hud.label.text = "正在清除"
            ImageCache.default.clearDiskCache {
                hud.hide(animated: true)
                self.showMBText(message: "清除成功")
                self.cacheSizeLabel.text = nil
            }
        }
        
        if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                rateApp(appId: Constants.app_id)
            case 1:
                shareApp()
            case 2:
                sendEmail()
            default:
                break
            }
        }
        
        if indexPath.section == 5 {
            switch indexPath.row {
            case 0:
                openUrl(Constants.introduction_url)
            case 1:
                openUrl(Constants.privacy_policy_url)
            default:
                break
            }
        }
    }
    
    
    fileprivate func rateApp(appId: String) {
        openUrl("itms-apps://itunes.apple.com/app/id" + appId)
    }
    
    fileprivate func openUrl(_ urlString:String) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    fileprivate func shareApp() {
        let items: [Any] = ["汤博阅读-尽情浏览汤博乐上的精美图片", URL(string: Constants.introduction_url)!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        
        if let popOver = ac.popoverPresentationController {
            popOver.sourceView = self.view
            //popOver.sourceRect =
            //popOver.barButtonItem
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["secnettool@gmail.com"])
            mail.setSubject("汤博阅读反馈")
            
            present(mail, animated: true)
        } else {
            // show failure alert
            showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "不能发送邮件", message: "您的设备不能发送邮件，请查看邮件配置", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        sendMailErrorAlert.addAction(okAction)
        present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showLimitsVIew" {
            if let controller = segue.destination as? LimitTableViewController {
                controller.delegate = self
            }
            
        }
    }
    
    func refresh(limit: Int) {
        Defaults[.limit] = limit
        limitNumLabel.text = "\(limit)条"
    }
}
