//
//  Blog.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/10.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import ObjectMapper

class Blog: Mappable { 
    
    var name: String?
    var title: String?
    var des: String?
    var url: String?
    var uuid: String?
    
    var theme: Theme?
    
    init(blog: BlogCodable) {
        self.name = blog.name
        self.title = blog.title
        self.des = blog.des
        
        self.theme = Theme(background_color: blog.background_color, body_font: blog.body_font, title_color: blog.title_color, title_font: blog.title_font, title_font_weight: blog.title_font_weight)
    }
    
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        name    <- map["name"]
        title <- map["title"]
        des <- map["description"]
        url      <- map["url"]
        uuid   <- map["uuid"]
        
        theme   <- map["theme"]
    }
}
