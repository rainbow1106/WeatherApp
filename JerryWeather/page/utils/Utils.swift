//
//  Utils.swift
//  JerryWeather
//
//  Created by 박병준 on 8/11/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import Foundation


final class Utils{
    
    class func makeApiURL(restUrl: String?) -> URL?{
        
        guard let uUrl = restUrl else{
            return nil
        }
    
        var rawUrl = "\(JWAUrePrefix)/forecast/\(JWAApiSecretKey)/\(uUrl)"
        if rawUrl.contains("?"){
            rawUrl.append("&lang=ko&units=si")
        }else{
            rawUrl.append("?lang=ko&units=si")
        }
        
        guard let finalUrl = URL(string: rawUrl) else{
            return nil
        }
        
        return finalUrl
    }
    
    class func makeRawDic(pData: Data?) -> [String : Any]?{
        
        guard  let uData = pData,
            let jsonDic = try? JSONSerialization.jsonObject(with: uData, options: JSONSerialization.ReadingOptions.allowFragments),
            let uJsonDic = jsonDic as? [String : Any] else{
                
                return nil
        }
        
        return uJsonDic
    }
    class func showJsonPretty(pDic: [String : Any]){
        
        guard let json = try? JSONSerialization.data(withJSONObject: pDic, options: .prettyPrinted),
            let jsonText = String(bytes: json, encoding: String.Encoding.utf8) else {
                
                return
        }
        print()
        print(jsonText)
        print()
    }
    
    
}
