//
//  Trail.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/11.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import ObjectMapper

class Trail: Mappable {
    
    var blog: Blog?

    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        blog    <- map["blog"]

    }
}
