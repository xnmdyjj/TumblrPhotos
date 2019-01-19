//
//  PhotoSize.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/10.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import ObjectMapper

class PhotoSize: Mappable {
    
    var url: String?
    var width: Int = 0
    var height: Int = 0

    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        url    <- map["url"]
        width  <- map["width"]
        height <- map["height"]
    }
}
