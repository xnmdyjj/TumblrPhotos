//
//  DefaultsKeysExt.swift
//  tbrBrowser
//
//  Created by 喻建军 on 2018/12/12.
//  Copyright © 2018 Jianjun Yu. All rights reserved.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    static let isUseProxy = DefaultsKey<Bool>("isUseProxy")
    static let limit = DefaultsKey<Int>("limit", defaultValue: 20)
    static let favoriteList = DefaultsKey<[BlogCodable]>("favoriteList", defaultValue: [])
}
