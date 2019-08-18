//
//  ListWorker.swift
//  JerryWeather
//
//  Created by 박병준 on 2019. 8. 7..
//  Copyright © 2019년 박병준. All rights reserved.
//

import Foundation
import MapKit


final class ListWorker: NSObject{
    
    lazy var session = URLSession.shared
    
    var task = URLSessionTask()
    var currentTask = URLSessionTask()
    
    
    // 저장된 지역 목록 가져오기
    func getLocalList() -> [CLLocation]{
        
        var resultList = [CLLocation]()
        
        guard var uList = UserDefaults.standard.array(forKey: JWAStoredLocationKey) as? [String] else{
            return resultList
        }
        
        uList = uList.sorted(by: { (prev, next) -> Bool in
            
            guard let front = prev.components(separatedBy: ",").first,
                let behind = next.components(separatedBy: ",").first else{
                    return true
            }
            
            return front < behind
            
        })
        
        for item in uList{
            
            let tempList = item.components(separatedBy: ",")
            guard tempList.count == 3 else{
                continue
            }
            
            guard let lat = Double(tempList[1]),
                let lon = Double(tempList[2]) else{
                    continue
            }
            let location = CLLocation(latitude: lat, longitude: lon)
            resultList.append(location)
            
        }
        
        return resultList
        
    }
    
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
    func parseListData(listModel: ListModel.FetchWeather.Response,
                       location: CLLocation,
                       isCurrentLocation: Bool,
                       idx: Int,
                       cityName: String) -> ListModel.FetchWeather.ViewModel{

        let pDic = listModel.rawWeatherDic
        let current = pDic["currently"] as? [String : Any]
        var rData = DPWeatherData()

        rData.isCurrentLocation = isCurrentLocation
        rData.locationName = cityName
        if let temperature = current?["temperature"] as? Double{
            rData.temperature = String(format: "%.1f", temperature)
        }
        
        if let uDesc = current?["summary"] as? String{
            rData.weatherDesc = uDesc
        }
        
        rData.idx = idx
        rData.location = location
        
        let result = ListModel.FetchWeather.ViewModel(viewData: rData)
        
        return result
    }
    
    // 해당 지역 날씨정보 가져오기
    func loadWeatherData(location: CLLocation,
                         isCurrentLocation: Bool = false,
                         success: @escaping ([String : Any]) -> Void,
                         fail: @escaping () -> Void){
        
        
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        let rawUrl = "\(lat),\(lon)?exclude=[minutely,hourly,daily]"
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
        
        if isCurrentLocation{
//            self.currentTask.cancel()
            (self.currentTask as? URLSessionDataTask)?.cancel()
            self.currentTask = task
        }
        task.resume()
    }
    
}




