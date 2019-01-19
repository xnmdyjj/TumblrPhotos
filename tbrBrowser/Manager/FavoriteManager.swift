//
//  FavoriteManager.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/13.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class FavoriteManager {
    static let shareInstance = FavoriteManager()
    private init(){}
    
    func remove(blogId: String) {
        if let index = findIndex(blogId: blogId) {
             Defaults[.favoriteList].remove(at: index)
        }
    }
    
    func findIndex(blogId: String) -> Int? {
        let favoriteList = Defaults[.favoriteList]
        
        for (index, item) in favoriteList.enumerated() {
            if item.name == blogId {
                return index
            }
        }
        return nil
    }
    
    func add(blog: BlogCodable) {
        if let blogId = blog.name {
            if findIndex(blogId: blogId) == nil {
                Defaults[.favoriteList].append(blog)
            }
        }
    }
}
