//
//  TextTableViewCell.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/11.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
//import TagListView

class TextTableViewCell: UITableViewCell {
    
    let avatarImageView = UIImageView()
    let blogIdLabel = UILabel()
    
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    //let tagsView = TagListView()


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    func setUpUI()  {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.mainColor
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-12)
        }
        
        let headerView = UIView()
        containerView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(containerView)
            make.height.equalTo(60)
        }
        
        
        headerView.addSubview(avatarImageView)
        avatarImageView.backgroundColor = UIColor.black
        avatarImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(32)
            make.left.equalTo(headerView).offset(16)
            make.centerY.equalTo(headerView)
        }
        
        headerView.addSubview(blogIdLabel)
        blogIdLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatarImageView)
            make.left.equalTo(avatarImageView.snp.right).offset(8)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
