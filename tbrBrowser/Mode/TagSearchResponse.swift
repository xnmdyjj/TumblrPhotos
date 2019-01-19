//
//  TagSearchResponse.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/10.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import UIKit
import ObjectMapper

class TagSearchResponse: Mappable {
    var type: String?
    var blog_name: String?
    var blog: Blog?
    
    var post_url: String?
    var date: String?
    var timestamp: TimeInterval?
    var state: String?
    //var format: String?
    //var reblog_key: String?
    
    var tags: [String] = []

    var short_url: String?
    
    var summary: String?
    var caption: String?
    var image_permalink: String?
    
    var photoset_layout: String?
    
    var photos: [Photo]?
    
    //text
    var title: String?
    var body:String?
    
    var trail: [Trail]?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        type    <- map["type"]
        blog_name <- map["blog_name"]
        blog      <- map["blog"]
        post_url   <- map["post_url"]
        date  <- map["date"]
        timestamp  <- map["timestamp"]
        state     <- map["state"]

        tags  <- map["tags"]
        short_url     <- map["short_url"]
        
        summary  <- map["summary"]
        caption     <- map["caption"]
        image_permalink  <- map["image_permalink"]
        photos     <- map["photos"]
        photoset_layout <- map["photoset_layout"]
        //text
        title     <- map["title"]
        body     <- map["body"]
        
        trail     <- map["trail"]

    }

}
