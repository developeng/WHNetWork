//
//  DPBaseTargetType.swift
//  JAManager_jal
//
//  Created by developeng on 2020/3/19.
//  Copyright © 2020 developeng. All rights reserved.
//

import Foundation
import Moya

public typealias HTTPMethod = Moya.Method
public typealias MyValidationType = Moya.ValidationType
public typealias MySampleResponse = Moya.EndpointSampleResponse
public typealias MyStubBehavior = Moya.StubBehavior

public protocol DPBaseTargetType:TargetType {
    
    var isShowLoading: Bool { get }
    
}

extension DPBaseTargetType {
    public var base: String { return DPPublicService.shared.rootUrl}
    
    public var baseURL: URL { return URL(string: base)! }
    
    public var headers: [String : String]? {
        let dic = DPPublicService.shared.headers!
//        if WHUser.shared.userId == nil {
//            WHUser.shared.userId = UserDefaults.standard.object(forName: .kUserId) as? String
//        }
//        if WHUser.shared.userId?.count ?? 0 > 0 {
//            dic["Authorization"] = WHUser.shared.userId
//        }
        return dic }
    
    public var parameters: [String: Any]? { return DPPublicService.shared.parameters }
    
    public var isShowLoading: Bool { return true }
    
    public var task: Task {
        let encoding: ParameterEncoding
        switch self.method {
        case .post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }
        return .requestPlain
    }
    
    public var method: HTTPMethod {
        return .post
    }
    
    public var validationType: MyValidationType {
         return .successCodes
     }
    
    public var stubBehavior: StubBehavior {
        return .never
    }
    public var sampleData: Data {
        return "response: test data".data(using: String.Encoding.utf8)!
    }
    
    public var sampleResponse: MySampleResponse {
        return .networkResponse(200, self.sampleData)
    }
    
    
    
}
