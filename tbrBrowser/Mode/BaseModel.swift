//
//  BaseModel.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/10.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import ObjectMapper

class Meta: Mappable {
    var status = 0
    var msg = ""
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        status    <- map["status"]
        msg  <- map["msg"]
    }
    
}

class BaseModel: Mappable {
    var meta: Meta?
    var response: Any?
    
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        meta    <- map["meta"]
        response  <- map["response"]
    }
}
