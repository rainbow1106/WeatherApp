//
//  DetailModel.swift
//  JerryWeather
//
//  Created by 박병준 on 8/18/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import Foundation
import MapKit

struct DetailHourData {
    
    var temperature: String = ""
    var time: String = ""
    var hourSummary = ""
    
}

struct DetailDailyData {
    var dayText = ""
    var maxTemperature: String = ""
    var minTemperature: String = ""
    var dailySummary: String = ""
}
struct DetailWeatherData{
    
    var locationName: String = ""
    var idx: Int = 0
    
    var hourDataList = [DetailHourData]()
    var dailyDataList = [DetailDailyData]()
    
    var timeText = ""
    var summary: String = ""
    var temperature: String = ""
    var detailDesc: String = ""
    var sunRise: String = ""
    var sunDown: String = ""
    var maxTemperature: String = ""
    var minTemperature: String = ""
    var apTemperature: String = ""
    var humid: String = ""
    var wind: String = ""
    var visibleDistance: String = ""
    var pressure: String = ""
    var uv: String = ""
}

enum DetailModel{
    // MARK: Use cases
    
    enum FetchDetail
    {
        struct Request{
            var location: CLLocation
        }
        struct Response{
            var rawDetailDic: [String : Any]
        }
        struct ViewModel{
            
            var viewData: DetailWeatherData
            
        }
    }
}
