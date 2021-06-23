//
//  NetworkTool.swift
//  JAManager_jal
//
//  Created by developeng on 2020/3/16.
//  Copyright © 2020 developeng. All rights reserved.
//

import Foundation
import UIKit
import Moya
import Alamofire
import HandyJSON
import MCToast
import WHBaseControl

///网络请求封装
//数据
typealias JSONDictionary = [String: Any]

/// 定义返回的JSON数据字段
let RESULT_CODE = "statusCode"      //状态码
let RESULT_MESSAGE = "statusMsg"  //消息提示


public let WHNet = NetworkTool.shared

///成功数据回调
typealias Success = ((_ response:WHBaseModel) -> ())
///失败的回调
typealias Failure = ((_ failure: NetworkingError) -> ())
///请求错误回调
typealias ErrorBlock = ((_ errorMsg: String) -> ())


public class NetworkTool {
    
    public static let shared = NetworkTool()
}

//        var params:[String:Any] = Dictionary()
//        params["phoneNumber"] = "13520600515"
//        params["captcha"] = "14701"
//        params["clientType"] = "2"
//
//
//        WHNet.request(APILogin.authToken(params), success:  { baseModel in
//
//            if let response = (baseModel.data as? JSONDictionary) {
//                let token:String = response["token"] as! String
//                DPUser.sharedInstance.token = token
//            }
//        })
extension NetworkTool{
    @discardableResult //当我们需要主动取消网络请求的时候可以用返回值Cancellable, 一般不用的话做忽略处理
    func request(_ target: DPBaseTargetType, success: Success? = nil, failed:Failure? = nil, errorBlock:ErrorBlock? = nil) -> Cancellable? {
        //先判断网络是否有链接 没有的话直接返回--代码略
        if !isNetworkConnect{
            
            WHToast.show_Toast("当前网络不可用");
            
            return nil
        }
        
        //这里显示loading图
        if target.isShowLoading {
            WHToast.showAnimated()
        }
        return defaultProvider.request(MultiTarget(target)) { (result) in
            //隐藏hud
            if target.isShowLoading {
                WHToast.hideAnimated()
            }
            print("请求结果\(result)")
            switch result {
            case let .success(response):
                // 响应数据解析成JSONDictionary
                guard let jsonObject = try? response.mapJSON() as? JSONDictionary else {
                    
                    WHToast.show_Toast("非正确的json格式");
                    
//                    if failed != nil {
//                        failed!(.jsonMapping(response))
//                    }
                    return
                }
                let jsonData:String! = String(data: response.data, encoding: String.Encoding.utf8)
                let model:WHBaseModel = WHBaseModel.objectToModel(jsonData as Any, WHBaseModel.self);
                
                print(model.toJSONString(prettyPrint: true)!)
                // 数据请求错误
                if let code = model.statusCode {
                    if code != 200 {
                        WHToast.show_Toast(jsonObject[RESULT_MESSAGE] as? String);
                        if failed != nil {
                            failed?(NetworkingError(code: model.statusCode ?? -1, desc: model.statusMsg ?? ""))
                        }
                        return
                    }
                }
                if success != nil {
                    success?(model)
                }
            case let .failure(error):
                //网络连接失败，提示用户
                print("网络连接失败\(error)")
                WHToast.show_Toast(error.errorDescription);
                
                if errorBlock != nil {
                    errorBlock?(error.errorDescription ?? "")
                }
            }
        }
    }
}
///网络请求的基本设置，这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
let myEndpointClosure = { (target: TargetType) -> Endpoint in
    ///这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    let defaultEncoding = URLEncoding.default
    
    switch target.task {
    case .requestParameters(var parameters, let encoding):
        print("参数：\(parameters)")
        //此处也可添加公参
        task = .requestParameters(parameters: parameters, encoding: encoding)
    default:
        break
    }
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    return endpoint
}


let myRequestClosure = {(endpoint: Endpoint, closure: MoyaProvider<MultiTarget>.RequestResultClosure) -> Void in
    
    do {
        var request = try endpoint.urlRequest()
        //请求时长
        request.timeoutInterval = DPPublicService.shared.timeoutInterval
        
        // 打印请求参数
        if let requestData = request.httpBody {
            print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
            
            print("\(endpoint.httpHeaderFields!)")
        }else{
            print("\(request.url!)"+"\(String(describing: request.httpMethod))")
            print("\(endpoint.httpHeaderFields!)")
        }
        closure(.success(request))
    } catch {
        closure(.failure(MoyaError.underlying(error, nil)))
    }
}

/// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
///但这里我没怎么用这个。。。 loading的逻辑直接放在网络处理里面了

let myPlugins = NetworkActivityPlugin { (type, target) in
    switch type {
    case .began:
        print("开始请求接口")
    case .ended:
        print("请求结束")
    }
}

////网络请求发送的核心初始化方法，创建网络请求对象

let defaultProvider =
    MoyaProvider<MultiTarget>(
        endpointClosure: myEndpointClosure,
        requestClosure: myRequestClosure,
        plugins: [myPlugins]);


/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用get方法是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
var isNetworkConnect: Bool {
    get{
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true //无返回就默认网络已连接
    }
}
