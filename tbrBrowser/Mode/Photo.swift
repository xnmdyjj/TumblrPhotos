//
//  Photo.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/10.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import ObjectMapper

class Photo: Mappable {
    var caption: String?
    var original_size: PhotoSize?
    var alt_sizes: [PhotoSize]?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        caption    <- map["caption"]
        original_size <- map["original_size"]
        alt_sizes      <- map["alt_sizes"]
    }
}
