//
//  DetailInteractor.swift
//  JerryWeather
//
//  Created by 박병준 on 8/18/19.
//  Copyright © 2019 박병준. All rights reserved.
//

import Foundation
import MapKit

protocol DetailBusinessLogic{
    
    func loadWeatherDataList(seedData: [CLLocation])
    func getDataList() -> [DetailWeatherData]
}

protocol DetailDataStore {
    
}

final class DetailInteractor: NSObject,DetailBusinessLogic,DetailDataStore{
    
    var presenter: DetailPresentLogic?
    private var worker = DetailWorker()
    private var dataList = [DetailWeatherData]()
    private var isFirst = true
    
    private let dispatchGroup = DispatchGroup()
    
    func loadWeatherDataList(seedData: [CLLocation]) {
        
        guard self.isFirst else{
            return
        }
        self.isFirst = false
        
        
        self.dataList.removeAll()
        
        for ii in 0 ..< seedData.count{
            
            self.dispatchGroup.enter()
            
            let locationInfo = seedData[ii]
            self.loadApi(
                location: locationInfo,
                         idx: ii,
                         success: {
                            
                            self.dispatchGroup.leave()
                            
            },
                         fail: {
                            
                            self.dispatchGroup.leave()
                            
            })
        }
        
        
        self.dispatchGroup.notify(queue: DispatchQueue.main) {
            
            self.dataList = self.worker.sortDataList(dataList: self.dataList)
            self.presenter?.presentResult()
            
        }
        
    }
    
    
    private func loadApi(location: CLLocation,
                         idx: Int,
                         success: @escaping () -> Void,
                         fail: @escaping () -> Void){
        
        self.worker
            .loadWeatherData(
                location: location,
                success: { (rDic) in
                    
                    let response = DetailModel.FetchDetail.Response(rawDetailDic: rDic)
                    
                    self.worker
                        .getCityName(
                            location: location,
                            completion: { (locationName) in
                                
                                let cellData = self.worker
                                    .parseListData(
                                        listModel: response,
                                        idx: idx,
                                        cityName: locationName)
                                
                                self.dataList.append(cellData.viewData)
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
    func getDataList() -> [DetailWeatherData] {
        return self.dataList
    }
}
