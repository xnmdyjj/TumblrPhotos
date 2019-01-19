//
//  FrogCodable.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/13.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

final class BlogCodable: Codable, DefaultsSerializable  {
    var name: String?
    var title: String?
    var des: String?
    
    var background_color: String?
    var body_font: String?
    var title_color : String?
    var title_font : String?
    var title_font_weight: String?
    
    init(blog: Blog) {
        self.name = blog.name
        self.title = blog.title
        self.des = blog.des
        
        self.background_color = blog.theme?.background_color
        self.body_font = blog.theme?.body_font
        self.title_color = blog.theme?.title_color
        self.title_font = blog.theme?.title_font
        self.title_font_weight = blog.theme?.title_font_weight
    }
}
