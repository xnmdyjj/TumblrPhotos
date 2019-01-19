//
//  BlogHeaderView.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/11.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class BlogHeaderView: UIView {

    let avatarImageView = UIImageView()
    let titleLabel = UILabel()
    let desLabel = UILabel()
    //let copyRightLabel = UILabel()
    

    convenience init() {
        self.init(frame: CGRect.zero)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化变量
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 初始化变量
        
        setup()
    }
    
    
    func setup() {
        self.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(20)
            make.width.height.equalTo(64)
        }
        
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.left.equalTo(self).offset(16)
            //make.right.equalTo(self).offset(-16)
            make.width.equalTo(DeviceInfo.screenWidth - 32)
            //make.centerX.equalTo(avatarImageView)
        }
        
        desLabel.textColor = UIColor.white
        desLabel.numberOfLines = 0
        desLabel.font = UIFont.systemFont(ofSize: 14)
        desLabel.textAlignment = .center
        self.addSubview(desLabel)
        desLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(self).offset(16)
            //make.right.equalTo(self).offset(-16)
            make.width.equalTo(DeviceInfo.screenWidth - 32)
            make.bottom.equalTo(self).offset(-16)
        }
        
//        copyRightLabel.textColor = UIColor.white
//        copyRightLabel.text = "Tumblr 博客"
//        self.addSubview(copyRightLabel)
//        copyRightLabel.snp.makeConstraints { (make) in
//
//        }
    }
    
    func config(data: Blog) {
        
//        var background_color: String?
//        var body_font : String?
//        var title_color : String?
//        var title_font: String?
//        var title_font_weight : String?
        
        if let title_font = data.theme?.title_font, let title_font_weight = data.theme?.title_font_weight {
            let name = title_font + "-" + title_font_weight
            titleLabel.font = UIFont(name: name, size: 17)
        }
        
        if let title_color = data.theme?.title_color {
            titleLabel.textColor = UIColor(title_color)
            desLabel.textColor = UIColor(title_color)
        }
        
        if let body_font = data.theme?.body_font {
            desLabel.font = UIFont(name: body_font, size: 14)
        }
        
        titleLabel.text = data.title
        desLabel.text = data.des

        if let blogId = data.name {
            let avatarUrl = "https://api.tumblr.com/v2/blog/" + blogId + ".tumblr.com/avatar/128"
            if let url = URL(string: avatarUrl) {
                avatarImageView.kf.setImage(with: url)
            }
        }
        
        
//        let paragraph = NSMutableParagraphStyle()
//        paragraph.alignment = .center
//
//        let myAttribute = [NSAttributedString.Key.foregroundColor: titleLabel.textColor, NSAttributedString.Key.paragraphStyle: paragraph]
//
//        do {
//            if let des = data.des?.data(using: String.Encoding.unicode)  {
//                let attributedText = try NSMutableAttributedString(data: des, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//                attributedText.addAttributes(myAttribute as [NSAttributedString.Key : Any], range: NSRange(location: 0, length: attributedText.length))
//            }
//
//
//        } catch let e as NSError {
//            //print("Couldn't translate \(htmlText): \(e.localizedDescription) ")
//            print(e.localizedDescription)
//        }
    }
}
