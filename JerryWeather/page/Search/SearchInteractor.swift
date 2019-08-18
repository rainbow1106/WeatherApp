//
//  SearchInteractor.swift
//  JerryWeather
//
//  Created by 박병준 on 8/15/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import Foundation
import MapKit

protocol SearchBusinessLogic{
    
    func searchLocation(_ location: String?)
    func getDataList() -> [MKMapItem]
    func saveLocation(cellData: MKMapItem, success: () -> Void)
}

protocol SearchDataStore {
    
}

final class SearchInteractor: NSObject, SearchBusinessLogic, SearchDataStore{
    
    var presenter: SearchPresentLogic?
    private var worker = SearchWorker()
    
    private var dataList = [MKMapItem]()
    
    
    func getDataList() -> [MKMapItem] {
        return self.dataList
    }
    func searchLocation(_ location: String?) {
        
        self.dataList.removeAll()
        guard let uLocation = location,
            uLocation.count > 0 else{
                
                self.presenter?.presentSearchResult()
                return
        }
        
        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = uLocation
        let search = MKLocalSearch(request: req)
        
        search.start { (response, rError) in
            
            guard let uResponse = response else{
                self.presenter?.presentSearchResult()
                return
            }
            
            self.dataList = uResponse.mapItems
            self.presenter?.presentSearchResult()
            
        }
        
    }
    
    
    func saveLocation(cellData: MKMapItem, success: () -> Void) {
        
        
        let lat = cellData.placemark.coordinate.latitude
        let lon = cellData.placemark.coordinate.longitude
        
        var list = [String]()
        if let uList = UserDefaults.standard.array(forKey: JWAStoredLocationKey) as? [String]{
            list = uList
        }
        
        let haveLocationInfo = list.contains {
            
            var flag = false
            let tempList = $0.components(separatedBy: ",")
            guard tempList.count == 3 else{
                return flag
            }
            let rawLat = tempList[1]
            let rawLon = tempList[2]
            let savedLat = Double(rawLat)
            let savedLon = Double(rawLon)
            
            if lat == savedLat &&
                lon == savedLon{
                flag = true
            }
            return flag
        }
        
        if haveLocationInfo{
            
            CommonVManager.showConfirmAlert(msg: "이미 저장되어있습니다.")
            return
            
        }
        
        var idx = 1
        if let lastIdx = list.last?.components(separatedBy: ",").first,
            let lastIntValue = Int(lastIdx){
            
            idx = lastIntValue + 1
        }
        
        let locationText = "\(idx),\(lat),\(lon)"
        list.append(locationText)
        UserDefaults.standard.set(list, forKey: JWAStoredLocationKey)
        success()
        
    }
}
