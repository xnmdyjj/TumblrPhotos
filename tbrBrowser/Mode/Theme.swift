//
//  Theme.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/11.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import ObjectMapper

class Theme: Mappable {
    
    var background_color: String?
    var body_font : String?
    var title_color : String?
    var title_font: String?
    var title_font_weight : String?
    
    init(background_color: String?, body_font: String?, title_color: String?, title_font: String?, title_font_weight: String?) {
        self.background_color = background_color
        self.body_font = body_font
        self.title_color = title_color
        self.title_font = title_font
        self.title_font_weight = title_font_weight
    }
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        background_color    <- map["background_color"]
        body_font  <- map["body_font"]
        
        title_color    <- map["title_color"]
        title_font  <- map["title_font"]
        title_font_weight    <- map["title_font_weight"]
    }
    
}
