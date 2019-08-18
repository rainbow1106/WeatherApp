//
//  ListModel.swift
//  JerryWeather
//
//  Created by 박병준 on 2019. 8. 7..
//  Copyright © 2019년 박병준. All rights reserved.
//

import Foundation
import MapKit

struct DPWeatherData{
    
    var idx = 0
    var locationName: String
    var temperature: String?
    var isCurrentLocation: Bool
    var weatherDesc: String
    
    var location = CLLocation()
    init() {
        self.locationName = ""
        self.isCurrentLocation = false
        self.weatherDesc = ""
    }
}

enum ListModel
{
    // MARK: Use cases
    
    enum FetchWeather
    {
        struct Request{
            
        }
        struct Response{
            var rawWeatherDic: [String : Any]
        }
        struct ViewModel{
            
            var viewData: DPWeatherData
            
        }
    }
}
