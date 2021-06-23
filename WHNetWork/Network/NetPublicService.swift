//
//  DPPublicService.swift
//  JAManager_jal
//
//  Created by developeng on 2020/3/19.
//  Copyright © 2020 developeng. All rights reserved.
//

import UIKit
import Foundation

//服务器环境
enum NetworkEnvironment:NSInteger{
    case Development  = 1//开发环境
    case Test         = 2//测试环境
    case Distribution = 3//生产环境
}
//本地存储服务器环境key
let select_environment  = "select.environment.com"
//服务器地址()
private var kApiPrefix = ""
//当前默认的环境
var currentEnvironment : NetworkEnvironment = API.EnvSelect.isTest ? (NetworkEnvironment(rawValue: UserDefaults.standard.integer(forKey: select_environment)) ?? API.EnvSelect.ENV ):.Distribution

class DPPublicService: NSObject {
    
    var rootUrl: String = getCurrentNetwork()
    var headers: [String: String]? = defaultHeaders()
    var parameters: [String: Any]? = defaultParameters()
    var timeoutInterval: Double = 20.0
    
    static let shared = DPPublicService()
    private override init() {}
    
    static func getCurrentNetwork(network : NetworkEnvironment = currentEnvironment) -> String{
        if network == .Development {
            kApiPrefix = API.Prefix.dev
        } else if network == .Test {
            kApiPrefix = API.Prefix.test
        } else {
            kApiPrefix = API.Prefix.dis
        }
        return kApiPrefix;
    }
    
    static func defaultHeaders() -> [String : String]? {
        return ["Content-type":"application/json"] as [String : String]
    }
    
    static func defaultParameters() -> [String : Any]? {
//        return ["platform" : "ios",
//                "version" : "1.2.3",
//        ]
        return nil
    }
}
