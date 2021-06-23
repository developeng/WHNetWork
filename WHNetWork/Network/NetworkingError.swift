//
//  NetworkingError.swift
//  WeiHong
//
//  Created by 赵朋 on 2021/5/12.
//

import UIKit

class NetworkingError: NSObject {
    /// 错误码
    @objc var code = -1
    /// 错误描述
    @objc var message: String

    init(code: Int, desc: String) {
        self.code = code
        self.message = desc
        super.init()
    }
}
