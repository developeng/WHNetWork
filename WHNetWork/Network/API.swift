//
//  API.swift
//  WeiHong
//
//  Created by 赵朋 on 2021/5/12.
//
import Foundation


//图片处理
let imgPrefix = "https://qiniu.weihong777.com/"
func imageUrl(key:String?) ->String? {
    if key == nil {
        return nil
    }
    return imgPrefix + (key ?? "") + "?imageView2/0/w/200"
}
//默认头像
let defaultImg = "default_head"


public class API: NSObject {
    
    public static let shared = API()
    private override init() {}
    
    //环境选择
   public  struct EnvSelect {
        //MARK: - 注意 发布时，此处需要改为 isTest = false
        ///false 为生产， true 为测试（可切环境）
        static var isTest:Bool = true
        ///测试状态---首次安装默认的环境
        static let defaultEnv:NetworkEnvironment = .Test
        ///环境----测试时为切换环境，发布时为生产环境
        static let ENV:NetworkEnvironment = isTest ? defaultEnv : .Distribution
    }
    
    //MARK: - 服务器环境
    struct Prefix {
        //开发环境
        static var dev = "https://test.weihong777.cn/"
        //测试环境
        static var test = "https://test.weihong777.cn/"
        //预发布环境
        static var preRe = "http://172.19.2.245:9096/"
        //生产环境
        static var dis = "https://test.weihong777.cn/"
    }
    
    //MARK: - 模块
    struct Modular {
        //bapp
        static  let bapp = "bapp/"
    }
}

