//
//  ≈
//  JerryWeather
//
//  Created by 박병준 on 2019. 8. 7..
//  Copyright © 2019년 박병준. All rights reserved.
//

import Foundation
import MapKit

protocol ListBusinessLogic{
    
    func loadLocalWeatherList()
    func getCellDataList() -> [DPWeatherData]
    func removeLocalItem(cellDataIdx: Int)
}

protocol ListDataStore{
    
    func getLocationList() -> [CLLocation]
    
}

final class ListInteractor: NSObject, ListBusinessLogic, ListDataStore{
    var presenter: ListPresentLogic?
    
    var worker = ListWorker()
    
    lazy private var locManager = CLLocationManager()
    private var dataList = [DPWeatherData]()
    
    private let dispatchGroup = DispatchGroup()
    
    private var isFirst = true
    private var isLoadedCurrentLocation = false
    
    func getCellDataList() -> [DPWeatherData] {
        return self.dataList
    }
    func loadLocalWeatherList() {
        
        self.loadStoredLocationList()
        guard self.isFirst else{
            return
        }
        self.isFirst = false
        self.startLocation()
        
    }
    
    // 현재 지역 정보 가져오기
    func startLocation(){
        
        guard CLLocationManager.locationServicesEnabled() else{
            
            CommonVManager.showConfirmAlert(msg: "지역정보에 대한 권한동의가 없어 진행을 할 수가 없습니다.")
            return
        }
        
        self.locManager.delegate = self
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locManager.requestAlwaysAuthorization()
        self.locManager.startUpdatingLocation()
        
    }
    
    func loadStoredLocationList(){
        
        self.dataList = self.dataList.filter {
            $0.isCurrentLocation
        }
        let locationList = self.worker.getLocalList()
        
        for ii in 0 ..< locationList.count{
            
            let location = locationList[ii]
            
            self.dispatchGroup.enter()
            
            self.afterLocationLoadWork(location,
                                       isCurrentLocation: false,
                                       idx: ii + 1,
                                       success: {
                                        
                                        self.dispatchGroup.leave()
                                        
            },
                                       fail: {
                                        
                                        self.dispatchGroup.leave()
                                        
            })
        }
        
        
        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            self.presenter?.presentWeather()
        }
        
    }
    func afterLocationLoadWork(_ location: CLLocation,
                               isCurrentLocation: Bool,
                               idx: Int,
                               success: @escaping () -> Void,
                               fail: @escaping () -> Void){
        
        self.worker.loadWeatherData(
            location: location,
            isCurrentLocation: isCurrentLocation,
            success: { (rDic) in
                
                let response = ListModel.FetchWeather.Response(rawWeatherDic: rDic)
                self.worker.getCityName(location: location,
                                        completion: { (locationName) in
                                            
                                            let cellData = self.worker
                                                .parseListData(
                                                    listModel: response,
                                                    location: location,
                                                    isCurrentLocation: isCurrentLocation,
                                                    idx: idx,
                                                    cityName: locationName)
                                            
                                            if isCurrentLocation{
                                                self.dataList = self.dataList.filter({
                                                    $0.isCurrentLocation == false
                                                })
                                            }
                                            self.dataList.append(cellData.viewData)
                                            self.sortDataList()
                                            success()
                },
                                        fail: {
                                            fail()
                })
        },
            fail: {
                
                fail()
        })
    }
    func removeLocalItem(cellDataIdx: Int) {
        
        guard var uList = UserDefaults.standard.array(forKey: JWAStoredLocationKey) as? [String] else{
            return
        }
        
        uList = uList.filter({
            let savedIdx = $0.components(separatedBy: ",").first
            return String(cellDataIdx) != savedIdx
        })
        UserDefaults.standard.set(uList, forKey: JWAStoredLocationKey)
        self.loadStoredLocationList()
    }
    
    private func sortDataList(){
        
        self.dataList.sort { (prev, next) -> Bool in
            prev.idx < next.idx
        }
    }
    
    func getLocationList() -> [CLLocation] {
    
        return self.dataList.map {
            $0.location
        }
        
    }
    
}



extension ListInteractor: CLLocationManagerDelegate{
    
    private func calculateLocationNeedUpdate(newLocation: CLLocation) -> Bool{
        
        var rFlag = true
        guard let lastLocation = UserDefaults.standard.string(forKey: JWALastCurrentLocation) else{
            return rFlag
        }
        
        let list = lastLocation.components(separatedBy: ",")
        guard list.count == 2 else{
            return rFlag
        }
        
        let rawLat = list[0]
        let plat = Double(rawLat)
        let rawLon = list[1]
        let plon = Double(rawLon)
        
        guard let lat = plat,
            let lon = plon else{
                return rFlag
        }
        let oldLocation = CLLocation.init(latitude: lat, longitude: lon)
        let distance = newLocation.distance(from: oldLocation)
        
        rFlag = distance > 1000
        
        return rFlag
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let last = locations.last else{
            return
        }
        
        if self.isLoadedCurrentLocation,
            self.calculateLocationNeedUpdate(newLocation: last) == false{
            
            return
        }
        
        self.afterLocationLoadWork(last,
                                   isCurrentLocation: true,
                                   idx: 0,
                                   success: {
        
                                    let locationText = "\(last.coordinate.latitude),\(last.coordinate.longitude)"
                                    UserDefaults.standard.set(locationText, forKey: JWALastCurrentLocation)
                                    
                                    self.isLoadedCurrentLocation = true
                                    self.presenter?.presentWeather()
        },
                                   fail: {
                                    
                                    self.presenter?.presentWeather()
                                    
        })
        
    }
}
