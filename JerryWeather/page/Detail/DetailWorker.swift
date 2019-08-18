//
//  DetailWorker.swift
//  JerryWeather
//
//  Created by 박병준 on 8/18/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import Foundation
import MapKit

final class DetailWorker{
    
    lazy var session = URLSession.shared
    
    func getCityName(location: CLLocation,
                     completion: @escaping (String) -> Void,
                     fail: @escaping () -> Void){
        
        let geoCoder = CLGeocoder()
        geoCoder
            .reverseGeocodeLocation(location) { (markList, rError) in
                
                guard let marker = markList?.first else{
                    fail()
                    return
                }
                
                var cityName = ""
                if let uCity = marker.administrativeArea{
                    cityName = uCity
                }
                var subLocationName = ""
                if let uSub = marker.locality{
                    subLocationName = uSub
                }
                var subLocality = ""
                if let uSubDetail = marker.subLocality{
                    subLocality = uSubDetail
                }
                let rName = "\(cityName) \(subLocationName) \(subLocality)"
                completion(rName)
        }
    }
    
    
    // 해당 지역 날씨정보 가져오기
    func loadWeatherData(location: CLLocation,
                         success: @escaping ([String : Any]) -> Void,
                         fail: @escaping () -> Void){
        
        
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        let rawUrl = "\(lat),\(lon)?exclude=[minutely]"
        guard let url = Utils.makeApiURL(restUrl: rawUrl) else{
            fail()
            return
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.allowsCellularAccess = true
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = session.dataTask(with: req) { (data, response, error) in
            
            guard error == nil else{
                fail()
                return
            }
            
            guard let rDic = Utils.makeRawDic(pData: data) else{
                fail()
                return
            }
            
            //            Utils.showJsonPretty(pDic: rDic)
            success(rDic)
        }
        
        task.resume()
    }
    
    func parseListData(listModel: DetailModel.FetchDetail.Response,
                       idx: Int,
                       cityName: String) -> DetailModel.FetchDetail.ViewModel{
        
        let pDic = listModel.rawDetailDic
        
        var rData = DetailWeatherData()
        
        rData.locationName = cityName
        rData.idx = idx
        
        //
        let currentDic = pDic["currently"] as? [String : Any]
        
        if let uSummary = currentDic?["summary"] as? String{
            rData.summary = uSummary
        }
        if let uTemp = currentDic?["temperature"] as? Double{
            let uTempText = String(format: "%.1f", uTemp)
            rData.temperature = uTempText
        }
        if let uTime = currentDic?["time"] as? Double{
            
            let date = Date.init(timeIntervalSince1970: uTime)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "EEEE"
            let text = formatter.string(from: date)
            
            rData.timeText = text
            
        }
        
        //
        let daily = pDic["daily"] as? [String : Any]
        
        if let uDetailSummary = daily?["summary"] as? String{
            rData.detailDesc = uDetailSummary
        }
        
        let dailyFirst = (daily?["data"] as? [[String : Any]])?.first
        
        if let uMax = dailyFirst?["temperatureMax"] as? Double{
            let uTempText = String(format: "%.1f", uMax)
            rData.maxTemperature = uTempText
        }
        if let uMin = dailyFirst?["temperatureMin"] as? Double{
            let uTempText = String(format: "%.1f", uMin)
            rData.minTemperature = uTempText
        }
        
        if let sunRise = dailyFirst?["sunriseTime"] as? Double{
            let date = Date.init(timeIntervalSince1970: sunRise)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH : mm"
            let text = formatter.string(from: date)
            
            rData.sunRise = text
        }
        
        if let sunDown = dailyFirst?["sunsetTime"] as? Double{
            let date = Date.init(timeIntervalSince1970: sunDown)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH : mm"
            let text = formatter.string(from: date)
            
            rData.sunDown = text
        }
        
        if let aptemp = currentDic?["apparentTemperature"] as? Double{
            let uTempText = String(format: "%.1f", aptemp)
            rData.apTemperature = uTempText
        }
        
        
        if let humid = currentDic?["humidity"] as? Double{
            
            let uTempText = String(format: "%.1f%", humid * 100)
            rData.humid = uTempText
        }
        
        if let wind = currentDic?["windSpeed"] as? Double{
            let uTempText = String(format: "%.1fm/s", wind)
            rData.wind = uTempText
        }
        
        if let vision = currentDic?["visibility"] as? Double{
            let uTempText = String(format: "%.1fkm", vision)
            rData.visibleDistance = uTempText
        }
        
        if let press = currentDic?["pressure"] as? Double{
            let uTempText = String(format: "%.1fhPa", press)
            rData.pressure = uTempText
        }
        if let uv = currentDic?["uvIndex"] as? Int{
            rData.uv = "\(uv)"
        }
        
        if let dailyList = daily?["data"] as? [[String : Any]]{
            rData.dailyDataList = self.parseDaily(pDic: dailyList)
        }
        
        let hourDic = pDic["hourly"] as? [String : Any]
        if let hourList = hourDic?["data"] as? [[String : Any]]{
            rData.hourDataList = self.parseHour(pDic: hourList)
        }
        let result = DetailModel.FetchDetail.ViewModel.init(viewData: rData)
        
        return result
    }
    
    private func parseDaily(pDic: [[String : Any]]) -> [DetailDailyData]{
        
        var rDataList = [DetailDailyData]()
        
        let rDicList = pDic.sorted { (prev, next) -> Bool in
            
            guard let first = prev["time"] as? Double,
                let sec = next["time"] as? Double else{
                    return true
            }
            return first < sec
        }
        
        
        for subDic in rDicList{
            
            var rData = DetailDailyData()
            
            if let time = subDic["time"] as? Double{
             
                let date = Date.init(timeIntervalSince1970: time)
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ko_KR")
                formatter.dateFormat = "EEEE"
                let text = formatter.string(from: date)
                
                rData.dayText = text
            }
            
            if let max = subDic["temperatureMax"] as? Double{
                let uTempText = String(format: "%.1f", max)
                rData.maxTemperature = uTempText
            }
            
            if let min = subDic["temperatureMin"] as? Double{
                let uTempText = String(format: "%.1f", min)
                rData.minTemperature = uTempText
            }
            
            if let icon = subDic["icon"] as? String{
                rData.dailySummary = self.parseIcon(icon: icon)
            }
            //
            rDataList.append(rData)
        }
        
        return rDataList
    }
    private func parseIcon(icon: String) -> String{
        
        switch icon {
        case "clear-day":
            return "맑음"
            
        case "clear-night":
            return "맑은 밤"
            
        case "rain":
            return "비"
            
        case "snow":
            return "눈"
            
        case "sleet":
            return "진눈깨비"
            
        case "wind":
            return "바람"
            
        case "fog":
            return "안개"
            
        case "cloudy":
            return "구름"
            
        case "partly-cloudy-night":
            return "흐린 밤"
            
        case "partly-cloudy-day":
            return "흐림"
        default:
            return ""
        }
        
    }
    private func parseHour(pDic: [[String : Any]]) -> [DetailHourData]{
        
        var rDataList = [DetailHourData]()
        
        let rDicList = pDic.sorted { (prev, next) -> Bool in
            
            guard let first = prev["time"] as? Double,
                let sec = next["time"] as? Double else{
                    return true
            }
            return first < sec
        }
        for subDic in rDicList{
            
            var rData = DetailHourData()
            
            if let time = subDic["time"] as? Double{
                let date = Date.init(timeIntervalSince1970: time)
                let formatter = DateFormatter()
                formatter.dateFormat = "HH"
                let text = formatter.string(from: date)
                rData.time = text
            }
            
            if let uTemp = subDic["temperature"] as? Double{
                let uTempText = String(format: "%.1f", uTemp)
                rData.temperature = uTempText
            }
            
            if let icon = subDic["icon"] as? String{
                rData.hourSummary = self.parseIcon(icon: icon)
            }
            
            rDataList.append(rData)
            
        }
        
        var first = rDataList.removeFirst()
        first.time = "지금"
        rDataList.insert(first, at: 0)
        
        return rDataList
    }
    
    
    func sortDataList(dataList: [DetailWeatherData]) -> [DetailWeatherData]{
        
        let sortedList = dataList.sorted { (prev, next) -> Bool in
            prev.idx < next.idx
        }
        return sortedList
        
    }
}
