//
//  PhotoContainerView.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/15.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit

protocol PhotoContainerViewDelegate: class {
    func imageTapped(index: Int)
}

class PhotoContainerView: UIView {
    
    weak var delegate: PhotoContainerViewDelegate?

    var imageViewArray: [UIImageView] = []
    
    convenience init(photoset_layout: String?) {
        self.init(frame: CGRect.zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        for i in 0 ..< kImageCountMax {
            let imageView = UIImageView()
            imageView.tag = i
            imageView.isUserInteractionEnabled = true
            self.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.width.equalTo(0)
                make.height.equalTo(0)
            }
            imageViewArray.append(imageView)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapImage(_:)))
            imageView.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func tapImage(_ sender: UITapGestureRecognizer) {
        print("Please Help!")
        if let view = sender.view {
            delegate?.imageTapped(index: view.tag)
        }
    }
    
    let horizontalInterval:CGFloat = 8
    let verticalInterval:CGFloat = 8
    let kImageCountMax = 20
    
    func config(photoset_layout: String?, photos:[Photo]?) {
        guard let thePhotos = photos else {
            return
        }
        
        for i in 0 ..< thePhotos.count {
            let imageView = imageViewArray[i]
            imageView.isHidden = false
        }
        
        for j in thePhotos.count ..< kImageCountMax {
            let imageView = imageViewArray[j]
            imageView.isHidden = true
        }
        
        guard let layout = photoset_layout else {
            let imageView = imageViewArray[0]
            let imageWidth = DeviceInfo.screenWidth
            let imageHeight:CGFloat = PhotoContainerView.getImageHeight(photo: thePhotos[0], imageWidth: imageWidth)

            imageView.snp.updateConstraints { (make) in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)
            }
            if let photoInfo = PhotoContainerView.choosePhoto(photo: thePhotos[0]) {
                if let photoUrl = photoInfo.url {
                    if let url = URL(string: photoUrl) {
                        imageView.kf.setImage(with: url)
                    }
                }
            }
            return
        }
        
        
        let row = layout.charactersArray.count
        let columnArray = layout.charactersArray
        
        var topOffset: CGFloat  = 0
        for i in 0 ..< row {
            let column = columnArray[i].int!
            let imageWidth = (DeviceInfo.screenWidth - horizontalInterval * (CGFloat(column) - 1))/CGFloat(column)
            var sum = 0
            for m in 0 ..< i {
                sum = sum + columnArray[m].int!
            }
            let imageHeight = PhotoContainerView.getImageHeight(photo: thePhotos[sum], imageWidth: imageWidth)
            for j in 0 ..< column {
                let index = sum + j
                let leftOffset = CGFloat(j) * (imageWidth + horizontalInterval)
                let imageView = imageViewArray[index]
                imageView.snp.updateConstraints { (make) in
                    make.top.equalTo(self).offset(topOffset)
                    make.left.equalTo(self).offset(leftOffset)
                    make.width.equalTo(imageWidth)
                    make.height.equalTo(imageHeight)
                }
                if let photoInfo = PhotoContainerView.choosePhoto(photo: thePhotos[index]) {
                    if let photoUrl = photoInfo.url {
                        if let url = URL(string: photoUrl) {
                            imageView.kf.setImage(with: url)
                        }
                    }
                }
            }
            topOffset = topOffset + imageHeight + verticalInterval
        }
    }
    
    class func getHeight(photoset_layout: String?, photos:[Photo]?) -> CGFloat {
        
        let hInterval:CGFloat = 8
        let vInterval:CGFloat = 8
        
        guard let thePhotos = photos else {
            return 0
        }
        guard let layout = photoset_layout else {
            let height = PhotoContainerView.getImageHeight(photo: thePhotos[0], imageWidth: DeviceInfo.screenWidth)
            return height
        }
        
        let row = layout.charactersArray.count
        let columnArray = layout.charactersArray
        
        var topOffset: CGFloat  = 0
        for i in 0 ..< row {
            let column = columnArray[i].int!
            let imageWidth = (DeviceInfo.screenWidth - hInterval * (CGFloat(column) - 1))/CGFloat(column)
            var sum = 0
            for m in 0 ..< i {
                sum = sum + columnArray[m].int!
            }
            let imageHeight = PhotoContainerView.getImageHeight(photo: thePhotos[sum], imageWidth: imageWidth)
            
            topOffset = topOffset + imageHeight + vInterval
        }
        
        let height = topOffset - vInterval
        return height
    }

    
    private class func choosePhoto(photo:Photo) -> PhotoSize? {
        var width = 400
        if  UIDevice.current.userInterfaceIdiom == .pad {
            width = 640
        }
        if let items = photo.alt_sizes {
            for item in items {
                if item.width == width || item.url?.contains("_\(width)") ?? false {
                    return item
                }
            }
        }
        return photo.original_size
    }
    
    private class func getImageHeight(photo:Photo, imageWidth: CGFloat) -> CGFloat {
        var imageHeight:CGFloat = 0
        
        if let photoSize = PhotoContainerView.choosePhoto(photo: photo) {
            imageHeight = imageWidth * CGFloat(photoSize.height) / CGFloat(photoSize.width)
        }
        
        return imageHeight
    }
    
}
