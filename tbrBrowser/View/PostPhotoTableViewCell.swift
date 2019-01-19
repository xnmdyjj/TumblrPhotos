//
//  PostPhotoTableViewCell.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/11.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import TTGTagCollectionView

protocol PostPhotoTableViewCellDelegate: class {
    func photoTapped(row: Int, index: Int)
    func tagTapped(tag: String)
}

class PostPhotoTableViewCell: UITableViewCell {


    //let photoImageView = UIImageView()
    let photoView = PhotoContainerView()
    
    let summaryLabel = UILabel()
    let tagsView = TTGTextTagCollectionView()
    
    var rowIndex = 0
    weak var delegate: PostPhotoTableViewCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    func setUpUI()  {
        self.selectionStyle = .none
        //self.backgroundColor = UIColor.mainColor
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-12)
        }
        

        containerView.addSubview(tagsView)
        //tagsView.backgroundColor = UIColor.blue
        tagsView.delegate = self
        tagsView.numberOfLines = 1
        tagsView.scrollDirection = .horizontal
        tagsView.defaultConfig.textColor = UIColor.lightGray
        tagsView.defaultConfig.backgroundColor = UIColor.white
        tagsView.defaultConfig.textFont = UIFont.systemFont(ofSize: 12)
        tagsView.snp.makeConstraints { (make) in
            make.left.equalTo(containerView).offset(16)
            make.right.equalTo(containerView).offset(-16)
            make.height.equalTo(44)
            make.bottom.equalTo(containerView)
        }
        
        
        summaryLabel.font = UIFont.systemFont(ofSize: 14)
        summaryLabel.numberOfLines = 0
        containerView.addSubview(summaryLabel)
        summaryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(containerView).offset(16)
            make.right.equalTo(containerView).offset(-16)
            make.bottom.equalTo(tagsView.snp.top).offset(-16)
        }
        
        
//        photoImageView.isUserInteractionEnabled = true
//        photoImageView.kf.indicatorType = .activity
//        containerView.addSubview(photoImageView)
//        photoImageView.snp.makeConstraints { (make) in
//            make.left.right.equalTo(containerView)
//            make.top.equalTo(containerView)
//            make.bottom.equalTo(summaryLabel.snp.top).offset(-16)
//        }
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.photoTapped))
//        photoImageView.addGestureRecognizer(tapGesture)
        
        containerView.addSubview(photoView)
        photoView.delegate = self
        photoView.snp.makeConstraints { (make) in
            make.left.right.equalTo(containerView)
            make.top.equalTo(containerView)
            make.bottom.equalTo(summaryLabel.snp.top).offset(-16)
        }
    }
    
//    @objc func photoTapped() {
//        delegate?.photoTapped(row: rowIndex)
//    }
    
    func config(data: TagSearchResponse, row: Int) {
        rowIndex = row
    
        summaryLabel.text = data.summary
        
        tagsView.removeAllTags()
        tagsView.addTags(data.tags)
        
//        if let photoInfo = PostPhotoTableViewCell.choosePhoto(data: data, width: 400) {
//            if let photoUrl = photoInfo.url {
//                if let url = URL(string: photoUrl) {
//                    photoImageView.kf.setImage(with: url)
//                }
//            }
//        }
    
        photoView.config(photoset_layout: data.photoset_layout, photos: data.photos)
    }
    
//    class func choosePhoto(data: TagSearchResponse, width: Int) -> PhotoSize? {
//        if let photo = data.photos?.first {
//            if let items = photo.alt_sizes {
//                for item in items {
//                    if item.width == width || item.url?.contains("_\(width)") ?? false {
//                        return item
//                    }
//                }
//            }
//        }
//        return nil
//    }
//
    
    class func rowHeight(data: TagSearchResponse) -> CGFloat {
        
        let width = DeviceInfo.screenWidth - 32
        
        let summary = data.summary ?? ""
        let summaryHeight = summary.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 14))
        
//        var imageHeight:CGFloat = 0
        
//        if let photo = choosePhoto(data: data, width: 400) {
//            imageHeight = DeviceInfo.screenWidth * CGFloat(photo.height) / CGFloat(photo.width)
//        }
        
        let photoViewHeight = PhotoContainerView.getHeight(photoset_layout: data.photoset_layout, photos: data.photos)

        let cellSeperatorHeight: CGFloat = 12
        let summaryLabelTopAndBottomPadding: CGFloat = 32
        //let photoTopPadding: CGFloat = 16
        
        
        let rowHeight = 44 + summaryHeight + photoViewHeight + cellSeperatorHeight + summaryLabelTopAndBottomPadding
        
        return rowHeight
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

extension PostPhotoTableViewCell: TTGTextTagCollectionViewDelegate {
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        delegate?.tagTapped(tag: tagText)
    }
}

extension PostPhotoTableViewCell: PhotoContainerViewDelegate {
    func imageTapped(index: Int) {
        delegate?.photoTapped(row: rowIndex, index: index)
    }
}
