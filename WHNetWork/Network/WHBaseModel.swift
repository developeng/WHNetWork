//
//  WHBaseModel.swift
//  WeiHong
//
//  Created by 赵朋 on 2021/5/20.
//


import UIKit
import HandyJSON

class WHBaseModel: NSObject, HandyJSON {
        
    var statusCode:Int?
    var data: Any?
    var statusMsg:String?
    
    required override init() {}
    
        func mapping(mapper: HelpingMapper) {   //自定义解析规则，日期数字颜色，如果要指定解析格式，子类实现重写此方法即可
    //        mapper <<<
    //            date <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd")
    //
    //        mapper <<<
    //            decimal <-- NSDecimalNumberTransform()
    //
    //        mapper <<<
    //            url <-- URLTransform(shouldEncodeURLString: false)
    //
    //        mapper <<<
    //            data <-- DataTransform()
    //
    //        mapper <<<
    //            color <-- HexColorTransform()
          }
    /**
     *  数据（String or Dictionary）转模型
     */
    static func objectToModel(_ object:Any,_ modelType:HandyJSON.Type) -> WHBaseModel{
        
        if object is String {
            if (object as! String) == "" || (object as! String).count == 0 {
                #if DEBUG
                print("object:字符串为空")
                #endif
                return WHBaseModel()
            }
            return modelType.deserialize(from: (object as! String))  as! WHBaseModel
        }
        
        if (object as AnyObject).count == 0 {
            #if DEBUG
                print("object 字典为空")
            #endif
            return WHBaseModel()
        }
        return modelType.deserialize(from: (object as! JSONDictionary)) as! WHBaseModel
    }
    /**
     *  数据（数组json串 or [Dictionary]数组）转模型数组
     */
    static func objectArrToModelArr(_ object:Any,_ modelType:HandyJSON.Type) -> [WHBaseModel]{
        if object is String {
           if (object as! String) == "" || (object as! String).count == 0 {
                #if DEBUG
                print("object:字符串为空")
                #endif
                return []
            }
            var modelArray:[WHBaseModel] = []
            let data = (object as! String).data(using: String.Encoding.utf8)
            let jsonArray = try! JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
            for jsonModel in jsonArray! {
                modelArray.append(objectToModel(jsonModel as! [String : Any], modelType))
            }
            return modelArray
        }
        
        if (object as AnyObject).count == 0 {
            #if DEBUG
                print("object:数组为空")
            #endif
            return []
        }
        var modelArray:[WHBaseModel] = []
        let data = try? JSONSerialization.data(withJSONObject: object, options: [])
        let jsonArray = try! JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
        for jsonObject in jsonArray! {
            modelArray.append(objectToModel(jsonObject as! [String : Any], modelType))
        }
        return modelArray
    }
    
    /**
     *  获取模型对应的字符串
     */
    static func modelToJsonStr(_ model:WHBaseModel?) -> String {
        if model == nil {
            #if DEBUG
                print("modelToJsonStr:model为空")
            #endif
             return ""
        }
        return (model?.toJSONString())!
    }
    
    /**
     *  获取模型对应的字典
     */
    static func modelToDict(_ model:WHBaseModel?) -> [String:Any] {
        if model == nil {
            #if DEBUG
                print("modelToDict:model为空")
            #endif
            return [:]
        }
        return (model?.toJSON())!
    }
    
    /**
     *  获取模型数组对应的字典数组
     */
    static func modelArrToDictArr(_ modelArr:[WHBaseModel]?) -> [[String:Any]] {
        if modelArr == nil || modelArr?.count == 0 {
            #if DEBUG
                print("modelArrToDictArr:model数组为空")
            #endif
            return [[:]]
        }
        var jsonArr:[[String:Any]] = []
        for model in modelArr! {
            jsonArr.append(modelToDict(model))
        }
        return jsonArr
    }
}


class JsonDeserializer<T: HandyJSON>{
    public static func deserializeFrom(dict: [String: Any]?) -> T? {
        let targetDict = dict
        if targetDict != nil {
            let responseModel = JSONDeserializer<T>.deserializeFrom(dict: dict)
            return responseModel
        }
        return nil
    }
    
    public static func deserializeFrom(arr: [Any]?) -> [T?]? {
        let targetArr = arr
        if targetArr != nil {
            let arr = JSONDeserializer<T>.deserializeModelArrayFrom(array: targetArr)
            return arr
        }
        return nil
    }
}
