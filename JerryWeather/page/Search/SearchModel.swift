//
//  SearchModel.swift
//  JerryWeather
//
//  Created by 박병준 on 8/15/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import Foundation

struct DPSearchData{
    
    var locationName: String
    
    init() {
        self.locationName = ""
    }
}

enum SearchModel{
    // MARK: Use cases
    
    enum FetchSearch
    {
        struct Request{
            
        }
        struct Response{
            var rawSerchDic: [String : Any]
        }
        struct ViewModel{
            
            var viewData: DPSearchData
            
        }
    }
}
